# projected on PC of distance of contact-pairs from two independent trajectories

import argparse as arg
import numpy as np
import mdtraj as md
from sklearn.decomposition import PCA

import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.cm as cm

parser = arg.ArgumentParser(description='compute pca for trajectory.')
parser.add_argument('xtc1',  metavar='xtc', type=str, help='file name of trajectory(XTC)')
parser.add_argument('xtc2',  metavar='xtc', type=str, help='file name of trajectory(XTC)')
parser.add_argument('pdb',   metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('pairs', metavar='txt', type=str, help='file name of contact pairs')
parser.add_argument('out',   metavar='out', type=str, help='output file name')
args = parser.parse_args()

# make map
def plot_2Dmap(x,y,xlabel,ylabel,outfilename):
    fig = plt.figure(figsize=(8,6))
    ax = fig.add_subplot(1,1,1)

    H = ax.hist2d(x,y,bins=100,cmap=cm.jet,
                  density=True, 
                  norm=mpl.colors.LogNorm())

    ax.set_xlabel(xlabel, fontsize=16)
    ax.set_ylabel(ylabel, fontsize=16)
    fig.colorbar(H[3],ax=ax)

    fig.savefig(f"{outfilename}_{xlabel}vs{ylabel}.png", 
                bbox_inches="tight", pad_inches=0.05)
    plt.show()
    return 0

# read contact pairs
contact_pairs = []
with open (args.pairs, mode="r") as f:
    for line in f:
        n, m = line.split()
        contact_pairs.append([int(n)-1,int(m)-1])

# read trajectory(1) iteratively
dist= []
for chunk in md.iterload(args.xtc1, top=args.pdb, chunk=1):
    # compute contact distances
    dist_chunk, pairs_chunk = md.compute_contacts(chunk, contact_pairs)
    dist.append(dist_chunk[0])

# read trajectory(2) iteratively
for chunk in md.iterload(args.xtc2, top=args.pdb, chunk=1):
    # compute contact distances
    dist_chunk, pairs_chunk = md.compute_contacts(chunk, contact_pairs)
    dist.append(dist_chunk[0])

# compute pc 1,2,3 for contact distances
pca_higer=PCA(n_components=3)
reduced_distance=pca_higer.fit_transform(dist)

# write pc 1, 2, 3
with open (f"{args.out}_pc.txt", mode="w") as f:
    for frame in reduced_distance:
        f.write("%8.3f %8.3f %8.3f\n" %(frame[0],frame[1],frame[2]))

# write reduced_distance as binary
np.save(f"{args.out}_reduced_distances.npy",reduced_distance)

plt.rcParams['font.family'] = 'Times New Roman'
# make 2D contour graph
plot_2Dmap(reduced_distance[:,0],reduced_distance[:,1],'PC1','PC2',args.out)
plot_2Dmap(reduced_distance[:,0],reduced_distance[:,2],'PC1','PC3',args.out)
plot_2Dmap(reduced_distance[:,1],reduced_distance[:,2],'PC2','PC3',args.out)

# compute the contributions of each eigen-values
pca=PCA()
pca.fit(dist)
ev_ratio = pca.explained_variance_ratio_
ev_ratio = np.hstack([0,ev_ratio.cumsum()])

# write eigen-value contribution
with open (f"{args.out}_evratio.txt", mode="w") as f:
    for e in ev_ratio:
        f.write("%8.3f\n" %(e))

# write pc1 components
with open (f"{args.out}_pc1.txt", mode="w") as f:
    for e in pca.components_[0]:
        f.write("%8.3f\n" %(e))

# write pc2 components
with open (f"{args.out}_pc2.txt", mode="w") as f:
    for e in pca.components_[1]:
        f.write("%8.3f\n" %(e))

# write pc3 components
with open (f"{args.out}_pc3.txt", mode="w") as f:
    for e in pca.components_[2]:
        f.write("%8.3f\n" %(e))

# make plot of eigen-value contribution
fig_ev = plt.figure()
plt.plot(ev_ratio)
plt.xlabel('Index for eigenvalue', fontsize=14)
plt.ylabel('Contribution', fontsize=14)
fig_ev.savefig(f"{args.out}_ev-ratio(PCA).png", bbox_inches="tight", pad_inches=0.05)
plt.show()
