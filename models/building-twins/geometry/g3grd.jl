# G3GRD. Julia geometry file. Can be converted to a Gmsh .geo file with the function julia2gmsh in utils_julia2gmsh.jl.
#===============================================================#
# TO-DO______________________________________________________#
# 1. Model the connecting building (south side)
# LABELING SCHEME__________________________________________#
# label: a four-digit code of the form [ | | | ]
#                                       ^ ^ ^ ^
#                                       G H I D
# where:
#[ ]:__ PROPERTY __| ASSIGNMENT: VALUE => SIGNIFICANCE _________________________________|
# G :    "group"   | 1=> INTERIOR, 2=> ENVELOPE, 3=> EXTERIOR, 8=> AIR, 9=> GROUND      |
# H :  "elevation" | (0,1,...) => 0=lowest, 1=next, ...                                 |
# I : "identifier" | e.g. 0=> wall, 1=> base (|x|=|y|=b[H]), 2=> width (|x|=|y|=w[H])   |
# D :  "direction" | 0=> DIRECTIONLESS, (1,3,5,7)=> (NE,NW,SW,SE), (2,4,6,8)=> (N,W,S,E)|
#--------------------------------------------------------------------------------------[]
# Note 1: "direction" is not *literal* : e.g. "north" is not precisely 0° from true north.
# ==============================================================#
# FIGURES__________________________________________________#
# 1. 2D plan view and horizontal coordinate system ---#
# See Note 1, just above.
#                             ^ (y-> oo): "north" [D=2]
#                             |              
#    (y =-x > 0)* _ _ _ _ _ _ _ _ _ _ _ _  * (y = x > 0): "northeast" [D=1]
#"northwest" [D=3]|⟍   _ _ _ _ _ _ _ _  ⟋|
#                 |  |⟍  _ _ _ _ _   ⟋|  |
#                 |  |  |⟍ _ _ _  ⟋|  |  |
#                 |  |  |  |⟍  ⟋|  |  |  |
#      (x->-oo)<- |  |  |  |⟋_O⟍|  |  |  | ->(x-> oo): "east" [D=8] 
#    "west" [D=4] |  |  |⟋ _ _ _ _⟍|  |  |
#                 |  |⟋_ _ _ _ _ _ _ ⟍|  |
#                 |⟋_ _ _/_ _ _ _ \ _ _ ⟍|
#   (-y =-x > 0) *       |    |    |        *(-y = x > 0): "southeast" [D=7]
#"southwest" [D=5]       |    v(y->-oo): "south" [D=6]
#
# 2.(a) 2D elevation view: ~POINT DEFINITION-----------------#
# (****) => Point; <--> => length (see VARIABLES)
# M denotes an even number (2, 4, 6, or 8); L denotes an odd number (1, 3, 5, or 7)
# _________INTERIOR[1]________|_______ENVELOPE[2]_____|______EXTERIOR[3]___________
# _wall heights_              ^ (z-> oo) : "up"   __levels__
#      |______________________|_______________________+z=boxh____________________(81L)
#      |                      |Note: no "envelope"    |                            ^
#      |                      |      *points*.        |                            |
#      |                 <---w3---->                  |                            |
#     _|          (140L)______|=====                  _z4_____ (340L)              |
#    h3|               /      |     \\                |        \                   |
#     _|      (130L) _/<-----b3----->\\_              _z3       \_(330L)         boxh
#    h2|            /<(131L)-w2------->\\             |   (331L)   \               |
#     _|   (120L) _/<--------b2-------->\\_           _z2           \_(320L)       |
#    h1|         /<-(121L)---w1---------->\\          |       (321L)  \            |
#     _| (110L) /             |            \\         _z1              \ (310L)    |
#      |       |<------------b1------------>||        |                 |          |  
#    h0|_______|(101L)        |_____________||_________z=0 _______(301L)|________(91L)
#     _| (100L)|______________|_ _ _ _ _ _ _ _ _ _ _ __z0 _ _ _ _ _ _ _ _ _ _ _ _ _^
#      |                      |                       |                          |boxz|
#      |______________________|________________________z=boxz_____________________*v
#      <---------------------boxw-------------------->                           (90L)
#
# 2.(b) 2D elevation view: ~CONCENTRIC AND CONCENTRIC CONNECTING LINE DEFINITION---#
# (****) => Point; [****] => Line; <--> => length (see VARIABLES)
# M denotes an even number (2, 4, 6, or 8); L denotes an odd number (1, 3, 5, or 7)
# _________INTERIOR[1]________|_______ENVELOPE[2]_____|______EXTERIOR[3]___________
# _wall heights_              ^ (z-> oo) : "up"   __levels__
#      |______________________|_______________________+z=boxh________[81M]_______(81L)
#      |                      |                       |                            |
#      |                      |                       |                            |
#      |                 <---w3---->                  | [340M]                     |
#     _|                ______|=====[240L]            _z4_____                     |
#    h3|         [131L]/[140M]|     \\                |        \[331L]             |
#     _|       [130L]_/<-----b3----->\\_ [230L]       _z3       \_[330L]         [81L]
#    h2|      [121L]/<-------w2-[231L]>\\             |   (331L)   \[321L]         |
#     _|    [120L]_/<--------b2-------->\\_[220L]     _z2           \_[320L]       |
#    h1|   [110L]/<----------w1---[221L]->\\          |       (321L)  \[310L]      |
#     _|        /             |            \\[210L]   _z1              \ (310L)    |
#      |       |<------------b1------------>||        |                 |          |  
#    h0|_______|[101L]        |       [201L]||_________z=0        [301L]|________(91L)
#     _| [100L]|______________|_ _ _ _ _ _ _ _ _ _ _ __z0                  [91L]   |
#      |            [100M]    |                       |                          [90L]
#      |______________________|________________________z=boxz________[90M]________*v
#      <---------------------boxw-------------------->                           (90L)
# 3. 2D plan view: PLAN (PERIMETER) Line definition
# (****) => Point; [****] => Line; <--> => length (see VARIABLES)
# M denotes an even number (2, 4, 6, or 8); L denotes an odd number (1, 3, 5, or 7)
# _________INTERIOR[1]________|_________EXTERIOR[3]_________
# |⟍                          |                          ⟋|
# |   ⟍                       |              [91L]--> ⟋   |
# |     ⟍                     |                     ⟋     |
# |       ⟍___________________|___________________⟋       |
# |        |⟍                 |                ⟋ |        |
# |{[100M],|  ⟍ <--[110L]     |    [310L]--> ⟋   | collocated at |x|=|y|=b1/2 + wth:
# | [101M],|    |⟍============|============⟋|    | {[300M],[301M], [310M]}, ascending.
# | [110M]}|    ||  ⟍<--[121L]|[321L]-->⟋  ||    |        |
# | [120M]----->||   |⟍=======|=======⟋|   ||<-----[320M] |
# | [121M]------>|   || ⟍ ____|____ ⟋ ||   |<------[321M] |
# | [130M]---------->||   |⟍  |  ⟋|   ||<----------[330M] |
# | [131M]----------->|   |  ⟍|⟋  |   |<-----------[331M] |
# | [140M]--------------->|  ⟋|⟍  |<---------------[340M] |
# |        |    ||   ||   |⟋__|__⟍|   ||   ||    |        |
# |        |    ||   || ⟋     |     ⟍ ||   ||    |        | collocated at |x|=|y|=boxw/2:
# |        |    ||   |⟋=======|=======⟍|   ||    |        | {[90M], [91M], [81M]},
# |        |    || ⟋          |          ⟍ ||    |        | ascending.
# |        |    |⟋============|============⟍|    |        |
# |        |  ⟋               |               ⟍  |        |
# |        |⟋_________________|_________________⟍|        |
# |      ⟋                    |                    ⟍      |
# |    ⟋                      |                      ⟍    |
# |  ⟋                        |                        ⟍  |
# |⟋__________________________|__________________________⟍|
# =====================================================================#
# VARIABLES__________________________________________________#
length_in_meters = 1.67; # length of each member
s = length_in_meters;    # scale factor

