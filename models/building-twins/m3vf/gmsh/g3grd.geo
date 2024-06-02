// Converted from Julia geometry file g3grd.jl to Gmsh by julia2gmsh.jl
// SetFactory("OpenCASCADE");
lc = 5;
//===============================================================//
// TO-DO______________________________________________________//
// 1. Model the connecting building (south side)
// LABELING SCHEME__________________________________________//
// label: a four-digit code of the form [ | | | ]
//                                       ^ ^ ^ ^
//                                       G H I D
// where:
//[ ]:__ PROPERTY __| ASSIGNMENT: VALUE => SIGNIFICANCE _________________________________|
// G :    "group"   | 1=> INTERIOR, 2=> ENVELOPE, 3=> EXTERIOR, 8=> AIR, 9=> GROUND      |
// H :  "elevation" | (0,1,...) => 0=lowest, 1=next, ...                                 |
// I : "identifier" | e.g. 0=> wall, 1=> base (|x|=|y|=b{H]), 2=> width (|x|=|y|=w[H])   |
// D :  "direction" | 0=> DIRECTIONLESS, (1,3,5,7)=> (NE,NW,SW,SE), (2,4,6,8)=> (N,W,S,E)|
//--------------------------------------------------------------------------------------[]
// Note 1: "direction" is not *literal* : e.g. "north" is not precisely 0° from true north.
// ==============================================================//
// FIGURES__________________________________________________//
// 1. 2D plan view and horizontal coordinate system ---//
// See Note 1, just above.
//                             ^ (y-> oo): "north" [D=2]
//                             |              
//    (y =-x > 0)* _ _ _ _ _ _ _ _ _ _ _ _  * (y = x > 0): "northeast" [D=1]
//"northwest" [D=3]|⟍   _ _ _ _ _ _ _ _  ⟋|
//                 |  |⟍  _ _ _ _ _   ⟋|  |
//                 |  |  |⟍ _ _ _  ⟋|  |  |
//                 |  |  |  |⟍  ⟋|  |  |  |
//      (x->-oo)<- |  |  |  |⟋_O⟍|  |  |  | ->(x-> oo): "east" [D=8] 
//    "west" [D=4] |  |  |⟋ _ _ _ _⟍|  |  |
//                 |  |⟋_ _ _ _ _ _ _ ⟍|  |
//                 |⟋_ _ _/_ _ _ _ \ _ _ ⟍|
//   (-y =-x > 0) *       |    |    |        *(-y = x > 0): "southeast" [D=7]
//"southwest" [D=5]       |    v(y->-oo): "south" [D=6]
//
// 2.(a) 2D elevation view: ~POINT DEFINITION-----------------//
// (****) => Point; <--> => length (see VARIABLES)
// M denotes an even number (2, 4, 6, or 8); L denotes an odd number (1, 3, 5, or 7)
// _________INTERIOR[1]________|_______ENVELOPE[2]_____|______EXTERIOR[3]___________
// _wall heights_              ^ (z-> oo) : "up"   __levels__
//      |______________________|_______________________+z=boxh____________________(81L)
//      |                      |Note: no "envelope"    |                            ^
//      |                      |      *points*.        |                            |
//      |                 <---w3---->                  |                            |
//     _|          (140L)______|=====                  _z4_____ (340L)              |
//    h3|               /      |     \\                |        \                   |
//     _|      (130L) _/<-----b3----->\\_              _z3       \_(330L)         boxh
//    h2|            /<(131L)-w2------->\\             |   (331L)   \               |
//     _|   (120L) _/<--------b2-------->\\_           _z2           \_(320L)       |
//    h1|         /<-(121L)---w1---------->\\          |       (321L)  \            |
//     _| (110L) /             |            \\         _z1              \ (310L)    |
//      |       |<------------b1------------>||        |                 |          |  
//    h0|_______|(101L)        |_____________||_________z=0 _______(301L)|________(91L)
//     _| (100L)|______________|_ _ _ _ _ _ _ _ _ _ _ __z0 _ _ _ _ _ _ _ _ _ _ _ _ _^
//      |                      |                       |                          |boxz|
//      |______________________|________________________z=boxz_____________________*v
//      <---------------------boxw-------------------->                           (90L)
//
// 2.(b) 2D elevation view: ~CONCENTRIC AND CONCENTRIC CONNECTING LINE DEFINITION---//
// (****) => Point; [****] => Line; <--> => length (see VARIABLES)
// M denotes an even number (2, 4, 6, or 8); L denotes an odd number (1, 3, 5, or 7)
// _________INTERIOR[1]________|_______ENVELOPE[2]_____|______EXTERIOR[3]___________
// _wall heights_              ^ (z-> oo) : "up"   __levels__
//      |______________________|_______________________+z=boxh________[81M]_______(81L)
//      |                      |                       |                            |
//      |                      |                       |                            |
//      |                 <---w3---->                  | [340M]                     |
//     _|                ______|=====[240L]            _z4_____                     |
//    h3|         [131L]/[140M]|     \\                |        \[331L]             |
//     _|       [130L]_/<-----b3----->\\_ [230L]       _z3       \_[330L]         [81L]
//    h2|      [121L]/<-------w2-[231L]>\\             |   (331L)   \[321L]         |
//     _|    [120L]_/<--------b2-------->\\_[220L]     _z2           \_[320L]       |
//    h1|   [110L]/<----------w1---[221L]->\\          |       (321L)  \[310L]      |
//     _|        /             |            \\[210L]   _z1              \ (310L)    |
//      |       |<------------b1------------>||        |                 |          |  
//    h0|_______|[101L]        |       [201L]||_________z=0        [301L]|________(91L)
//     _| [100L]|______________|_ _ _ _ _ _ _ _ _ _ _ __z0                  [91L]   |
//      |            [100M]    |                       |                          [90L]
//      |______________________|________________________z=boxz________[90M]________*v
//      <---------------------boxw-------------------->                           (90L)
// 3. 2D plan view: PLAN (PERIMETER) Line definition
// (****) => Point; [****] => Line; <--> => length (see VARIABLES)
// M denotes an even number (2, 4, 6, or 8); L denotes an odd number (1, 3, 5, or 7)
// _________INTERIOR[1]________|_________EXTERIOR[3]_________
// |⟍                          |                          ⟋|
// |   ⟍                       |              [91L]--> ⟋   |
// |     ⟍                     |                     ⟋     |
// |       ⟍___________________|___________________⟋       |
// |        |⟍                 |                ⟋ |        |
// |{[100M],|  ⟍ <--[110L]     |    [310L]--> ⟋   | collocated at |x|=|y|=b1/2 + wth:
// | [101M],|    |⟍============|============⟋|    | {{300M],{301M], {310M]}, ascending.
// | [110M]}|    ||  ⟍<--[121L]|[321L]-->⟋  ||    |        |
// | [120M]----->||   |⟍=======|=======⟋|   ||<-----[320M] |
// | [121M]------>|   || ⟍ ____|____ ⟋ ||   |<------[321M] |
// | [130M]---------->||   |⟍  |  ⟋|   ||<----------[330M] |
// | [131M]----------->|   |  ⟍|⟋  |   |<-----------[331M] |
// | [140M]--------------->|  ⟋|⟍  |<---------------[340M] |
// |        |    ||   ||   |⟋__|__⟍|   ||   ||    |        |
// |        |    ||   || ⟋     |     ⟍ ||   ||    |        | collocated at |x|=|y|=boxw/2:
// |        |    ||   |⟋=======|=======⟍|   ||    |        | {{90M], {91M], {81M]},
// |        |    || ⟋          |          ⟍ ||    |        | ascending.
// |        |    |⟋============|============⟍|    |        |
// |        |  ⟋               |               ⟍  |        |
// |        |⟋_________________|_________________⟍|        |
// |      ⟋                    |                    ⟍      |
// |    ⟋                      |                      ⟍    |
// |  ⟋                        |                        ⟍  |
// |⟋__________________________|__________________________⟍|
// =====================================================================//
// VARIABLES__________________________________________________//
length_in_meters = 1.67; // length of each member
s = length_in_meters;    // scale factor

