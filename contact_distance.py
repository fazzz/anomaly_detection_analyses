# calculate Calpha-Clapha distance of pairs that satisfies
# | x_i^closest-heavy - x_j^closest-heavy | <= 4.5 A
# in the reference structure

import argparse as arg
import numpy as np
import mdtraj as md

parser = arg.ArgumentParser(description='compute pca for trajectory.')
parser.add_argument('xtc', metavar='xtc', type=str, help='file name of trajectory(XTC)')
parser.add_argument('pdb', metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('out_pairs', metavar='out', type=str, help='output file name (pairs)')
parser.add_argument('out_dist', metavar='out', type=str, help='output file name (distances)')
args = parser.parse_args()

# cutt-off (0.45 nm)
d_cutoff = 0.45

# read trajectory
t = md.load(args.xtc,top=args.pdb)
# read reference structure
p = md.load(args.pdb)

# compute contact(closese-heavy atom, min_dist 2.0nm)
dist, pairs = md.compute_contacts(p)

# get the pair indicides of contact atoms
contact_pairs = [ ]
for i, d in enumerate(dist[0]):
    if d < d_cutoff:
        contact_pairs.append(pairs[i])

# write contact pairs
with open (args.out_pairs, mode="w") as f:
    for pair in contact_pairs:
        f.write("%4d %4d\n" %(pair[0]+1, pair[1]+1))

# compute contact distances
dist, pairs = md.compute_contacts(t, contact_pairs)

# write Calpha-Calpha distances
with open (args.out_dist, mode="w") as f:
    for frame in dist:
        for d in frame:
            f.write("%8.3f" %(d*10.0))
        f.write("\n")