boxh = 45;   #        height of bounding box above ground level (z>0)
boxw = 60;   #         width of bounding box
boxz = -6;   #  signed depth of bounding box below ground level (z<0)
z0 = -3.285; #  signed depth of building below ground level

w1 = 21*s; w2 = 13*s; w3 =  7*s; # horizontal distances to outside of ledges
b1 = 27*s; b2 = 19*s; b3 = 11*s; # horizontal distances to inside of ledges; b0 = 26*s
h0 = 6.38*s;      # heights of walls
h1 = 3*sqrt(2)*s;
h2 = 3*sqrt(2)*s;
h3 = 2*sqrt(2)*s;

z1 = z0 + h0;#  height level 1 from ground
z2 = z1 + h1;#  height level 2 from ground
z3 = z2 + h2;#  height level 3 from ground
z4 = z3 + h3;#  height level 4 from ground

wth = 1.0; # wall thickness

# angles for computing exterior points
alpha1 = atan(h1/((b1-w1)/2)); beta1 = π/4-alpha1/2;
alpha2 = atan(h2/((b2-w2)/2)); beta2 = π/4-alpha2/2;
alpha3 = atan(h3/((b3-w3)/2)); beta3 = π/4-alpha3/2;

# I.  POINT DICTIONARY -----------
Point = Dict{Int, Vector{Float64}}()

# 1. WALL INTERIOR POINTS
# i. @ level z=z0:
    Point[1001]  = [ b1/2,  b1/2, z0];
    Point[1003]  = [-b1/2,  b1/2, z0];
    Point[1005]  = [-b1/2, -b1/2, z0];
    Point[1007]  = [ b1/2, -b1/2, z0];
# ii. @ level z=0:
    Point[1011]  = [ b1/2,  b1/2, 0];
    Point[1013]  = [-b1/2,  b1/2, 0];
    Point[1015]  = [-b1/2, -b1/2, 0];
    Point[1017]  = [ b1/2, -b1/2, 0];
# iii. @ level z=z1:
    Point[1101]  = [ b1/2,  b1/2, z1];
    Point[1103]  = [-b1/2,  b1/2, z1];
    Point[1105]  = [-b1/2, -b1/2, z1];
    Point[1107]  = [ b1/2, -b1/2, z1];