boxh = 45;   //        height of bounding box above ground level (z>0)
boxw = 60;   //         width of bounding box
boxz = -6;   //  signed depth of bounding box below ground level (z<0)
z0 = -3.285; //  signed depth of building below ground level

w1 = 21*s; w2 = 13*s; w3 =  7*s; // horizontal distances to outside of ledges
b1 = 27*s; b2 = 19*s; b3 = 11*s; // horizontal distances to inside of ledges; b0 = 26*s
h0 = 6.38*s;      // heights of walls
h1 = 3*Sqrt(2)*s;
h2 = 3*Sqrt(2)*s;
h3 = 2*Sqrt(2)*s;

z1 = z0 + h0;//  height level 1 from ground
z2 = z1 + h1;//  height level 2 from ground
z3 = z2 + h2;//  height level 3 from ground
z4 = z3 + h3;//  height level 4 from ground

wth = 1.0; // wall thickness

// angles for computing exterior points
alpha1 = Atan(h1/((b1-w1)/2)); beta1 = Pi/4-alpha1/2;
alpha2 = Atan(h2/((b2-w2)/2)); beta2 = Pi/4-alpha2/2;
alpha3 = Atan(h3/((b3-w3)/2)); beta3 = Pi/4-alpha3/2;

// I.  POINT DICTIONARY -----------

// 1. WALL INTERIOR POINTS
// i. @ level z=z0:
    Point(1001)  = { b1/2,  b1/2, z0, lc};
    Point(1003)  = {-b1/2,  b1/2, z0, lc};
    Point(1005)  = {-b1/2, -b1/2, z0, lc};
    Point(1007)  = { b1/2, -b1/2, z0, lc};
// ii. @ level z=0:
    Point(1011)  = { b1/2,  b1/2, 0, lc};
    Point(1013)  = {-b1/2,  b1/2, 0, lc};
    Point(1015)  = {-b1/2, -b1/2, 0, lc};
    Point(1017)  = { b1/2, -b1/2, 0, lc};
// iii. @ level z=z1:
    Point(1101)  = { b1/2,  b1/2, z1, lc};
    Point(1103)  = {-b1/2,  b1/2, z1, lc};
    Point(1105)  = {-b1/2, -b1/2, z1, lc};
    Point(1107)  = { b1/2, -b1/2, z1, lc};
// iv. @ level z=z2, |x|,|y| = w1/2:
    Point(1201)  = { w1/2,  w1/2, z2, lc};
    Point(1203)  = {-w1/2,  w1/2, z2, lc};
    Point(1205)  = {-w1/2, -w1/2, z2, lc};
    Point(1207)  = { w1/2, -w1/2, z2, lc};
// v. @ level z=z2, |x|,|y| = b2/2:
    Point(1211)  = { b2/2,  b2/2, z2, lc};
    Point(1213)  = {-b2/2,  b2/2, z2, lc};
    Point(1215)  = {-b2/2, -b2/2, z2, lc};
    Point(1217)  = { b2/2, -b2/2, z2, lc};
// vi. @ level z=z3, |x|,|y| = w2/2:
    Point(1301)  = { w2/2,  w2/2, z3, lc};
    Point(1303)  = {-w2/2,  w2/2, z3, lc};
    Point(1305)  = {-w2/2, -w2/2, z3, lc};
    Point(1307)  = { w2/2, -w2/2, z3, lc};
// vii. @ level z=z3, |x|,|y| = b3/2:
    Point(1311)  = { b3/2,  b3/2, z3, lc};
    Point(1313)  = {-b3/2,  b3/2, z3, lc};
    Point(1315)  = {-b3/2, -b3/2, z3, lc};
    Point(1317)  = { b3/2, -b3/2, z3, lc};
// viii. @ level z=z4, |x|,|y| = w3/2:
    Point(1401)  = { w3/2,  w3/2, z4, lc};
    Point(1403)  = {-w3/2,  w3/2, z4, lc};
    Point(1405)  = {-w3/2, -w3/2, z4, lc};
    Point(1407)  = { w3/2, -w3/2, z4, lc};
