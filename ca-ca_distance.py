# calculate Calpha-Clapha distance of pairs that satisfies
# | x_i^C-alpha - x_j^C-alpha | <= 8.0 A && | i-j | > 4
# in the reference structure

import argparse as arg
import numpy as np
import mdtraj as md

parser = arg.ArgumentParser(description='compute pca for trajectory.')
parser.add_argument('xtc', metavar='xtc', type=str, help='file name of trajectory(XTC)')
parser.add_argument('pdb', metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('out', metavar='out', type=str, help='output file name')
args = parser.parse_args()

# cutt-off (0.80 nm)
d_cutoff = 0.80

# read trajectory
t = md.load(args.xtc,top=args.pdb)
# read reference structure
r = md.load(args.pdb)

# get the indicides of all of Calpha atoms
alpha_indices = r.topology.select_atom_indices("alpha")

# get the pair indicides of Calpha-Calpha atoms
pairs = [ ]
for atom_i in alpha_indices:
    for atom_j in alpha_indices:
        res_i = r.topology.atom(atom_i).residue.index
        res_j = r.topology.atom(atom_j).residue.index
        if res_j - res_i > 4 :
            pairs.append((atom_i,atom_j))

# compute the Calpha-Calpha distances
dist = md.compute_distances(r, pairs)

# get the pair indicides of Calpha-Calpha atoms
contact_pairs = [ ]
for i, d in enumerate(dist[0]):
    if d < d_cutoff:
        contact_pairs.append(pairs[i])

# compute Calpha-Calpha distances
dist = md.compute_distances(t, contact_pairs)

# write Calpha-Calpha distances
with open (args.out, mode="w") as f:
    for frame in dist:
        for d in frame:
            f.write("%8.3f" %(d))
        f.write("\n")