# iv. @ level z=z2, |x|,|y| = w1/2:
    Point[1201]  = [ w1/2,  w1/2, z2];
    Point[1203]  = [-w1/2,  w1/2, z2];
    Point[1205]  = [-w1/2, -w1/2, z2];
    Point[1207]  = [ w1/2, -w1/2, z2];
# v. @ level z=z2, |x|,|y| = b2/2:
    Point[1211]  = [ b2/2,  b2/2, z2];
    Point[1213]  = [-b2/2,  b2/2, z2];
    Point[1215]  = [-b2/2, -b2/2, z2];
    Point[1217]  = [ b2/2, -b2/2, z2];
# vi. @ level z=z3, |x|,|y| = w2/2:
    Point[1301]  = [ w2/2,  w2/2, z3];
    Point[1303]  = [-w2/2,  w2/2, z3];
    Point[1305]  = [-w2/2, -w2/2, z3];
    Point[1307]  = [ w2/2, -w2/2, z3];
# vii. @ level z=z3, |x|,|y| = b3/2:
    Point[1311]  = [ b3/2,  b3/2, z3];
    Point[1313]  = [-b3/2,  b3/2, z3];
    Point[1315]  = [-b3/2, -b3/2, z3];
    Point[1317]  = [ b3/2, -b3/2, z3];
# viii. @ level z=z4, |x|,|y| = w3/2:
    Point[1401]  = [ w3/2,  w3/2, z4];
    Point[1403]  = [-w3/2,  w3/2, z4];
    Point[1405]  = [-w3/2, -w3/2, z4];
    Point[1407]  = [ w3/2, -w3/2, z4];
# 2. WALL EXTERIOR POINTS
# i. @ level z=0:
    Point[3011]  = [  b1/2 + wth ,   b1/2 + wth , 0];
    Point[3013]  = [-(b1/2 + wth),   b1/2 + wth , 0];
    Point[3015]  = [-(b1/2 + wth), -(b1/2 + wth), 0];
    Point[3017]  = [  b1/2 + wth , -(b1/2 + wth), 0];
# ii. @ level z=z1:
    Point[3101]  = [  b1/2 + wth,    b1/2 + wth,  z1 + wth*tan(beta1)];
    Point[3103]  = [-(b1/2 + wth),   b1/2 + wth,  z1 + wth*tan(beta1)];
    Point[3105]  = [-(b1/2 + wth), -(b1/2 + wth), z1 + wth*tan(beta1)];
    Point[3107]  = [  b1/2 + wth,  -(b1/2 + wth), z1 + wth*tan(beta1)];
# iii. @ level z=z2, |x|,|y| = w1/2:
    Point[3201]  = [ w1/2 + wth*tan(beta1),  w1/2 + wth*tan(beta1), z2 + wth];
    Point[3203]  = [-w1/2 - wth*tan(beta1),  w1/2 + wth*tan(beta1), z2 + wth];
    Point[3205]  = [-w1/2 - wth*tan(beta1), -w1/2 - wth*tan(beta1), z2 + wth];
    Point[3207]  = [ w1/2 + wth*tan(beta1), -w1/2 - wth*tan(beta1), z2 + wth];
# iv. @ level z=z2, |x|,|y| = b2/2:
    Point[3211]  = [ b2/2 + wth*tan(beta2),  b2/2 + wth*tan(beta2), z2 + wth];
    Point[3213]  = [-b2/2 - wth*tan(beta2),  b2/2 + wth*tan(beta2), z2 + wth];
    Point[3215]  = [-b2/2 - wth*tan(beta2), -b2/2 - wth*tan(beta2), z2 + wth];
    Point[3217]  = [ b2/2 + wth*tan(beta2), -b2/2 - wth*tan(beta2), z2 + wth];
# v. @ level z=z3, |x|,|y| = w2/2:
    Point[3301]  = [ w2/2 + wth*tan(beta2),  w2/2 + wth*tan(beta2), z3 + wth];
    Point[3303]  = [-w2/2 - wth*tan(beta2),  w2/2 + wth*tan(beta2), z3 + wth];
    Point[3305]  = [-w2/2 - wth*tan(beta2), -w2/2 - wth*tan(beta2), z3 + wth];
    Point[3307]  = [ w2/2 + wth*tan(beta2), -w2/2 - wth*tan(beta2), z3 + wth];
# vi. @ level z=z3, |x|,|y| = b3/2:
    Point[3311]  = [ b3/2 + wth*tan(beta3),  b3/2 + wth*tan(beta3), z3 + wth];
    Point[3313]  = [-b3/2 - wth*tan(beta3),  b3/2 + wth*tan(beta3), z3 + wth];
    Point[3315]  = [-b3/2 - wth*tan(beta3), -b3/2 - wth*tan(beta3), z3 + wth];
    Point[3317]  = [ b3/2 + wth*tan(beta3), -b3/2 - wth*tan(beta3), z3 + wth];
