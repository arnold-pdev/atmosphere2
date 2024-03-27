// Gmsh project created on Tue Mar 12 14:48:08 2024
SetFactory("OpenCASCADE");
lc = 1e-1;
bl = 0.1;
ln = 7;

h0 = 10.655;
h1 = 7.19;
h2 = 7.16;
h3 = 5.28;
w1 = 35.00;
w2 = 21.8;
w3 = 11.56;
b1 = 46.00;
b2 = 31.8;
b3 = 19.00;

z0 = -3.285;
z1 = z0 + h0;
z2 = z1 + h1;
z3 = z2 + h2;
z4 = z3 + h3;

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
Transfinite Curve{3, 5, 9, 11} = ln;
Transfinite Curve{14} = 41 Using Bump bl; // bottom
Transfinite Curve{15} = 41 Using Bump bl;
Transfinite Curve{16} = 41 - 2*(ln-1) Using Bump bl;
Transfinite Curve{17} = 41 - 4*(ln-1) Using Bump bl;
Transfinite Curve{7}  = 41 - 4*(ln-1) Using Bump bl;

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