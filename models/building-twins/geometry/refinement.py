import os
import numpy as np
import gmsh # https://gmsh.info/dev/doc/texinfo/gmsh.pdf#Gmsh%20application%20programming%20interface
# mesh refinement: https://gitlab.onelab.info/gmsh/gmsh/blob/gmsh_4_8_3/tutorial/python/t10.py

# find the path to the default geo file using os 
dirname = os.path.dirname(__file__) # need to redefine if we choose to relocate this file (__file__)
geo_file = os.path.join(dirname, 'g1_default.geo')
output_file = os.path.join(dirname, 'g1_refined.geo')

def refine_mesh(geo_file=geo_file, output_file=output_file, lc_wall=0.01, lc_bulk=0.1):
    gmsh.initialize()
    gmsh.open(geo_file) # creates the model
    gmsh.model.setFileName("g1_refined.geo")
    # We want to refine near every surface, so we define a Field[1] measuring the distance from every physical surface.
    physical_surfaces = gmsh.model.getPhysicalGroups(2)
    surface_list = []
    for s in physical_surfaces:
        surface_list.extend(
            gmsh.model.getEntitiesForPhysicalGroup(2,s[1])
        )
    gmsh.model.mesh.field.add("Distance", 1) # define Field[1] (see https://gmsh.info/doc/texinfo/gmsh.html#Gmsh-mesh-size-fields)
    gmsh.model.mesh.field.setNumbers(1, "SurfacesList", surface_list) # only occ and discrete surfaces (coming from STL, for instance) are currently supported
    # gmsh.model.mesh.field.setNumber(1, )

    gmsh.model.mesh.field.add("Threshold", 2)
    gmsh.model.mesh.field.setNumber(2, "InField", 1)
    gmsh.model.mesh.field.setNumber(2, "SizeMin", 1)
    gmsh.model.mesh.field.setNumber(2, "SizeMax", 1)
    gmsh.model.mesh.field.setNumber(2, "DistMin", 0.15)
    gmsh.model.mesh.field.setNumber(2, "DistMax", 0.5)
    
    gmsh.model.geo.synchronize()
    gmsh.write(output_file) # writes the model to a file
    gmsh.finalize()