# vii. @ level z=z4, |x|,|y| = w3/2:
    Point[3401]  = [ w3/2 + wth*tan(beta3),  w3/2 + wth*tan(beta3), z4 + wth];
    Point[3403]  = [-w3/2 - wth*tan(beta3),  w3/2 + wth*tan(beta3), z4 + wth];
    Point[3405]  = [-w3/2 - wth*tan(beta3), -w3/2 - wth*tan(beta3), z4 + wth];
    Point[3407]  = [ w3/2 + wth*tan(beta3), -w3/2 - wth*tan(beta3), z4 + wth];
#3. BOUNDING BOX POINTS
# i. @ level z=boxz (ground):
    Point[901]   = [ boxw/2,  boxw/2,  boxz];
    Point[903]   = [-boxw/2,  boxw/2,  boxz];
    Point[905]   = [-boxw/2, -boxw/2,  boxz];
    Point[907]   = [ boxw/2, -boxw/2,  boxz];
# ii. @ level z=0 (ground):
    Point[911]   = [ boxw/2,  boxw/2,  0];
    Point[913]   = [-boxw/2,  boxw/2,  0];
    Point[915]   = [-boxw/2, -boxw/2,  0];
    Point[917]   = [ boxw/2, -boxw/2,  0];
# iii. @ level z=boxh (air):
    Point[811]   = [ boxw/2,  boxw/2,  boxh];
    Point[813]   = [-boxw/2,  boxw/2,  boxh];
    Point[815]   = [-boxw/2, -boxw/2,  boxh];
    Point[817]   = [ boxw/2, -boxw/2,  boxh];


#II. LINE DICTIONARY -----------
Line = Dict{Int, Vector{Int}}()

# 1. PLAN (PERIMETER) LINES =============
#   _______ 
#  |  ___  | Lines that form square perimeters.
#  | | □ | |
#  |_______|
#
# ________INTERIOR___________|________EXTERIOR_________              
# plan lines @ level z=z0:
    Line[1002] = [1001, 1003];
    Line[1004] = [1003, 1005];
    Line[1006] = [1005, 1007];
    Line[1008] = [1007, 1001];
# plan lines @ level z=0:
    Line[1012] = [1011, 1013]; Line[3012] = [3011, 3013];
    Line[1014] = [1013, 1015]; Line[3014] = [3013, 3015];
    Line[1016] = [1015, 1017]; Line[3016] = [3015, 3017];
    Line[1018] = [1017, 1011]; Line[3018] = [3017, 3011];
# plan lines @ level z=z1:
    Line[1102] = [1101, 1103]; Line[3102] = [3101, 3103];
    Line[1104] = [1103, 1105]; Line[3104] = [3103, 3105];
    Line[1106] = [1105, 1107]; Line[3106] = [3105, 3107];
    Line[1108] = [1107, 1101]; Line[3108] = [3107, 3101];
# plan lines @ level z=z2, |x|,|y| = w1/2:
    Line[1202] = [1201, 1203]; Line[3202] = [3201, 3203];
    Line[1204] = [1203, 1205]; Line[3204] = [3203, 3205];
    Line[1206] = [1205, 1207]; Line[3206] = [3205, 3207];
    Line[1208] = [1207, 1201]; Line[3208] = [3207, 3201];
# plan lines @ level z=z2, |x|,|y| = b2/2:
    Line[1212] = [1211, 1213]; Line[3212] = [3211, 3213];
    Line[1214] = [1213, 1215]; Line[3214] = [3213, 3215];
    Line[1216] = [1215, 1217]; Line[3216] = [3215, 3217];
    Line[1218] = [1217, 1211]; Line[3218] = [3217, 3211];
# plan lines @ level z=z3, |x|,|y| = w2/2:
    Line[1302] = [1301, 1303]; Line[3302] = [3301, 3303];
    Line[1304] = [1303, 1305]; Line[3304] = [3303, 3305];
    Line[1306] = [1305, 1307]; Line[3306] = [3305, 3307];
    Line[1308] = [1307, 1301]; Line[3308] = [3307, 3301];
# plan lines @ level z=z3, |x|,|y| = b3/2:
    Line[1312] = [1311, 1313]; Line[3312] = [3311, 3313];
    Line[1314] = [1313, 1315]; Line[3314] = [3313, 3315];
    Line[1316] = [1315, 1317]; Line[3316] = [3315, 3317];
    Line[1318] = [1317, 1311]; Line[3318] = [3317, 3311];
# plan lines @ level z=z4, |x|,|y| = w3/2:
    Line[1402] = [1401, 1403]; Line[3402] = [3401, 3403];
    Line[1404] = [1403, 1405]; Line[3404] = [3403, 3405];
    Line[1406] = [1405, 1407]; Line[3406] = [3405, 3407];
    Line[1408] = [1407, 1401]; Line[3408] = [3407, 3401];

# 2. CONCENTRIC AND CONCENTRIC CONNECTING LINES =============
#   ______ 
#  |⟍   ⟋| Lines that move on a diagonal from one corner to the center.
#  |  ⤫   |
#  |⟋___⟍|
# ________INTERIOR___________|______ENVELOPE___________|_________EXTERIOR_________
# corner lines from level z=z0 to z=0, |x|,|y| = b1/2:
    Line[1001] = [1001, 1011];
    Line[1003] = [1003, 1013];
    Line[1005] = [1005, 1015];
    Line[1007] = [1007, 1017];