// 2. WALL EXTERIOR POINTS
// i. @ level z=0:
    Point(3011)  = {  b1/2 + wth ,   b1/2 + wth , 0, lc};
    Point(3013)  = {-(b1/2 + wth),   b1/2 + wth , 0, lc};
    Point(3015)  = {-(b1/2 + wth), -(b1/2 + wth), 0, lc};
    Point(3017)  = {  b1/2 + wth , -(b1/2 + wth), 0, lc};
// ii. @ level z=z1:
    Point(3101)  = {  b1/2 + wth,    b1/2 + wth,  z1 + wth*Tan(beta1), lc};
    Point(3103)  = {-(b1/2 + wth),   b1/2 + wth,  z1 + wth*Tan(beta1), lc};
    Point(3105)  = {-(b1/2 + wth), -(b1/2 + wth), z1 + wth*Tan(beta1), lc};
    Point(3107)  = {  b1/2 + wth,  -(b1/2 + wth), z1 + wth*Tan(beta1), lc};
// iii. @ level z=z2, |x|,|y| = w1/2:
    Point(3201)  = { w1/2 + wth*Tan(beta1),  w1/2 + wth*Tan(beta1), z2 + wth, lc};
    Point(3203)  = {-w1/2 - wth*Tan(beta1),  w1/2 + wth*Tan(beta1), z2 + wth, lc};
    Point(3205)  = {-w1/2 - wth*Tan(beta1), -w1/2 - wth*Tan(beta1), z2 + wth, lc};
    Point(3207)  = { w1/2 + wth*Tan(beta1), -w1/2 - wth*Tan(beta1), z2 + wth, lc};
// iv. @ level z=z2, |x|,|y| = b2/2:
    Point(3211)  = { b2/2 + wth*Tan(beta2),  b2/2 + wth*Tan(beta2), z2 + wth, lc};
    Point(3213)  = {-b2/2 - wth*Tan(beta2),  b2/2 + wth*Tan(beta2), z2 + wth, lc};
    Point(3215)  = {-b2/2 - wth*Tan(beta2), -b2/2 - wth*Tan(beta2), z2 + wth, lc};
    Point(3217)  = { b2/2 + wth*Tan(beta2), -b2/2 - wth*Tan(beta2), z2 + wth, lc};
// v. @ level z=z3, |x|,|y| = w2/2:
    Point(3301)  = { w2/2 + wth*Tan(beta2),  w2/2 + wth*Tan(beta2), z3 + wth, lc};
    Point(3303)  = {-w2/2 - wth*Tan(beta2),  w2/2 + wth*Tan(beta2), z3 + wth, lc};
    Point(3305)  = {-w2/2 - wth*Tan(beta2), -w2/2 - wth*Tan(beta2), z3 + wth, lc};
    Point(3307)  = { w2/2 + wth*Tan(beta2), -w2/2 - wth*Tan(beta2), z3 + wth, lc};
// vi. @ level z=z3, |x|,|y| = b3/2:
    Point(3311)  = { b3/2 + wth*Tan(beta3),  b3/2 + wth*Tan(beta3), z3 + wth, lc};
    Point(3313)  = {-b3/2 - wth*Tan(beta3),  b3/2 + wth*Tan(beta3), z3 + wth, lc};
    Point(3315)  = {-b3/2 - wth*Tan(beta3), -b3/2 - wth*Tan(beta3), z3 + wth, lc};
    Point(3317)  = { b3/2 + wth*Tan(beta3), -b3/2 - wth*Tan(beta3), z3 + wth, lc};
// vii. @ level z=z4, |x|,|y| = w3/2:
    Point(3401)  = { w3/2 + wth*Tan(beta3),  w3/2 + wth*Tan(beta3), z4 + wth, lc};
    Point(3403)  = {-w3/2 - wth*Tan(beta3),  w3/2 + wth*Tan(beta3), z4 + wth, lc};
    Point(3405)  = {-w3/2 - wth*Tan(beta3), -w3/2 - wth*Tan(beta3), z4 + wth, lc};
    Point(3407)  = { w3/2 + wth*Tan(beta3), -w3/2 - wth*Tan(beta3), z4 + wth, lc};
//3. BOUNDING BOX POINTS
// i. @ level z=boxz (ground):
    Point(901)   = { boxw/2,  boxw/2,  boxz, lc};
    Point(903)   = {-boxw/2,  boxw/2,  boxz, lc};
    Point(905)   = {-boxw/2, -boxw/2,  boxz, lc};
    Point(907)   = { boxw/2, -boxw/2,  boxz, lc};
// ii. @ level z=0 (ground):
    Point(911)   = { boxw/2,  boxw/2,  0, lc};
    Point(913)   = {-boxw/2,  boxw/2,  0, lc};
    Point(915)   = {-boxw/2, -boxw/2,  0, lc};
    Point(917)   = { boxw/2, -boxw/2,  0, lc};
// iii. @ level z=boxh (air):
    Point(811)   = { boxw/2,  boxw/2,  boxh, lc};
    Point(813)   = {-boxw/2,  boxw/2,  boxh, lc};
    Point(815)   = {-boxw/2, -boxw/2,  boxh, lc};
    Point(817)   = { boxw/2, -boxw/2,  boxh, lc};


//II. LINE DICTIONARY -----------

// 1. PLAN (PERIMETER) LINES =============
//   _______ 
//  |  ___  | Lines that form square perimeters.
//  | | □ | |
//  |_______|
//
// ________INTERIOR___________|________EXTERIOR_________              
// plan lines @ level z=z0:
    Line(1002) = {1001, 1003};
    Line(1004) = {1003, 1005};
    Line(1006) = {1005, 1007};
    Line(1008) = {1007, 1001};
