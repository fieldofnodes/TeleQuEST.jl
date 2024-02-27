# TeleQuEST

<!--[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://fieldofnodes.github.io/TeleQuEST.jl/stable/)-->
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://fieldofnodes.github.io/TeleQuEST.jl/dev/)
[![Build Status](https://github.com/fieldofnodes/TeleQuEST.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/fieldofnodes/TeleQuEST.jl/actions/workflows/CI.yml?query=branch%3Amain)

[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/E/Example.svg
[pkgeval-url]: https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/T/TeleQuEST.html
[![][pkgeval-img]][pkgeval-url]


```julia
] add https://github.com/fieldofnodes/TeleQuEST.jl # Will be add TeleQuEST once registered
```


```julia
using TeleQuEST
```

```julia
env = createQuESTEnv()
num_qubits = 3
client_idx = 1
server_idx = [2,3]
angles = [0.0,0.0]
qureg = createDensityQureg(num_qubits,env)
te = TeleportationModel(BellStateTeleportation(qureg,BellPair(client_idx,missing),angles))
output = teleport!(te)
```