# corner lines from level z=0 to z=z1, |x|,|y| = b1/2:
    Line[1011] = [1011, 1101]; Line[2011] = [1011, 3011]; Line[3011] = [3011, 3101]; 
    Line[1013] = [1013, 1103]; Line[2013] = [1013, 3013]; Line[3013] = [3013, 3103];
    Line[1015] = [1015, 1105]; Line[2015] = [1015, 3015]; Line[3015] = [3015, 3105];
    Line[1017] = [1017, 1107]; Line[2017] = [1017, 3017]; Line[3017] = [3017, 3107];
# corner lines from level z=z1, |x|,|y| = b1/2 to z=z2, |x|,|y| = w1/2:
    Line[1101] = [1101, 1201]; Line[2101] = [1101, 3101]; Line[3101] = [3101, 3201];
    Line[1103] = [1103, 1203]; Line[2103] = [1103, 3103]; Line[3103] = [3103, 3203];
    Line[1105] = [1105, 1205]; Line[2105] = [1105, 3105]; Line[3105] = [3105, 3205];
    Line[1107] = [1107, 1207]; Line[2107] = [1107, 3107]; Line[3107] = [3107, 3207];
# corner lines from |x|,|y| = w1/2 to |x|,|y| = b2/2, z=z2:
    Line[1201] = [1201, 1211]; Line[2201] = [1201, 3201]; Line[3201] = [3201, 3211];
    Line[1203] = [1203, 1213]; Line[2203] = [1203, 3203]; Line[3203] = [3203, 3213];
    Line[1205] = [1205, 1215]; Line[2205] = [1205, 3205]; Line[3205] = [3205, 3215];
    Line[1207] = [1207, 1217]; Line[2207] = [1207, 3207]; Line[3207] = [3207, 3217];
# corner lines from level z=z2, |x|,|y| = b2/2 to z=z3, |x|,|y| = w2/2:
    Line[1211] = [1211, 1301]; Line[2211] = [1211, 3211]; Line[3211] = [3211, 3301];
    Line[1213] = [1213, 1303]; Line[2213] = [1213, 3213]; Line[3213] = [3213, 3303];
    Line[1215] = [1215, 1305]; Line[2215] = [1215, 3215]; Line[3215] = [3215, 3305];
    Line[1217] = [1217, 1307]; Line[2217] = [1217, 3217]; Line[3217] = [3217, 3307];
# corner lines from |x|,|y| = w2/2 to |x|,|y| = b3/2, z=z3:
    Line[1301] = [1301, 1311]; Line[2301] = [1301, 3301]; Line[3301] = [3301, 3311];
    Line[1303] = [1303, 1313]; Line[2303] = [1303, 3303]; Line[3303] = [3303, 3313];
    Line[1305] = [1305, 1315]; Line[2305] = [1305, 3305]; Line[3305] = [3305, 3315];
    Line[1307] = [1307, 1317]; Line[2307] = [1307, 3307]; Line[3307] = [3307, 3317];
# corner lines from level z=z3, |x|,|y| = b3/2 to z=z4, |x|,|y| = w3/2:
    Line[1311] = [1311, 1401]; Line[2311] = [1311, 3311]; Line[3311] = [3311, 3401];
    Line[1313] = [1313, 1403]; Line[2313] = [1313, 3313]; Line[3313] = [3313, 3403];
    Line[1315] = [1315, 1405]; Line[2315] = [1315, 3315]; Line[3315] = [3315, 3405];
    Line[1317] = [1317, 1407]; Line[2317] = [1317, 3317]; Line[3317] = [3317, 3407];
# connecting lines at level z=z4:
                               Line[2401] = [1401, 3401];
                               Line[2403] = [1403, 3403];
                               Line[2405] = [1405, 3405];
                               Line[2407] = [1407, 3407];
# 3. BOUNDING BOX LINES =============
# horizontal lines @ level z=boxz:
    Line[902] = [901, 903];
    Line[904] = [903, 905];
    Line[906] = [905, 907];
    Line[908] = [907, 901];
# vertical lines from level z=boxz:
    Line[901] = [901, 911];
    Line[903] = [903, 913];
    Line[905] = [905, 915];
    Line[907] = [907, 917];
# horizontal lines @ level z=0 (ground):
    Line[912] = [911, 913];
    Line[914] = [913, 915];
    Line[916] = [915, 917];
    Line[918] = [917, 911];
# concentric lines @ level z=0 (ground):
    Line[911] = [911, 3011];
    Line[913] = [913, 3013];
    Line[915] = [915, 3015];
    Line[917] = [917, 3017];
#________________________________________
# vertical lines from level z=0:
    Line[811] = [911, 811]; # or [801, 811]
    Line[813] = [913, 813];
    Line[815] = [915, 815];
    Line[817] = [917, 817];
# horizontal lines @ level z=boxh:
    Line[812] = [811, 813];
    Line[814] = [813, 815];
    Line[816] = [815, 817];
    Line[818] = [817, 811];

