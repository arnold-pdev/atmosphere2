# Model-2
Model-2 uses OpenFOAM to simulate conjugate heat transfer, including radiation, in Geometry-2, which is a two-dimensional cross-section of a simplified Biosphere 2 with a finite-thickness envelope (shell) and a rectangular external domain. The physics solvers being used are:
- chtMultiRegionFoam (transient solver)
- viewFactor
This model was developed from the [OpenFOAM tutorial externalSolarLoad](https://develop.openfoam.com/Development/openfoam/-/tree/master/tutorials/heatTransfer/chtMultiRegionFoam/externalSolarLoad), which models the heat transfer around a cube with a solar load.

Geometry-2 is encoded as a .msh file, and so must be converted using [gmshToFoam](https://openfoamwiki.net/index.php/GmshToFoam). This step is included in the Allrun script.