// Gmsh project created on Tue Mar 12 14:48:08 2024
SetFactory("OpenCASCADE");

length_in_meters = 1.67; // length of each member
s = length_in_meters;    // scale factor

lc = 1e-1;
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

Point(1)  = { b1/2, 0, z0, lc};
Point(2)  = { b1/2, 0, z1, lc};
Point(3)  = { w1/2, 0, z2, lc};
Point(4)  = { b2/2, 0, z2, lc};
Point(5)  = { w2/2, 0, z3, lc};
Point(6)  = { b3/2, 0, z3, lc};
Point(7)  = { w3/2, 0, z4, lc};
Point(8)  = {-w3/2, 0, z4, lc};
Point(9)  = {-b3/2, 0, z3, lc};
Point(10) = {-w2/2, 0, z3, lc};
Point(11) = {-b2/2, 0, z2, lc};
Point(12) = {-w1/2, 0, z2, lc};
Point(13) = {-b1/2, 0, z1, lc};
Point(14) = {-b1/2, 0, z0, lc};

Line(1) = {1, 2};
Line(2) = {2, 3};
Line(3) = {3, 4};
Line(4) = {4, 5};
Line(5) = {5, 6};
Line(6) = {6, 7};
Line(7) = {7, 8};
Line(8) = {8, 9};
Line(9) = {9, 10};
Line(10) = {10, 11};
Line(11) = {11, 12};
Line(12) = {12, 13};
Line(13) = {13, 14};
Line(14) = {14, 1};

// support lines
Line(15) = {2, 13};
Line(16) = {4, 11};
Line(17) = {6,  9};

Curve Loop(1) = {1, 15, 13, 14};
Curve Loop(2) = {2, 3, 16, 11, 12, -15};
Curve Loop(3) = {4, 5, 17, 9, 10, -16};
Curve Loop(4) = {6, 7, 8, -17};

Plane Surface(1) = {1};
Plane Surface(2) = {2};
Plane Surface(3) = {3};
Plane Surface(4) = {4};

Transfinite Curve{1, 2, 4, 6, 8, 10, 12, 13} = 21;
Transfinite Curve{3, 5, 9, 11} = 3 Using Progression 1.2;
Transfinite Curve{14} = 41; // bottom
Transfinite Curve{15} = 41;
Transfinite Curve{16} = 37;
Transfinite Curve{17} = 33;
Transfinite Curve{7}  = 33;

Transfinite Surface{1} = {1, 2, 13, 14};
Recombine Surface{1};
Transfinite Surface{2} = {2, 3, 12, 13};
Recombine Surface{2};
Transfinite Surface{3} = {4, 5, 10, 11};
Recombine Surface{3};
Transfinite Surface{4} = {6, 7, 8, 9};
Recombine Surface{4};

h = 1.0;
surfaceVector[] = Extrude{0,h,0} {
    Surface{1,2,3,4};
    Layers{1};
    Recombine;
};

Physical Surface("bottom") = {8};
Physical Surface("eastBase") = {5};
Physical Surface("westBase") = {7};
Physical Surface("topFace") = {23};
Physical Surface("eastLedge") = {11, 17};
Physical Surface("westLedge") = {13, 19};
Physical Surface("eastSlope") = {10, 16, 22};
Physical Surface("westSlope") = {14, 20, 24};

// add in out-of-plane surfaces?
Physical Surface("front") = {9, 15, 21, 25};
Physical Surface("back")  = {1, 2, 3, 4};

Physical Volume("interior") = {1, 2, 3, 4};