#III. CURVELOOP/SURFACE DICTIONARY -----------
CurveLoop = Dict{Int, Vector{Int}}()
# 1. PERIMETER AND WALL COPLANAR PATHS =============
# perimeter and wall plane paths @ level z=z0:
    CurveLoop[1000] = [1002, 1004, 1006, 1008]; # perimeter path
    CurveLoop[1002] = [1001, 1002, 1003, 1012]; # north wall
    CurveLoop[1004] = [1003, 1004, 1005, 1014]; # west wall
    CurveLoop[1006] = [1005, 1006, 1007, 1016]; # south wall
    CurveLoop[1008] = [1007, 1008, 1001, 1018]; # east wall
# perimeter and wall plane paths @ level z=0:
    CurveLoop[1010] = [1012, 1014, 1016, 1018]; # perimeter path
    CurveLoop[1012] = [1011, 1012, 1013, 1102]; CurveLoop[3012] = [3011, 3012, 3013, 3102];
    CurveLoop[1014] = [1013, 1014, 1015, 1104]; CurveLoop[3014] = [3013, 3014, 3015, 3104];
    CurveLoop[1016] = [1015, 1016, 1017, 1106]; CurveLoop[3016] = [3015, 3016, 3017, 3106];
    CurveLoop[1018] = [1017, 1018, 1011, 1108]; CurveLoop[3018] = [3017, 3018, 3011, 3108];
# perimeter and wall plane paths @ level z=z1:
    CurveLoop[1100] = [1102, 1104, 1106, 1108];
    CurveLoop[1102] = [1101, 1102, 1103, 1202]; CurveLoop[3102] = [3101, 3102, 3103, 3202];
    CurveLoop[1104] = [1103, 1104, 1105, 1204]; CurveLoop[3104] = [3103, 3104, 3105, 3204];
    CurveLoop[1106] = [1105, 1106, 1107, 1206]; CurveLoop[3106] = [3105, 3106, 3107, 3206];
    CurveLoop[1108] = [1107, 1108, 1101, 1208]; CurveLoop[3108] = [3107, 3108, 3101, 3208];
# ledge paths @ level z=z2:
    # CurveLoop[1200] = [1202, 1204, 1206, 1208];
    CurveLoop[1202] = [1201, 1202, 1203, 1212]; CurveLoop[3202] = [3201, 3202, 3203, 3212];
    CurveLoop[1204] = [1203, 1204, 1205, 1214]; CurveLoop[3204] = [3203, 3204, 3205, 3214];
    CurveLoop[1206] = [1205, 1206, 1207, 1216]; CurveLoop[3206] = [3205, 3206, 3207, 3216];
    CurveLoop[1208] = [1207, 1208, 1201, 1218]; CurveLoop[3208] = [3207, 3208, 3201, 3218];
# perimeter and wall paths @ level z=z2:
    CurveLoop[1210] = [1212, 1214, 1216, 1218]; # interior to path 1200
    CurveLoop[1212] = [1211, 1212, 1213, 1302]; CurveLoop[3212] = [3211, 3212, 3213, 3302];
    CurveLoop[1214] = [1213, 1214, 1215, 1304]; CurveLoop[3214] = [3213, 3214, 3215, 3304];
    CurveLoop[1216] = [1215, 1216, 1217, 1306]; CurveLoop[3216] = [3215, 3216, 3217, 3306];
    CurveLoop[1218] = [1217, 1218, 1211, 1308]; CurveLoop[3218] = [3217, 3218, 3211, 3308];
# ledge paths @ level z=z3:
    # CurveLoop[1300] = [1302, 1304, 1306, 1308];
    CurveLoop[1302] = [1301, 1302, 1303, 1312]; CurveLoop[3302] = [3301, 3302, 3303, 3312];
    CurveLoop[1304] = [1303, 1304, 1305, 1314]; CurveLoop[3304] = [3303, 3304, 3305, 3314];
    CurveLoop[1306] = [1305, 1306, 1307, 1316]; CurveLoop[3306] = [3305, 3306, 3307, 3316];
    CurveLoop[1308] = [1307, 1308, 1301, 1318]; CurveLoop[3308] = [3307, 3308, 3301, 3318];
# perimeter and wall paths @ level z=z3:
    CurveLoop[1310] = [1312, 1314, 1316, 1318]; # interior to path 1300
    CurveLoop[1312] = [1311, 1312, 1313, 1402]; CurveLoop[3312] = [3311, 3312, 3313, 3402];
    CurveLoop[1314] = [1313, 1314, 1315, 1404]; CurveLoop[3314] = [3313, 3314, 3315, 3404];
    CurveLoop[1316] = [1315, 1316, 1317, 1406]; CurveLoop[3316] = [3315, 3316, 3317, 3406];
    CurveLoop[1318] = [1317, 1318, 1311, 1408]; CurveLoop[3318] = [3317, 3318, 3311, 3408];
# ceiling path @ level z=z4:
    CurveLoop[1400] = [1402, 1404, 1406, 1408]; CurveLoop[3400] = [3402, 3404, 3406, 3408];