// plan lines @ level z=0:
    Line(1012) = {1011, 1013}; Line(3012) = {3011, 3013};
    Line(1014) = {1013, 1015}; Line(3014) = {3013, 3015};
    Line(1016) = {1015, 1017}; Line(3016) = {3015, 3017};
    Line(1018) = {1017, 1011}; Line(3018) = {3017, 3011};
// plan lines @ level z=z1:
    Line(1102) = {1101, 1103}; Line(3102) = {3101, 3103};
    Line(1104) = {1103, 1105}; Line(3104) = {3103, 3105};
    Line(1106) = {1105, 1107}; Line(3106) = {3105, 3107};
    Line(1108) = {1107, 1101}; Line(3108) = {3107, 3101};
// plan lines @ level z=z2, |x|,|y| = w1/2:
    Line(1202) = {1201, 1203}; Line(3202) = {3201, 3203};
    Line(1204) = {1203, 1205}; Line(3204) = {3203, 3205};
    Line(1206) = {1205, 1207}; Line(3206) = {3205, 3207};
    Line(1208) = {1207, 1201}; Line(3208) = {3207, 3201};
// plan lines @ level z=z2, |x|,|y| = b2/2:
    Line(1212) = {1211, 1213}; Line(3212) = {3211, 3213};
    Line(1214) = {1213, 1215}; Line(3214) = {3213, 3215};
    Line(1216) = {1215, 1217}; Line(3216) = {3215, 3217};
    Line(1218) = {1217, 1211}; Line(3218) = {3217, 3211};
// plan lines @ level z=z3, |x|,|y| = w2/2:
    Line(1302) = {1301, 1303}; Line(3302) = {3301, 3303};
    Line(1304) = {1303, 1305}; Line(3304) = {3303, 3305};
    Line(1306) = {1305, 1307}; Line(3306) = {3305, 3307};
    Line(1308) = {1307, 1301}; Line(3308) = {3307, 3301};
// plan lines @ level z=z3, |x|,|y| = b3/2:
    Line(1312) = {1311, 1313}; Line(3312) = {3311, 3313};
    Line(1314) = {1313, 1315}; Line(3314) = {3313, 3315};
    Line(1316) = {1315, 1317}; Line(3316) = {3315, 3317};
    Line(1318) = {1317, 1311}; Line(3318) = {3317, 3311};
// plan lines @ level z=z4, |x|,|y| = w3/2:
    Line(1402) = {1401, 1403}; Line(3402) = {3401, 3403};
    Line(1404) = {1403, 1405}; Line(3404) = {3403, 3405};
    Line(1406) = {1405, 1407}; Line(3406) = {3405, 3407};
    Line(1408) = {1407, 1401}; Line(3408) = {3407, 3401};

// 2. CONCENTRIC AND CONCENTRIC CONNECTING LINES =============
//   ______ 
//  |⟍   ⟋| Lines that move on a diagonal from one corner to the center.
//  |  ⤫   |
//  |⟋___⟍|
// ________INTERIOR___________|______ENVELOPE___________|_________EXTERIOR_________
// corner lines from level z=z0 to z=0, |x|,|y| = b1/2:
    Line(1001) = {1001, 1011};
    Line(1003) = {1003, 1013};
    Line(1005) = {1005, 1015};
    Line(1007) = {1007, 1017};
// corner lines from level z=0 to z=z1, |x|,|y| = b1/2:
    Line(1011) = {1011, 1101}; Line(2011) = {1011, 3011}; Line(3011) = {3011, 3101}; 
    Line(1013) = {1013, 1103}; Line(2013) = {1013, 3013}; Line(3013) = {3013, 3103};
    Line(1015) = {1015, 1105}; Line(2015) = {1015, 3015}; Line(3015) = {3015, 3105};
    Line(1017) = {1017, 1107}; Line(2017) = {1017, 3017}; Line(3017) = {3017, 3107};
// corner lines from level z=z1, |x|,|y| = b1/2 to z=z2, |x|,|y| = w1/2:
    Line(1101) = {1101, 1201}; Line(2101) = {1101, 3101}; Line(3101) = {3101, 3201};
    Line(1103) = {1103, 1203}; Line(2103) = {1103, 3103}; Line(3103) = {3103, 3203};
    Line(1105) = {1105, 1205}; Line(2105) = {1105, 3105}; Line(3105) = {3105, 3205};
    Line(1107) = {1107, 1207}; Line(2107) = {1107, 3107}; Line(3107) = {3107, 3207};
// corner lines from |x|,|y| = w1/2 to |x|,|y| = b2/2, z=z2:
    Line(1201) = {1201, 1211}; Line(2201) = {1201, 3201}; Line(3201) = {3201, 3211};
    Line(1203) = {1203, 1213}; Line(2203) = {1203, 3203}; Line(3203) = {3203, 3213};
    Line(1205) = {1205, 1215}; Line(2205) = {1205, 3205}; Line(3205) = {3205, 3215};
    Line(1207) = {1207, 1217}; Line(2207) = {1207, 3207}; Line(3207) = {3207, 3217};
// corner lines from level z=z2, |x|,|y| = b2/2 to z=z3, |x|,|y| = w2/2:
    Line(1211) = {1211, 1301}; Line(2211) = {1211, 3211}; Line(3211) = {3211, 3301};
    Line(1213) = {1213, 1303}; Line(2213) = {1213, 3213}; Line(3213) = {3213, 3303};
    Line(1215) = {1215, 1305}; Line(2215) = {1215, 3215}; Line(3215) = {3215, 3305};
    Line(1217) = {1217, 1307}; Line(2217) = {1217, 3217}; Line(3217) = {3217, 3307};
// corner lines from |x|,|y| = w2/2 to |x|,|y| = b3/2, z=z3:
    Line(1301) = {1301, 1311}; Line(2301) = {1301, 3301}; Line(3301) = {3301, 3311};
    Line(1303) = {1303, 1313}; Line(2303) = {1303, 3303}; Line(3303) = {3303, 3313};
    Line(1305) = {1305, 1315}; Line(2305) = {1305, 3305}; Line(3305) = {3305, 3315};
    Line(1307) = {1307, 1317}; Line(2307) = {1307, 3307}; Line(3307) = {3307, 3317};
