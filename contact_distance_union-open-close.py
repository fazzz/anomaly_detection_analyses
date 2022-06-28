# calculate Calpha-Clapha distance of pairs that satisfies
# | x_i^closest-heavy - x_j^closest-heavy | <= 4.5 A
# in the reference structure

import argparse as arg
import numpy as np
import mdtraj as md

parser = arg.ArgumentParser(description='compute pca for trajectory.')
parser.add_argument('xtc', metavar='xtc', type=str, help='file name of trajectory(XTC)')
parser.add_argument('pdb_state1', metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('pdb_state2', metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('out_pairs', metavar='out', type=str, help='output file name (pairs)')
parser.add_argument('out_dist', metavar='out', type=str, help='output file name (distances)')
parser.add_argument('--cutoff', metavar='float', type=float, help='cutoff')
parser.add_argument('--ij', metavar='int', type=int, help='i_j_min')
args = parser.parse_args()

# cutt-off (default 0.45 nm)
if args.cutoff is None:
    d_cutoff = 0.45
else:
    d_cutoff = args.cutoff

# | i-j | > ij_min (default 4)
if args.ij is None:
    ij_min = 4
else:
    ij_min = args.ij

## read trajectory
#t = md.load(args.xtc,top=args.pdb_state1)

# read reference structure
r1 = md.load(args.pdb_state1)
# read reference structure
r2 = md.load(args.pdb_state2)

#if r1.toplogy != r2.topology:
#    print("PDB1 and PDB2 are different!")
#    print(r1.topology)
#    print(r2.topology)
#    exit

# compute contact(closese-heavy atom, min_dist 2.0nm)
dist_r1, pairs_r1 = md.compute_contacts(r1)
dist_r2, pairs_r2 = md.compute_contacts(r2)

# get the pair indicides of contact atoms
contact_pairs_r1 = [ ]
for i, d in enumerate(dist_r1[0]):
    if d < d_cutoff and abs(pairs_r1[i,0] - pairs_r1[i,1]) > ij_min:
        contact_pairs_r1.append((pairs_r1[i,0],pairs_r1[i,1]))

contact_pairs_r2 = [ ]
for i, d in enumerate(dist_r2[0]):
    if d < d_cutoff and abs(pairs_r2[i,0] - pairs_r2[i,1]) > ij_min:
            contact_pairs_r2.append((pairs_r2[i,0],pairs_r2[i,1]))

contact_pairs = sorted(list(set(contact_pairs_r1).union(set(contact_pairs_r2))))

# write contact pairs
with open (args.out_pairs, mode="w") as f:
    for pair in contact_pairs:
        f.write("%4d %4d\n" %(pair[0]+1, pair[1]+1))

# read trajectory iteratively
dist= []
for chunk in md.iterload(args.xtc, top=args.pdb_state1, chunk=10):
    # compute contact distances
    dist_chunk, pairs_chunk = md.compute_contacts(chunk, contact_pairs)
    dist.append(dist_chunk[0])

# write contact distances
with open (args.out_dist, mode="w") as f:
    for frame in dist:
        for d in frame:
            f.write("%8.3f " %(d*10.0))
        f.write("\n")

#############################################
# # write contact distances                 #
# with open (args.out_dist, mode="w") as f: #
#     for frame in dist[0]:                 #
#         for d in frame:                   #
#             f.write("%8.3f " %(d*10.0))   #
#         f.write("\n")                     #
#############################################