# 2. PLAN CONNECTING PATHS =============
# connecting paths @ level z=0:
    CurveLoop[2012] = [1012, 2011, 3012, 2013];
    CurveLoop[2014] = [1014, 2013, 3014, 2015];
    CurveLoop[2016] = [1016, 2015, 3016, 2017];
    CurveLoop[2018] = [1018, 2017, 3018, 2011];
# connecting paths @ level z=z1:
    CurveLoop[2102] = [1102, 2101, 3102, 2103];
    CurveLoop[2104] = [1104, 2103, 3104, 2105];
    CurveLoop[2106] = [1106, 2105, 3106, 2107];
    CurveLoop[2108] = [1108, 2107, 3108, 2101];
# connecting paths @ level z=z2, |x|,|y| = w1/2:
    CurveLoop[2202] = [1202, 2201, 3202, 2203];
    CurveLoop[2204] = [1204, 2203, 3204, 2205];
    CurveLoop[2206] = [1206, 2205, 3206, 2207];
    CurveLoop[2208] = [1208, 2207, 3208, 2201];
# connecting paths @ level z=z2, |x|,|y| = b2/2:
    CurveLoop[2212] = [1212, 2211, 3212, 2213];
    CurveLoop[2214] = [1214, 2213, 3214, 2215];
    CurveLoop[2216] = [1216, 2215, 3216, 2217];
    CurveLoop[2218] = [1218, 2217, 3218, 2211];
# connecting paths @ level z=z3, |x|,|y| = w2/2:
    CurveLoop[2302] = [1302, 2301, 3302, 2303];
    CurveLoop[2304] = [1304, 2303, 3304, 2305];
    CurveLoop[2306] = [1306, 2305, 3306, 2307];
    CurveLoop[2308] = [1308, 2307, 3308, 2301];
# connecting paths @ level z=z3, |x|,|y| = b3/2:    
    CurveLoop[2312] = [1312, 2311, 3312, 2313];
    CurveLoop[2314] = [1314, 2313, 3314, 2315];
    CurveLoop[2316] = [1316, 2315, 3316, 2317];
    CurveLoop[2318] = [1318, 2317, 3318, 2311];
# connecting paths @ level z=z4:
    CurveLoop[2402] = [1402, 2401, 3402, 2403];
    CurveLoop[2404] = [1404, 2403, 3404, 2405];
    CurveLoop[2406] = [1406, 2405, 3406, 2407];
    CurveLoop[2408] = [1408, 2407, 3408, 2401];

# 3. CONCENTRIC CONNECTING PATHS =============
# connecting paths from level z=0 to z=z1:
    CurveLoop[2011] = [1011, 2011, 3011, 2101];
    CurveLoop[2013] = [1013, 2013, 3013, 2103];
    CurveLoop[2015] = [1015, 2015, 3015, 2105];
    CurveLoop[2017] = [1017, 2017, 3017, 2107];
# connecting paths from level z=z1 to z=z2:
    CurveLoop[2101] = [1101, 2101, 3101, 2201];
    CurveLoop[2103] = [1103, 2103, 3103, 2203];
    CurveLoop[2105] = [1105, 2105, 3105, 2205];
    CurveLoop[2107] = [1107, 2107, 3107, 2207];
# connecting paths from |x|,|y| = w1/2 to |x|,|y| = b2/2, z=z2:
    CurveLoop[2201] = [1201, 2201, 3201, 2211];
    CurveLoop[2203] = [1203, 2203, 3203, 2213];
    CurveLoop[2205] = [1205, 2205, 3205, 2215];
    CurveLoop[2207] = [1207, 2207, 3207, 2217];
# connecting paths from level z=z2 to z=z3:
    CurveLoop[2211] = [1211, 2211, 3211, 2301];
    CurveLoop[2213] = [1213, 2213, 3213, 2303];
    CurveLoop[2215] = [1215, 2215, 3215, 2305];
    CurveLoop[2217] = [1217, 2217, 3217, 2307];
# connecting paths from |x|,|y| = w2/2 to |x|,|y| = b3/2, z=z3:
    CurveLoop[2301] = [1301, 2301, 3301, 2311];
    CurveLoop[2303] = [1303, 2303, 3303, 2313];
    CurveLoop[2305] = [1305, 2305, 3305, 2315];
    CurveLoop[2307] = [1307, 2307, 3307, 2317];
# connecting paths from level z=z3 to z=z4:
    CurveLoop[2311] = [1311, 2311, 3311, 2401];
    CurveLoop[2313] = [1313, 2313, 3313, 2403];
    CurveLoop[2315] = [1315, 2315, 3315, 2405];
    CurveLoop[2317] = [1317, 2317, 3317, 2407];

# 4. BOUNDING BOX PATHS =============
    CurveLoop[900] = [902, 904, 906, 908]; # perimeter paths @ level z=boxz:
    CurveLoop[800] = [812, 814, 816, 818]; # perimeter paths @ level z=boxh:
# bounding box wall paths below ground
    CurveLoop[902] = [902, 901, 912, 903];
    CurveLoop[904] = [904, 903, 914, 905];
    CurveLoop[906] = [906, 905, 916, 907];
    CurveLoop[908] = [908, 907, 918, 901];
