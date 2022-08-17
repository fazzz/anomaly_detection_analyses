# Make 2D map of PC1 vs PC2, PC1 vs PC3, PC2 vs PC3

import argparse as arg
import numpy as np

import matplotlib as mpl
import matplotlib.pyplot as plt
import matplotlib.cm as cm

parser = arg.ArgumentParser(description='Make 3D plot of pc1vspc2, pc1vspc3, pc2vspc3.')
parser.add_argument('npy',  metavar='reduced_dat', type=str, help='pc1,2,3')
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

# write reduced_distance as binary
reduced_distance = np.load(args.npy)

#plt.rcParams['font.family'] = 'Times New Roman'
# make 2D contour graph
plot_2Dmap(reduced_distance[:,0],reduced_distance[:,1],'PC1','PC2',args.out)
plot_2Dmap(reduced_distance[:,0],reduced_distance[:,2],'PC1','PC3',args.out)
plot_2Dmap(reduced_distance[:,1],reduced_distance[:,2],'PC2','PC3',args.out)
