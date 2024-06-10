This directory contains trained neural-operator-based surrogate models emulating corresponding building twins. The neural operators, $\mathcal{F}$ act as maps
```math
  \mathcal{F}:\mathcal{U}\times\mathcal{M}\to\mathcal{U}^\tau,
```
taking in state variables $u_0\in\mathcal{U}$ and parameter realization $m\in\mathcal{M}$ and producing state trajectories $`\{u_1,u_2,\dots,u_\tau\}\in\mathcal{U}^\tau`$.