# sky-ground interface paths @ z=0:
    CurveLoop[912] = [911, 3012, 913, 912];
    CurveLoop[914] = [913, 3014, 915, 914];
    CurveLoop[916] = [915, 3016, 917, 916];
    CurveLoop[918] = [917, 3018, 911, 918];
# bounding box wall paths above ground
    CurveLoop[802] = [812, 811, 912, 813];
    CurveLoop[804] = [814, 813, 914, 815];
    CurveLoop[806] = [816, 815, 916, 817];
    CurveLoop[808] = [818, 817, 918, 811];
#IV. SURFACE LOOP DICTIONARY -----------
# make surface loops for each volume
SurfaceLoop = Dict{Int, Vector{Int}}()
# 1. INTERIOR VOLUMES =============
# for z > z1:
# the outer area (w*) is labeled 1x0* and is used as the cap of each volume
# the inner area (b*) is labeled 1x1* and is used as the base of each volume
    SurfaceLoop[1000] = [1000, 1002, 1004, 1006, 1008, 1010];
    SurfaceLoop[1010] = [1010, 1012, 1014, 1016, 1018, 1100];
    SurfaceLoop[1100] = [1100, 1102, 1104, 1106, 1108, 1202, 1204, 1206, 1208, 1210]; # 1200];
    SurfaceLoop[1200] = [1210, 1212, 1214, 1216, 1218, 1302, 1304, 1306, 1308, 1310]; # 1300];
    SurfaceLoop[1300] = [1310, 1312, 1314, 1316, 1318, 1400];

# 2. WALL VOLUMES =============
# side wall volume from level z=0 to z=z1:
    SurfaceLoop[2012] = [2012, 2013, 2011, 1012, 3012, 2102];
    SurfaceLoop[2014] = [2014, 2015, 2013, 1014, 3014, 2104];
    SurfaceLoop[2016] = [2016, 2017, 2015, 1016, 3016, 2106];
    SurfaceLoop[2018] = [2018, 2011, 2017, 1018, 3018, 2108];
# side wall volume from level z=z1 to z=z2:
    SurfaceLoop[2102] = [2102, 2103, 2101, 1102, 3102, 2202];
    SurfaceLoop[2104] = [2104, 2105, 2103, 1104, 3104, 2204];
    SurfaceLoop[2106] = [2106, 2107, 2105, 1106, 3106, 2206];
    SurfaceLoop[2108] = [2108, 2101, 2107, 1108, 3108, 2208];
# ledge wall volume @ level z=z2:
    SurfaceLoop[2202] = [2202, 2203, 2201, 1202, 3202, 2212];
    SurfaceLoop[2204] = [2204, 2205, 2203, 1204, 3204, 2214];
    SurfaceLoop[2206] = [2206, 2207, 2205, 1206, 3206, 2216];
    SurfaceLoop[2208] = [2208, 2201, 2207, 1208, 3208, 2218];
# side wall volume from level z=z2 to z=z3:
    SurfaceLoop[2212] = [2212, 2213, 2211, 1212, 3212, 2302];
    SurfaceLoop[2214] = [2214, 2215, 2213, 1214, 3214, 2304];
    SurfaceLoop[2216] = [2216, 2217, 2215, 1216, 3216, 2306];
    SurfaceLoop[2218] = [2218, 2211, 2217, 1218, 3218, 2308];
# ledge wall volume @ level z=z3:
    SurfaceLoop[2302] = [2302, 2303, 2301, 1302, 3302, 2312];
    SurfaceLoop[2304] = [2304, 2305, 2303, 1304, 3304, 2314];
    SurfaceLoop[2306] = [2306, 2307, 2305, 1306, 3306, 2316];
    SurfaceLoop[2308] = [2308, 2301, 2307, 1308, 3308, 2318];
# side wall volume from level z=z3 to z=z4:
    SurfaceLoop[2312] = [2312, 2313, 2311, 1312, 3312, 2402];
    SurfaceLoop[2314] = [2314, 2315, 2313, 1314, 3314, 2404];
    SurfaceLoop[2316] = [2316, 2317, 2315, 1316, 3316, 2406];
    SurfaceLoop[2318] = [2318, 2311, 2317, 1318, 3318, 2408];
# ceiling volume @ level z=z4:
    SurfaceLoop[2400] = [1400, 2402, 2404, 2406, 2408, 3400];

# 3. BOUNDING BOX VOLUMES =============
# ground volume:
    SurfaceLoop[900] = [900, 902, 904, 906, 908, 
                        912, 914, 916, 918, 
                       2012, 2014, 2016, 2018,
                       1000, 1002, 1004, 1006, 1008];
# air volume above ground:
    SurfaceLoop[800] = [800, 802, 804, 806, 808, 
                        912, 914, 916, 918, 
                       3012, 3014, 3016, 3018,
                       3102, 3104, 3106, 3108,
                       3202, 3204, 3206, 3208,
                       3212, 3214, 3216, 3218,
                       3302, 3304, 3306, 3308,
                       3312, 3314, 3316, 3318, 3400];