// corner lines from level z=z3, |x|,|y| = b3/2 to z=z4, |x|,|y| = w3/2:
    Line(1311) = {1311, 1401}; Line(2311) = {1311, 3311}; Line(3311) = {3311, 3401};
    Line(1313) = {1313, 1403}; Line(2313) = {1313, 3313}; Line(3313) = {3313, 3403};
    Line(1315) = {1315, 1405}; Line(2315) = {1315, 3315}; Line(3315) = {3315, 3405};
    Line(1317) = {1317, 1407}; Line(2317) = {1317, 3317}; Line(3317) = {3317, 3407};
// connecting lines at level z=z4:
                               Line(2401) = {1401, 3401};
                               Line(2403) = {1403, 3403};
                               Line(2405) = {1405, 3405};
                               Line(2407) = {1407, 3407};
// 3. BOUNDING BOX LINES =============
// horizontal lines @ level z=boxz:
    Line(902) = {901, 903};
    Line(904) = {903, 905};
    Line(906) = {905, 907};
    Line(908) = {907, 901};
// vertical lines from level z=boxz:
    Line(901) = {901, 911};
    Line(903) = {903, 913};
    Line(905) = {905, 915};
    Line(907) = {907, 917};
// horizontal lines @ level z=0 (ground):
    Line(912) = {911, 913};
    Line(914) = {913, 915};
    Line(916) = {915, 917};
    Line(918) = {917, 911};
// concentric lines @ level z=0 (ground):
    Line(911) = {911, 3011};
    Line(913) = {913, 3013};
    Line(915) = {915, 3015};
    Line(917) = {917, 3017};
//________________________________________
// vertical lines from level z=0:
    Line(811) = {911, 811}; // or (801, 811)
    Line(813) = {913, 813};
    Line(815) = {915, 815};
    Line(817) = {917, 817};
// horizontal lines @ level z=boxh:
    Line(812) = {811, 813};
    Line(814) = {813, 815};
    Line(816) = {815, 817};
    Line(818) = {817, 811};

//III. CURVELOOP/SURFACE DICTIONARY -----------
// 1. PERIMETER AND WALL COPLANAR PATHS =============
// perimeter and wall plane paths @ level z=z0:
    Curve Loop(1000) = {1002, 1004, 1006, 1008}; // perimeter path
    Curve Loop(1002) = {-1001, 1002, 1003, -1012}; // north wall
    Curve Loop(1004) = {-1003, 1004, 1005, -1014}; // west wall
    Curve Loop(1006) = {-1005, 1006, 1007, -1016}; // south wall
    Curve Loop(1008) = {-1007, 1008, 1001, -1018}; // east wall
// perimeter and wall plane paths @ level z=0:
    Curve Loop(1010) = {1012, 1014, 1016, 1018}; // perimeter path
    Curve Loop(1012) = {-1011, 1012, 1013, -1102}; Curve Loop(3012) = {-3011, 3012, 3013, -3102};
    Curve Loop(1014) = {-1013, 1014, 1015, -1104}; Curve Loop(3014) = {-3013, 3014, 3015, -3104};
    Curve Loop(1016) = {-1015, 1016, 1017, -1106}; Curve Loop(3016) = {-3015, 3016, 3017, -3106};
    Curve Loop(1018) = {-1017, 1018, 1011, -1108}; Curve Loop(3018) = {-3017, 3018, 3011, -3108};
// perimeter and wall plane paths @ level z=z1:
    Curve Loop(1100) = {1102, 1104, 1106, 1108};
    Curve Loop(1102) = {-1101, 1102, 1103, -1202}; Curve Loop(3102) = {-3101, 3102, 3103, -3202};
    Curve Loop(1104) = {-1103, 1104, 1105, -1204}; Curve Loop(3104) = {-3103, 3104, 3105, -3204};
    Curve Loop(1106) = {-1105, 1106, 1107, -1206}; Curve Loop(3106) = {-3105, 3106, 3107, -3206};
    Curve Loop(1108) = {-1107, 1108, 1101, -1208}; Curve Loop(3108) = {-3107, 3108, 3101, -3208};
// ledge paths @ level z=z2:
    // Curve Loop[1200] = {1202, 1204, 1206, 1208};
    Curve Loop(1202) = {-1201, 1202, 1203, -1212}; Curve Loop(3202) = {-3201, 3202, 3203, -3212};
    Curve Loop(1204) = {-1203, 1204, 1205, -1214}; Curve Loop(3204) = {-3203, 3204, 3205, -3214};
    Curve Loop(1206) = {-1205, 1206, 1207, -1216}; Curve Loop(3206) = {-3205, 3206, 3207, -3216};
    Curve Loop(1208) = {-1207, 1208, 1201, -1218}; Curve Loop(3208) = {-3207, 3208, 3201, -3218};
// perimeter and wall paths @ level z=z2:
    Curve Loop(1210) = {1212, 1214, 1216, 1218}; // interior to path 1200
    Curve Loop(1212) = {-1211, 1212, 1213, -1302}; Curve Loop(3212) = {-3211, 3212, 3213, -3302};
    Curve Loop(1214) = {-1213, 1214, 1215, -1304}; Curve Loop(3214) = {-3213, 3214, 3215, -3304};
    Curve Loop(1216) = {-1215, 1216, 1217, -1306}; Curve Loop(3216) = {-3215, 3216, 3217, -3306};
    Curve Loop(1218) = {-1217, 1218, 1211, -1308}; Curve Loop(3218) = {-3217, 3218, 3211, -3308};
// ledge paths @ level z=z3:
    // Curve Loop[1300] = {1302, 1304, 1306, 1308};
    Curve Loop(1302) = {-1301, 1302, 1303, -1312}; Curve Loop(3302) = {-3301, 3302, 3303, -3312};
    Curve Loop(1304) = {-1303, 1304, 1305, -1314}; Curve Loop(3304) = {-3303, 3304, 3305, -3314};
    Curve Loop(1306) = {-1305, 1306, 1307, -1316}; Curve Loop(3306) = {-3305, 3306, 3307, -3316};
    Curve Loop(1308) = {-1307, 1308, 1301, -1318}; Curve Loop(3308) = {-3307, 3308, 3301, -3318};
