import os
import argparse
import numpy as np
import gmsh  # https:#gmsh.info/dev/doc/texinfo/gmsh.pdf#Gmsh%20application%20programming%20interface

# mesh refinement: https:#gitlab.onelab.info/gmsh/gmsh/blob/gmsh_4_8_3/tutorial/python/t10.py
from icecream import ic

# find the path to the default geo file using os
dirname = os.path.dirname(
    __file__
)  # need to redefine if we choose to relocate this file (__file__)
geo_file = os.path.join(dirname, "g1_default.geo")
output_file = os.path.join(dirname, "g1_refined.geo")

# SHARED GEOMETRIC PARAMETERS
member_to_meters = 1.67  # length in meters of each member of structure
# horizontal distances to outside of ledges
w1 = 21 * member_to_meters
w2 = 13 * member_to_meters
w3 = 7 * member_to_meters
# horizontal distances to inside of ledges
b0 = 26 * member_to_meters
b1 = 27 * member_to_meters
b2 = 19 * member_to_meters
b3 = 11 * member_to_meters
# height of walls
h0 = 6.38 * member_to_meters
h1 = 3 * np.sqrt(2) * member_to_meters
h2 = 3 * np.sqrt(2) * member_to_meters
h3 = 2.5 * np.sqrt(2) * member_to_meters
hout = 1.25 / 2 * np.sqrt(2) * member_to_meters  # height of outlet

z0 = -3.285  #  signed depth of building below ground level
z1 = z0 + h0  #  height level 1 from ground
z2 = z1 + h1  #  height level 2 from ground
z3 = z2 + h2  #  height level 3 from ground
z4 = z3 + h3  #  height level 4 from ground
zout = z4 - hout  #  height of outlet bottom from ground
frac = (h3 - hout) / h3  #  fraction of height of h3 that is outlet
xout = (frac * w3 + (1 - frac) * b3) / 2  #  x-coordinate of outlet

# exterior dimensions
boxh = 45  #        height of bounding box above ground level (z>0)
boxw = 60  #         width of bounding box
boxz = -6  #  signed depth of bounding box below ground level (z<0)
wth = 1.0  # wall thickness
# angles for computing exterior points
alpha1 = np.arctan(h1 / ((b1 - w1) / 2))
beta1 = np.pi / 4 - alpha1 / 2
alpha2 = np.arctan(h2 / ((b2 - w2) / 2))
beta2 = np.pi / 4 - alpha2 / 2
alpha3 = np.arctan(h3 / ((b3 - w3) / 2))
beta3 = np.pi / 4 - alpha3 / 2


