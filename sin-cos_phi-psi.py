# calculate sin and cos of dihedral angles (phi, psi)

import argparse
import mdtraj as md
import numpy as np

parser = argparse.ArgumentParser(description='calc. dihedral angles of traj.')

parser.add_argument('xtc', metavar='XTC', type=str, help='file name of XTC')
parser.add_argument('pdb', metavar='PDB', type=str, help='file name of topology file(PDB)')
parser.add_argument('out', metavar='out', type=str, help='output file name sin / cos of phi / psi')

args = parser.parse_args()

# read trajectory iteratively
angle = []
for chunk in md.iterload(args.xtc, top=args.pdb, chunk=10):
    _, h = md.compute_phi(chunk)
    _, s = md.compute_psi(chunk)
    angle.append(h[0])
    angle.append(s[0])

# write sin / cos of phi and psi
with open (args.out, mode="w") as f:
    for frame in angle:
        for p in frame:
            f.write("%8.3f %8.3f " %(np.sin(p), np.cos(p)))
        f.write("\n")
