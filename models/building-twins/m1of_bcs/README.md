# Model-1: BCs
Model-1 uses OpenFOAM to simulate conjugate heat transfer due to convection and conduction, not including radiation, in Geometry-1, which is a two-dimensional cross-section of a simplified Biosphere 2. Fixed temperature boundary conditions are applied to the walls. The physics solvers being used are:
- buoyantBoussinesqPimpleFoam (transient solver)

Custom boundary conditions can be implemented in the codeDict dictionary file located in system to set the fields (refValue, refGrad, and valueFraction) of the codedMixed boundary condition.

The codedMixed BC has the following effect: to set the patch value $u_p$ to satisfy the equality
``` math 
u_p = wu_p+(1-w)\left(u_c+\frac{\nabla_\perp u}{\Delta}\right),
```
where $u_c$ is the patch internal cell value, $\nabla_\perp$ is the normal derivative, $w\in [0,1]$ is the value fraction field, and $\Delta$ is the inverse distance from face center to internal cell center.

----
This model was developed from the [OpenFOAM tutorial hotRoom](https://develop.openfoam.com/Development/openfoam/-/tree/master/tutorials/heatTransfer/buoyantBoussinesqPimpleFoam/hotRoom) on [natural convection in a rectangular domain](https://www.xsim.info/articles/OpenFOAM/en-US/tutorials/heatTransfer-buoyantBoussinesqPimpleFoam-hotRoom.html).

Geometry-2 is encoded as a .msh file, and so must be converted using [gmshToFoam](https://openfoamwiki.net/index.php/GmshToFoam). This step is included in the Allrun script.
