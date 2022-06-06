# calculate Calpha-Clapha distance of pairs that satisfies
# | x_i^closest-heavy - x_j^closest-heavy | <= 4.5 A && | i-j | > 3
# in the reference structure

import argparse as arg
import numpy as np
import mdtraj as md

parser = arg.ArgumentParser(description='compute pca for trajectory.')
parser.add_argument('xtc', metavar='xtc', type=str, help='file name of trajectory(XTC)')
parser.add_argument('pdb', metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('out_dist', metavar='out', type=str, help='output file name (distances)')
args = parser.parse_args()

# cutt-off (0.80 nm)
d_cutoff = 0.80

# read trajectory
t = md.load(args.xtc,top=args.pdb)

# get the pair indicides of contact atoms
contact_pairs = [[3,59],[3,62],[31,105],[20,140],[21,140],[31,104],[3,28],[31,106],[20,141],[3,63],[7,66],[6,70],[21,141],[34,105],[31,102],[6,11],[3,70],[7,63],[31,103],[3,67],[7,12],[2,66],[7,11],[10,29],[29,103],[21,104],[65,69]]

# compute contact distances
dist, pairs = md.compute_contacts(t, contact_pairs)

# write Calpha-Calpha distances
with open (args.out_dist, mode="w") as f:
    for frame in dist:
        for d in frame:
            f.write("%8.3f" %(d))
        f.write("\n")