// perimeter and wall paths @ level z=z3:
    Curve Loop(1310) = {1312, 1314, 1316, 1318}; // interior to path 1300
    Curve Loop(1312) = {-1311, 1312, 1313, -1402}; Curve Loop(3312) = {-3311, 3312, 3313, -3402};
    Curve Loop(1314) = {-1313, 1314, 1315, -1404}; Curve Loop(3314) = {-3313, 3314, 3315, -3404};
    Curve Loop(1316) = {-1315, 1316, 1317, -1406}; Curve Loop(3316) = {-3315, 3316, 3317, -3406};
    Curve Loop(1318) = {-1317, 1318, 1311, -1408}; Curve Loop(3318) = {-3317, 3318, 3311, -3408};
// ceiling path @ level z=z4:
    Curve Loop(1400) = {1402, 1404, 1406, 1408}; Curve Loop(3400) = {3402, 3404, 3406, 3408};

// 2. PLAN CONNECTING PATHS =============
// connecting paths @ level z=0:
    Curve Loop(2012) = {-1012, 2011, 3012, -2013};
    Curve Loop(2014) = {-1014, 2013, 3014, -2015};
    Curve Loop(2016) = {-1016, 2015, 3016, -2017};
    Curve Loop(2018) = {-1018, 2017, 3018, -2011};
// connecting paths @ level z=z1:
    Curve Loop(2102) = {-1102, 2101, 3102, -2103};
    Curve Loop(2104) = {-1104, 2103, 3104, -2105};
    Curve Loop(2106) = {-1106, 2105, 3106, -2107};
    Curve Loop(2108) = {-1108, 2107, 3108, -2101};
// connecting paths @ level z=z2, |x|,|y| = w1/2:
    Curve Loop(2202) = {-1202, 2201, 3202, -2203};
    Curve Loop(2204) = {-1204, 2203, 3204, -2205};
    Curve Loop(2206) = {-1206, 2205, 3206, -2207};
    Curve Loop(2208) = {-1208, 2207, 3208, -2201};
// connecting paths @ level z=z2, |x|,|y| = b2/2:
    Curve Loop(2212) = {-1212, 2211, 3212, -2213};
    Curve Loop(2214) = {-1214, 2213, 3214, -2215};
    Curve Loop(2216) = {-1216, 2215, 3216, -2217};
    Curve Loop(2218) = {-1218, 2217, 3218, -2211};
// connecting paths @ level z=z3, |x|,|y| = w2/2:
    Curve Loop(2302) = {-1302, 2301, 3302, -2303};
    Curve Loop(2304) = {-1304, 2303, 3304, -2305};
    Curve Loop(2306) = {-1306, 2305, 3306, -2307};
    Curve Loop(2308) = {-1308, 2307, 3308, -2301};
// connecting paths @ level z=z3, |x|,|y| = b3/2:    
    Curve Loop(2312) = {-1312, 2311, 3312, -2313};
    Curve Loop(2314) = {-1314, 2313, 3314, -2315};
    Curve Loop(2316) = {-1316, 2315, 3316, -2317};
    Curve Loop(2318) = {-1318, 2317, 3318, -2311};
// connecting paths @ level z=z4:
    Curve Loop(2402) = {-1402, 2401, 3402, -2403};
    Curve Loop(2404) = {-1404, 2403, 3404, -2405};
    Curve Loop(2406) = {-1406, 2405, 3406, -2407};
    Curve Loop(2408) = {-1408, 2407, 3408, -2401};

// 3. CONCENTRIC CONNECTING PATHS =============
// connecting paths from level z=0 to z=z1:
    Curve Loop(2011) = {-1011, 2011, 3011, -2101};
    Curve Loop(2013) = {-1013, 2013, 3013, -2103};
    Curve Loop(2015) = {-1015, 2015, 3015, -2105};
    Curve Loop(2017) = {-1017, 2017, 3017, -2107};
// connecting paths from level z=z1 to z=z2:
    Curve Loop(2101) = {-1101, 2101, 3101, -2201};
    Curve Loop(2103) = {-1103, 2103, 3103, -2203};
    Curve Loop(2105) = {-1105, 2105, 3105, -2205};
    Curve Loop(2107) = {-1107, 2107, 3107, -2207};
// connecting paths from |x|,|y| = w1/2 to |x|,|y| = b2/2, z=z2:
    Curve Loop(2201) = {-1201, 2201, 3201, -2211};
    Curve Loop(2203) = {-1203, 2203, 3203, -2213};
    Curve Loop(2205) = {-1205, 2205, 3205, -2215};
    Curve Loop(2207) = {-1207, 2207, 3207, -2217};
// connecting paths from level z=z2 to z=z3:
    Curve Loop(2211) = {-1211, 2211, 3211, -2301};
    Curve Loop(2213) = {-1213, 2213, 3213, -2303};
    Curve Loop(2215) = {-1215, 2215, 3215, -2305};
    Curve Loop(2217) = {-1217, 2217, 3217, -2307};
// connecting paths from |x|,|y| = w2/2 to |x|,|y| = b3/2, z=z3:
    Curve Loop(2301) = {-1301, 2301, 3301, -2311};
    Curve Loop(2303) = {-1303, 2303, 3303, -2313};
    Curve Loop(2305) = {-1305, 2305, 3305, -2315};
    Curve Loop(2307) = {-1307, 2307, 3307, -2317};
// connecting paths from level z=z3 to z=z4:
    Curve Loop(2311) = {-1311, 2311, 3311, -2401};
    Curve Loop(2313) = {-1313, 2313, 3313, -2403};
    Curve Loop(2315) = {-1315, 2315, 3315, -2405};
    Curve Loop(2317) = {-1317, 2317, 3317, -2407};