def geometry1_unstructured(output_file, lc_wall=0.01, lc_bulk=0.1):
    gmsh.initialize()
    gmsh.model.add("g1")
    # LABELING SCHEME__________________________________________#
    # label: a four-digit code of the form [ | | | ]
    #                                       ^ ^ ^ ^
    #                                       G H I D
    # where:
    # [ ]:__ PROPERTY __| ASSIGNMENT: VALUE => SIGNIFICANCE _________________________________|
    # G :    "group"   | 1=> INTERIOR, 2=> ENVELOPE, 3=> EXTERIOR, 8=> AIR, 9=> GROUND      |
    # H :  "elevation" | (0,1,...) => 0=lowest, 1=next, ...                                 |
    # I : "identifier" | e.g. 0=> wall, 1=> base (|x|=|y|=b{H]), 2=> width (|x|=|y|=w[H])   |
    # D :  "direction" | 0=> DIRECTIONLESS, (1,3,5,7)=> (NE,NW,SW,SE), (2,4,6,8)=> (N,W,S,E)|
    # --------------------------------------------------------------------------------------[]
    # Note 1: "direction" is not *literal* : e.g. "north" is not precisely 0° from true north.
    # ==============================================================#
    # FIGURES__________________________________________________#
    # 1.(a) elevation view
    # (****) => Point; [****] => Line; <--> => length (see VARIABLES)
    # ___________SOUTH[6]_________|_________NORTH[2]______|
    # _wall heights_              ^ (z-> oo) : "up"   __levels__
    #                        <---w3---->
    #     _           (1406)____________(1402)            _z4
    #    h3|               /       (1322)\ outlet (fig 2) |
    #     _|       (1306)_/<-----b3-----> \_(1302)        _z3
    #    h2|            /<(1316)-w2-(1312)> \             |
    #     _|    (1206)_/<--------b2--------->\_(1202)     _z2
    #    h1|         /<-(1216)---w1----(1212)->\          |
    #     _| (1106) /                           \(1102)   _z1
    #      |       |<------------b1------------->|        |
    #    h0|      _|(1016)                 (1012)|_       _z=0
    #     _| (1006)|_____________________________|(1002)  _z0
    #
    # 2. outlet detail
    # ...________(1402) _ _ _ _ _ _ _ ___z4
    #   [1400]    ⟍⟍                  |
    #               ⟍⟍ [1322]         |
    #                 ⟍⟍              |
    #             (1322)⟍⟍ _ _ _ _ _ _|_zout
    #                     ⟍            |
    #                       ⟍ [1312]   |
    #                         ⟍        |
    #                           ⟍(1312)_z3
    # I. POINT DICTIONARY-----------
    # i. @ level z=z0:
    gmsh.model.occ.addPoint(b1 / 2, 0, z0, lc_bulk, 1002)
    gmsh.model.occ.addPoint(-b1 / 2, 0, z0, lc_bulk, 1006)
    # ii. @ level z=0:
    gmsh.model.occ.addPoint(b1 / 2, 0, 0, lc_bulk, 1012)
    gmsh.model.occ.addPoint(-b1 / 2, 0, 0, lc_bulk, 1016)
    # iii. @ level z=z1:
    gmsh.model.occ.addPoint(b1 / 2, 0, z1, lc_bulk, 1102)
    gmsh.model.occ.addPoint(-b1 / 2, 0, z1, lc_bulk, 1106)
    # iv. @ level z=z2, |x| = w1/2:
    gmsh.model.occ.addPoint(w1 / 2, 0, z2, lc_bulk, 1202)
    gmsh.model.occ.addPoint(-w1 / 2, 0, z2, lc_bulk, 1206)
    # v. @ level z=z2, |x| = b2/2:
    gmsh.model.occ.addPoint(b2 / 2, 0, z2, lc_bulk, 1212)
    gmsh.model.occ.addPoint(-b2 / 2, 0, z2, lc_bulk, 1216)
    # vi. @ level z=z3, |x| = w2/2:
    gmsh.model.occ.addPoint(w2 / 2, 0, z3, lc_bulk, 1302)
    gmsh.model.occ.addPoint(-w2 / 2, 0, z3, lc_bulk, 1306)
    # vii. @ level z=z3, |x| = b3/2:
    gmsh.model.occ.addPoint(b3 / 2, 0, z3, lc_bulk, 1312)
    gmsh.model.occ.addPoint(-b3 / 2, 0, z3, lc_bulk, 1316)
    # viii. @ level z=z4, |x| = w3/2:
    gmsh.model.occ.addPoint(w3 / 2, 0, z4, lc_bulk, 1402)
    gmsh.model.occ.addPoint(-w3 / 2, 0, z4, lc_bulk, 1406)
    # ix. bottom outlet point
    gmsh.model.occ.addPoint(xout, 0, zout, lc_bulk, 1322)
    # II. LINE DICTIONARY-----------
    # i. @ level z=z0:
    gmsh.model.occ.addLine(1002, 1006, 1000)
    # ii. profile lines from level z=z0 to z=0, |x| = b1/2:
    gmsh.model.occ.addLine(1002, 1012, 1002)
    gmsh.model.occ.addLine(1006, 1016, 1006)
    # iii. profile lines from level z=0 to z=z1, |x| = b1/2:
    gmsh.model.occ.addLine(1012, 1102, 1012)
    gmsh.model.occ.addLine(1016, 1106, 1016)
    # iv. profile lines from level z=z1, |x| = b1/2, to z=z2, |x|=w1/2:
    gmsh.model.occ.addLine(1102, 1202, 1102)
    gmsh.model.occ.addLine(1106, 1206, 1106)
    # v. profile lines from level z=z2, |x|=w1/2, to z=z2, |x|=b2/2:
    gmsh.model.occ.addLine(1202, 1212, 1202)
    gmsh.model.occ.addLine(1206, 1216, 1206)
    # vi. profile lines from level z=z2, |x|=b2/2, to z=z3, |x|=w2/2:
    gmsh.model.occ.addLine(1212, 1302, 1212)
    gmsh.model.occ.addLine(1216, 1306, 1216)
    # vii. profile lines from level z=z3, |x|=w2/2, to z=z3, |x|=b3/2:
    gmsh.model.occ.addLine(1302, 1312, 1302)
    gmsh.model.occ.addLine(1306, 1316, 1306)
    # viii. profile lines from level z=z3, |x|=b3/2, to z=z4, |x|=w3/2:
    gmsh.model.occ.addLine(1312, 1322, 1312)  # below the outlet
    gmsh.model.occ.addLine(1322, 1402, 1322)  # outlet
    gmsh.model.occ.addLine(1316, 1406, 1316)
    # ix. @level z=z4:
    gmsh.model.occ.addLine(1402, 1406, 1400)
    # III. CURVELOOP DICTIONARY-----------
    gmsh.model.occ.addCurveLoop(
        [
            1000,
            1002,
            1012,
            1102,
            1202,
            1212,
            1302,
            1312,
            1322,
            1400,
            1316,
            1306,
            1216,
            1206,
            1106,
            1016,
            1006,
        ],
        1000,
    )
    gmsh.model.occ.addPlaneSurface([1000], 1000)
    gmsh.model.occ.synchronize()

    # make a boundary layer (see https:#gitlab.onelab.info/gmsh/gmsh/blob/master/examples/api/naca_boundary_layer_2d.py#L122)
    f = gmsh.model.mesh.field.add("BoundaryLayer")
    gmsh.model.mesh.field.setNumbers(
        f,
        "CurvesList",
        [
            1000,
            1002,
            1012,
            1102,
            1202,
            1212,
            1302,
            1312,
            1322,
            1400,
            1316,
            1306,
            1216,
            1206,
            1106,
            1016,
            1006,
        ],
    )
    gmsh.model.mesh.field.setNumber(f, "Size", lc_wall)
    gmsh.model.mesh.field.setNumber(f, "Ratio", 2)
    gmsh.model.mesh.field.setNumber(f, "Quads", 1)  # recombines quads
    gmsh.model.mesh.field.setNumber(f, "Thickness", lc_wall * 10)
    # if not rounded:
    #     # create a fan at the trailing edge
    #     gmsh.option.setNumber('Mesh.BoundaryLayerFanElements', 7)
    #     gmsh.model.mesh.field.setNumbers(f, 'FanPointsList', [pt])

    gmsh.model.mesh.field.setAsBoundaryLayer(f)

    h = 1.0
    # extrude for OpenFOAM: [(dim, tag)],dx,dy,dz,numElements,heights,recombine
    ov = gmsh.model.occ.extrude([(2, 1000)], 0, h, 0, [1], [1], True)
    gmsh.model.occ.synchronize()

    gmsh.model.addPhysicalGroup(2, [1000], 1004, "back")
    gmsh.model.addPhysicalGroup(2, [ov[0][1]], 1008, "front")
    gmsh.model.addPhysicalGroup(2, [ov[2][1]], 1000, "bottom")
    gmsh.model.addPhysicalGroup(2, [ov[3][1]], 1006, "southBelow")
    gmsh.model.addPhysicalGroup(2, [ov[4][1]], 1016, "southBase")
    gmsh.model.addPhysicalGroup(2, [ov[5][1]], 1106, "southSlope1")
    gmsh.model.addPhysicalGroup(2, [ov[6][1]], 1206, "southLedge1")
    gmsh.model.addPhysicalGroup(2, [ov[7][1]], 1216, "southSlope2")
    gmsh.model.addPhysicalGroup(2, [ov[8][1]], 1306, "southLedge2")
    gmsh.model.addPhysicalGroup(2, [ov[9][1]], 1316, "southSlope3")
    gmsh.model.addPhysicalGroup(2, [ov[10][1]], 1400, "topFace")
    gmsh.model.addPhysicalGroup(2, [ov[11][1]], 1322, "outlet")
    gmsh.model.addPhysicalGroup(2, [ov[12][1]], 1312, "northSlope3")
    gmsh.model.addPhysicalGroup(2, [ov[13][1]], 1302, "northLedge2")
    gmsh.model.addPhysicalGroup(2, [ov[14][1]], 1212, "northSlope2")
    gmsh.model.addPhysicalGroup(2, [ov[15][1]], 1202, "northLedge1")
    gmsh.model.addPhysicalGroup(2, [ov[16][1]], 1102, "northSlope1")
    gmsh.model.addPhysicalGroup(2, [ov[17][1]], 1012, "northBase")
    gmsh.model.addPhysicalGroup(2, [ov[18][1]], 1002, "northBelow")

    gmsh.model.addPhysicalGroup(3, [ov[1][1]], 1000, "interior")

    gmsh.model.mesh.generate(3)
    gmsh.write(output_file)  # writes the model to a file
    gmsh.finalize()


# def geometry1_structured():


def parse_arguments():
    """Parse command line arguments"""
    parser = argparse.ArgumentParser(description="Run gmsh")
    parser.add_argument(
        "lc_wall",
        type=float,
        nargs="?",
        default=0.1,
        help="Refinement for the wall mesh (default: 0.1)",
    )
    parser.add_argument(
        "lc_bulk",
        type=float,
        nargs="?",
        default=1,
        help="Refinement for the bulk mesh (default: 1)",
    )
    args = parser.parse_args()
    return args


def main(lc_wall=0.1, lc_bulk=1, type="unstructured", output_file="g1.msh"):
    if type == "structured":
        exit("Structured mesh not implemented")
    elif type == "unstructured":
        geometry1_unstructured(output_file, lc_wall, lc_bulk)


if __name__ == "__main__":
    args = parse_arguments()
    main(args.lc_wall, args.lc_bulk)
