# TeleQuEST

<!--[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://fieldofnodes.github.io/TeleQuEST.jl/stable/)-->
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://fieldofnodes.github.io/TeleQuEST.jl/dev/)
[![Build Status](https://github.com/fieldofnodes/TeleQuEST.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/fieldofnodes/TeleQuEST.jl/actions/workflows/CI.yml?query=branch%3Amain)

[pkgeval-img]: https://juliaci.github.io/NanosoldierReports/pkgeval_badges/E/Example.svg
[pkgeval-url]: https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/T/TeleQuEST.html
[![][pkgeval-img]][pkgeval-url]

# Qubit teleportation

Qubit teleportation implemented for simple bell pairs between a single qubit and differeing indices to emulate a perfect client (single qubit quantum computer) and a server (multiple quantum computer) for blind quantum computing. 

# Getting started

Add the package

```julia
] add https://github.com/fieldofnodes/TeleQuEST.jl # Will be add TeleQuEST once registered
```

add `QuEST` (`] add QuEST` if not already done, then `using QuEST`.)

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

The output from `teleport!` is the struct: `InitialisedServer` and has the following fields.

```julia
mutable struct InitialisedServer <: Teleportation
    qureg::Qureg
    adapted_prep_angles::Vector{Float64}
    server_indices::Vector{Union{Int,Int64}}
end
```

The updated register, the adapted angles and indices relevant to the "server" (eg. qubit 1 is the client and the iterator [2,3] is the server).