// 4. BOUNDING BOX PATHS =============
    Curve Loop(900) = {902, 904, 906, 908}; // perimeter paths @ level z=boxz:
    Curve Loop(800) = {812, 814, 816, 818}; // perimeter paths @ level z=boxh:
// bounding box wall paths below ground
    Curve Loop(902) = {-902, 901, 912, -903};
    Curve Loop(904) = {-904, 903, 914, -905};
    Curve Loop(906) = {-906, 905, 916, -907};
    Curve Loop(908) = {-908, 907, 918, -901};
// sky-ground interface paths @ z=0:
    Curve Loop(912) = {911, 3012, -913, -912};
    Curve Loop(914) = {913, 3014, -915, -914};
    Curve Loop(916) = {915, 3016, -917, -916};
    Curve Loop(918) = {917, 3018, -911, -918};
// bounding box wall paths above ground
    Curve Loop(802) = {-812, -811, 912, 813};
    Curve Loop(804) = {-814, -813, 914, 815};
    Curve Loop(806) = {-816, -815, 916, 817};
    Curve Loop(808) = {-818, -817, 918, 811};
//IV. SURFACE LOOP DICTIONARY -----------
// make surface loops for each volume
// 1. INTERIOR VOLUMES =============
// for z > z1:
// the outer area (w*) is labeled 1x0* and is used as the cap of each volume
// the inner area (b*) is labeled 1x1* and is used as the base of each volume
    Surface Loop(1000) = {-1000, 1002, 1004, 1006, 1008, 1010};
    Surface Loop(1010) = {-1010, 1012, 1014, 1016, 1018, 1100};
    Surface Loop(1100) = {-1100, 1102, 1104, 1106, 1108, 1202, 1204, 1206, 1208, 1210}; // 1200);
    Surface Loop(1200) = {-1210, 1212, 1214, 1216, 1218, 1302, 1304, 1306, 1308, 1310}; // 1300);
    Surface Loop(1300) = {-1310, 1312, 1314, 1316, 1318, 1400};

// 2. WALL VOLUMES =============
// side wall volume from level z=0 to z=z1:
    Surface Loop(2012) = {2012, 2013, -2011, 1012, -3012, 2102};
    Surface Loop(2014) = {2014, 2015, -2013, 1014, -3014, 2104};
    Surface Loop(2016) = {2016, 2017, -2015, 1016, -3016, 2106};
    Surface Loop(2018) = {2018, 2011, -2017, 1018, -3018, 2108};
// side wall volume from level z=z1 to z=z2:
    Surface Loop(2102) = {2102, 2103, -2101, 1102, -3102, 2202};
    Surface Loop(2104) = {2104, 2105, -2103, 1104, -3104, 2204};
    Surface Loop(2106) = {2106, 2107, -2105, 1106, -3106, 2206};
    Surface Loop(2108) = {2108, 2101, -2107, 1108, -3108, 2208};
// ledge wall volume @ level z=z2:
    Surface Loop(2202) = {2202, 2203, -2201, 1202, -3202, 2212};
    Surface Loop(2204) = {2204, 2205, -2203, 1204, -3204, 2214};
    Surface Loop(2206) = {2206, 2207, -2205, 1206, -3206, 2216};
    Surface Loop(2208) = {2208, 2201, -2207, 1208, -3208, 2218};
// side wall volume from level z=z2 to z=z3:
    Surface Loop(2212) = {2212, 2213, -2211, 1212, -3212, 2302};
    Surface Loop(2214) = {2214, 2215, -2213, 1214, -3214, 2304};
    Surface Loop(2216) = {2216, 2217, -2215, 1216, -3216, 2306};
    Surface Loop(2218) = {2218, 2211, -2217, 1218, -3218, 2308};
// ledge wall volume @ level z=z3:
    Surface Loop(2302) = {2302, 2303, -2301, 1302, -3302, 2312};
    Surface Loop(2304) = {2304, 2305, -2303, 1304, -3304, 2314};
    Surface Loop(2306) = {2306, 2307, -2305, 1306, -3306, 2316};
    Surface Loop(2308) = {2308, 2301, -2307, 1308, -3308, 2318};
// side wall volume from level z=z3 to z=z4:
    Surface Loop(2312) = {2312, 2313, -2311, 1312, -3312, 2402};
    Surface Loop(2314) = {2314, 2315, -2313, 1314, -3314, 2404};
    Surface Loop(2316) = {2316, 2317, -2315, 1316, -3316, 2406};
    Surface Loop(2318) = {2318, 2311, -2317, 1318, -3318, 2408};
// ceiling volume @ level z=z4:
    Surface Loop(2400) = {1400, 2402, 2404, 2406, 2408, 3400};

// 3. BOUNDING BOX VOLUMES =============
// ground volume:
    Surface Loop(900) = {900, 902, 904, 906, 908, 
                        912, 914, 916, 918, 
                       2012, 2014, 2016, 2018,
                       1000, 1002, 1004, 1006, 1008};
// air volume above ground:
    Surface Loop(800) = {800, 802, 804, 806, 808, 
                        912, 914, 916, 918, 
                       3012, 3014, 3016, 3018,
                       3102, 3104, 3106, 3108,
                       3202, 3204, 3206, 3208,
                       3212, 3214, 3216, 3218,
                       3302, 3304, 3306, 3308,
                       3312, 3314, 3316, 3318, 3400};

