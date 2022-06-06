# get residue--residue pairs that satisfie the condition
# | x_i^C-alpha - x_j^C-alpha | <= 8.0 A && | i-j | > 4.

import argparse as arg
import numpy as np
import mdtraj as md

parser = arg.ArgumentParser(description='contact residue-residue pairs of pdb.')
parser.add_argument('pdb', metavar='PDB', type=str, help='file name of PDB file')
parser.add_argument('out', metavar='out', type=str, help='output file name')
parser.add_argument('--cutoff', metavar='float', type=float, help='cutoff')
parser.add_argument('--ij', metavar='int', type=int, help='i_j_min')
args = parser.parse_args()

# cutt-off (default 0.80 nm)
if args.cutoff is None:
    d_cutoff = 0.80
else:
    d_cutoff = args.cutoff

# | i-j | > ij_min (default 4)
if args.ij is None:
    ij_min = 4
else:
    ij_min = args.ij

# read pdb
p = md.load(args.pdb)

# get the indicides of all of Calpha atoms
alpha_indices = p.topology.select_atom_indices("alpha")

# get the pair indicides of Calpha-Calpha atoms
pairs = [ ]
for atom_i in alpha_indices:
    for atom_j in alpha_indices:
        res_i = p.topology.atom(atom_i).residue.index
        res_j = p.topology.atom(atom_j).residue.index
        if res_j - res_i > ij_min :
            pairs.append((atom_i,atom_j))

# compute the Calpha-Calpha distances
dist = md.compute_distances(p, pairs)

# get the pair indicides of Calpha-Calpha atoms
contact_pairs_atmindices = [ ]
contact_pairs_resindices = [ ]
for i, d in enumerate(dist[0]):
    if d < d_cutoff:
        contact_pairs_atmindices.append(pairs[i])

        resi = p.topology.atom(pairs[i][0]).residue.index
        resj = p.topology.atom(pairs[i][1]).residue.index
        contact_pairs_resindices.append((resi, resj))

# write contact pairs
with open (args.out, mode="w") as f:
    for i, pair in enumerate(contact_pairs_resindices):
        f.write("%4d %4d %4d %4d\n" %(pair[0]+1, pair[1]+1, contact_pairs_atmindices[i][0]+1, contact_pairs_atmindices[i][1]+1))

