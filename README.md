# Plasma
This repository contains code and data for analyzing phase transitions in 2D plasma crystals using structural order parameters and defect analysis.

Description
The plasma crystals are formed by micron-sized particles suspended in an argon gas discharge. As the discharge voltage increases, the particles self-organize into a crystalline lattice. At higher voltages, the crystal eventually melts into a disordered liquid state.

This project aims to characterize the phase transition between solid and liquid states using:

Quantitative image analysis of particle configurations
Calculation of structural order parameters
Identification of topological defects
Key diagnostics include:

Radial distribution function g(r)
Bond orientational order parameter ψ6
Static structure factor S(k)
Topological defect concentrations from Voronoi tessellation
By tracking these metrics during melting, signatures of phase coexistence and spatial heterogeneity across the transition can be identified.

Usage

The code folder contains MATLAB scripts:

CSV_to_Struct.m: Converts tracked particle data to MATLAB structures(use this to convert your CSV Data to Matlab Structure)

g_r.m: Function to compute radial distribution function g(r)
G_R_IPD.m: Uses g_r.m to compute average g(r) over frames and finds the interparticle distance

bondorder_2d.m: Calculates bond order parameter ψ6

structure_factor_2d_basic.m: Computes static structure factor S(k)

defect_plot.m: Identifies topological defects via Voronoi tessellation

License

This project is licensed under the  GNU AFFERO GENERAL PUBLIC LICENSE - see the LICENSE file for details.
