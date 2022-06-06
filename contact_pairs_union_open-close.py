# get residue--residue of contact pairs 

import argparse as arg
import numpy as np
import mdtraj as md

parser = arg.ArgumentParser(description='contact residue-residue pairs of pdb.')
parser.add_argument('pdb_state1', metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('pdb_state2', metavar='PDB', type=str, help='file name of topology file(PDB)')
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
r1 = md.load(args.pdb_state1)
r2 = md.load(args.pdb_state2)

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
with open (args.out, mode="w") as f:
    for pair in contact_pairs:
        f.write("%4d %4d\n" %(pair[0]+1, pair[1]+1))
