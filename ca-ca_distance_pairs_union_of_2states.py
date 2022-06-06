# get residue--residue pairs that satisfie the condition
# | x_i^C-alpha - x_j^C-alpha | <= 8.0 A && | i-j | > 4.

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

# read pdb1
p1 = md.load(args.pdb_state1)
# read pdb2
p2 = md.load(args.pdb_state2)

#if p1.toplogy != p2.topology:
#    print("PDB1 and PDB2 are different!")
#    print(p1.topology)
#    print(p2.topology)
#    exit

# get the indicides of all of Calpha atoms
alpha_indices = p1.topology.select_atom_indices("alpha")

# get the pair indicides of Calpha-Calpha atoms
pairs = [ ]
for atom_i in alpha_indices:
    for atom_j in alpha_indices:
        res_i = p1.topology.atom(atom_i).residue.index
        res_j = p1.topology.atom(atom_j).residue.index
        if res_j - res_i > ij_min :
            pairs.append((atom_i,atom_j))

# compute the Calpha-Calpha distances (pdb1)
dist_p1 = md.compute_distances(p1, pairs)
# compute the Calpha-Calpha distances (pdb2)
dist_p2 = md.compute_distances(p2, pairs)

# get the pair indicides of Calpha-Calpha atoms (pdb1)
contact_pairs_atmindices_p1 = [ ]
contact_pairs_resindices_p1 = [ ]
for i, d in enumerate(dist_p1[0]):
    if d < d_cutoff:
        contact_pairs_atmindices_p1.append(pairs[i])

        resi = p1.topology.atom(pairs[i][0]).residue.index
        resj = p1.topology.atom(pairs[i][1]).residue.index
        contact_pairs_resindices_p1.append((resi, resj))

# get the pair indicides of Calpha-Calpha atoms (pdb2)
contact_pairs_atmindices_p2 = [ ]
contact_pairs_resindices_p2 = [ ]
for i, d in enumerate(dist_p2[0]):
    if d < d_cutoff:
        contact_pairs_atmindices_p2.append(pairs[i])

        resi = p2.topology.atom(pairs[i][0]).residue.index
        resj = p2.topology.atom(pairs[i][1]).residue.index
        contact_pairs_resindices_p2.append((resi, resj))

#print(contact_pairs_resindices_p1)

contact_pairs = sorted(list(set(contact_pairs_resindices_p1).union(set(contact_pairs_resindices_p2))))

# write contact pairs
with open (args.out, mode="w") as f:
    for i, pair in enumerate(contact_pairs):
        f.write("%4d %4d\n" %(pair[0]+1, pair[1]+1))

