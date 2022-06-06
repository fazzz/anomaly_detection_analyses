# get residue--residue of contact pairs 

import argparse as arg
import numpy as np
import mdtraj as md

parser = arg.ArgumentParser(description='contact residue-residue pairs of pdb.')
parser.add_argument('pdb', metavar='PDB', type=str, help='file name of PDB file')
parser.add_argument('out', metavar='out', type=str, help='output file name')
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

# read trajectory
p = md.load(args.pdb)

# compute contact(closese-heavy atom, min_dist 2.0nm)
dist, pairs = md.compute_contacts(p)

# get the pair indicides of contact atoms
contact_pairs = [ ]
for i, d in enumerate(dist[0]):
    if d < d_cutoff and abs(pairs[i,0] - pairs[i,1]) > ij_min:
        contact_pairs.append(pairs[i])

# write contact pairs
with open (args.out, mode="w") as f:
    for pair in contact_pairs:
        f.write("%4d %4d\n" %(pair[0]+1, pair[1]+1))
