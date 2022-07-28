# show indices of dihedral angles (phi, psi)

import argparse
import mdtraj as md
import numpy as np

parser = argparse.ArgumentParser(description='calc. dihedral angles of traj.')

parser.add_argument('pdb', metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('out', metavar='out', type=str, help='indices file name sin / cos of phi / psi')

args = parser.parse_args()

# read the reference topology
r = md.load(args.pdb)

# get atomic indices of phi/psi
indices_h, _ = md.compute_phi(r)
indices_s, _ = md.compute_psi(r)

# write indices of  sin / cos of phi and psi
with open (args.out, mode="w") as f:
    for pairs in indices_h:
        i = r.topology.atom(pairs[2]).residue.index + 1
        f.write("sin phi %4d \ncos phi %4d\n" %(i,i))
    for pairs in indices_s:
        i = r.topology.atom(pairs[2]).residue.index + 1
        f.write("sin psi %4d \ncos psi %4d\n" %(i,i))