// List of surfaces, based on curve loops:
Plane Surface(1000) = {1000};
Plane Surface(1002) = {1002};
Plane Surface(1004) = {1004};
Plane Surface(1006) = {1006};
Plane Surface(1008) = {1008};
Plane Surface(1010) = {1010};
Plane Surface(1012) = {1012};
Plane Surface(1014) = {1014};
Plane Surface(1016) = {1016};
Plane Surface(1018) = {1018};
Plane Surface(1100) = {1100};
Plane Surface(1102) = {1102};
Plane Surface(1104) = {1104};
Plane Surface(1106) = {1106};
Plane Surface(1108) = {1108};
Plane Surface(1202) = {1202};
Plane Surface(1204) = {1204};
Plane Surface(1206) = {1206};
Plane Surface(1208) = {1208};
Plane Surface(1210) = {1210};
Plane Surface(1212) = {1212};
Plane Surface(1214) = {1214};
Plane Surface(1216) = {1216};
Plane Surface(1218) = {1218};
Plane Surface(1302) = {1302};
Plane Surface(1304) = {1304};
Plane Surface(1306) = {1306};
Plane Surface(1308) = {1308};
Plane Surface(1310) = {1310};
Plane Surface(1312) = {1312};
Plane Surface(1314) = {1314};
Plane Surface(1316) = {1316};
Plane Surface(1318) = {1318};
Plane Surface(1400) = {1400};
Plane Surface(2011) = {2011};
Plane Surface(2012) = {2012};
Plane Surface(2013) = {2013};
Plane Surface(2014) = {2014};
Plane Surface(2015) = {2015};
Plane Surface(2016) = {2016};
Plane Surface(2017) = {2017};
Plane Surface(2018) = {2018};
Plane Surface(2101) = {2101};
Plane Surface(2102) = {2102};
Plane Surface(2103) = {2103};
Plane Surface(2104) = {2104};
Plane Surface(2105) = {2105};
Plane Surface(2106) = {2106};
Plane Surface(2107) = {2107};
Plane Surface(2108) = {2108};
Plane Surface(2201) = {2201};
Plane Surface(2202) = {2202};
Plane Surface(2203) = {2203};
Plane Surface(2204) = {2204};
Plane Surface(2205) = {2205};
Plane Surface(2206) = {2206};
Plane Surface(2207) = {2207};
Plane Surface(2208) = {2208};
Plane Surface(2211) = {2211};
Plane Surface(2212) = {2212};
Plane Surface(2213) = {2213};
Plane Surface(2214) = {2214};
Plane Surface(2215) = {2215};
Plane Surface(2216) = {2216};
Plane Surface(2217) = {2217};
Plane Surface(2218) = {2218};
Plane Surface(2301) = {2301};
Plane Surface(2302) = {2302};
Plane Surface(2303) = {2303};
Plane Surface(2304) = {2304};
Plane Surface(2305) = {2305};
Plane Surface(2306) = {2306};
Plane Surface(2307) = {2307};
Plane Surface(2308) = {2308};
Plane Surface(2311) = {2311};
Plane Surface(2312) = {2312};
Plane Surface(2313) = {2313};
Plane Surface(2314) = {2314};
Plane Surface(2315) = {2315};
Plane Surface(2316) = {2316};
Plane Surface(2317) = {2317};
Plane Surface(2318) = {2318};
Plane Surface(2402) = {2402};
Plane Surface(2404) = {2404};
Plane Surface(2406) = {2406};
Plane Surface(2408) = {2408};
Plane Surface(3012) = {3012};
Plane Surface(3014) = {3014};
Plane Surface(3016) = {3016};
Plane Surface(3018) = {3018};
Plane Surface(3102) = {3102};
Plane Surface(3104) = {3104};
Plane Surface(3106) = {3106};
Plane Surface(3108) = {3108};
Plane Surface(3202) = {3202};
Plane Surface(3204) = {3204};
Plane Surface(3206) = {3206};
Plane Surface(3208) = {3208};
Plane Surface(3212) = {3212};
Plane Surface(3214) = {3214};
Plane Surface(3216) = {3216};
Plane Surface(3218) = {3218};
Plane Surface(3302) = {3302};
Plane Surface(3304) = {3304};
Plane Surface(3306) = {3306};
Plane Surface(3308) = {3308};
Plane Surface(3312) = {3312};
Plane Surface(3314) = {3314};
Plane Surface(3316) = {3316};
Plane Surface(3318) = {3318};
Plane Surface(3400) = {3400};
Plane Surface(800) = {800};
Plane Surface(802) = {802};
Plane Surface(804) = {804};
Plane Surface(806) = {806};
Plane Surface(808) = {808};
Plane Surface(900) = {900};
Plane Surface(902) = {902};
Plane Surface(904) = {904};
Plane Surface(906) = {906};
Plane Surface(908) = {908};
Plane Surface(912) = {912};
Plane Surface(914) = {914};
Plane Surface(916) = {916};
Plane Surface(918) = {918};

// List of volumes, based on surface loops:
Volume(1000) = {1000};
Volume(1010) = {1010};
Volume(1100) = {1100};
Volume(1200) = {1200};
Volume(1300) = {1300};
Volume(2012) = {2012};
Volume(2014) = {2014};
Volume(2016) = {2016};
Volume(2018) = {2018};
Volume(2102) = {2102};
Volume(2104) = {2104};
Volume(2106) = {2106};
Volume(2108) = {2108};
Volume(2202) = {2202};
Volume(2204) = {2204};
Volume(2206) = {2206};
Volume(2208) = {2208};
Volume(2212) = {2212};
Volume(2214) = {2214};
Volume(2216) = {2216};
Volume(2218) = {2218};
Volume(2302) = {2302};
Volume(2304) = {2304};
Volume(2306) = {2306};
Volume(2308) = {2308};
Volume(2312) = {2312};
Volume(2314) = {2314};
Volume(2316) = {2316};
Volume(2318) = {2318};
Volume(2400) = {2400};
Volume(800) = {800};
Volume(900) = {900};

Physical Surface("maxY") = {802, 902};
Physical Surface("minX") = {804, 904};
Physical Surface("minY") = {806, 906};
Physical Surface("maxX") = {808, 908};
Physical Surface("minZ") = {900};
Physical Surface("maxZ") = {800};

Physical Volume("interior") = {1000, 1010, 1100, 1200, 1300};
Physical Volume("envelope") = {2012, 2014, 2016, 2018, 2102, 2104, 2106, 2108, 2202, 2204, 2206, 2208, 2212, 2214, 2216, 2218, 2302, 2304, 2306, 2308, 2312, 2314, 2316, 2318, 2400};
Physical Volume("exterior") = {800};
Physical Volume("ground") = {900};
