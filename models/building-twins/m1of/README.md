# Model-1
Model-1 uses OpenFOAM to simulate conjugate heat transfer due to convection and conduction, not including radiation, in Geometry-1, which is a two-dimensional cross-section of a simplified Biosphere 2. Fixed temperature boundary conditions are applied to the walls. The physics solvers being used are:
- buoyantBoussinesqPimpleFoam (transient solver)

This model was developed from the [OpenFOAM tutorial hotRoom](https://develop.openfoam.com/Development/openfoam/-/tree/master/tutorials/heatTransfer/buoyantBoussinesqPimpleFoam/hotRoom) on [natural convection in a rectangular domain](https://www.xsim.info/articles/OpenFOAM/en-US/tutorials/heatTransfer-buoyantBoussinesqPimpleFoam-hotRoom.html).

Geometry-2 is encoded as a .msh file, and so must be converted using [gmshToFoam](https://openfoamwiki.net/index.php/GmshToFoam). This step is included in the Allrun script.