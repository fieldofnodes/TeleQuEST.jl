##################################################################
# Filename  : TeleQuEST.jl
# Author    : Jonathan Miller
# Date      : 2024-02-26
# Aim       : aim_script
#           : Module for teleporting a qubit
#           : To be used in verification protocols
##################################################################

module TeleQuEST

using QuEST
using Base: range

export 
    Teleportation,
    TeleportationModel,
    BellPair,
    BellStateTeleportation,
    teleport!
        

    
function max_damping!(qureg::Qureg,qubit_idx::Union{Int,Int64})
    mixDamping(qureg,qubit_idx,1.0)
end

abstract type Teleportation end


mutable struct BellPair <: Teleportation
    client_idx::Union{Int,Int64}
    server_idx::Union{Int,Int64,Missing}
end

mutable struct BellStateTeleportation <: Teleportation 
    qureg::Qureg
    bell_pair::BellPair
    basis_angle::Vector{Float64}
end



mutable struct TeleportationModel <: Teleportation
    model::Teleportation
end

mutable struct BasisSpecification 
    qureg::Qureg
    client_idx::Union{Int,Int64}
    basis_angle::Float64
end

mutable struct InitialisedServer <: Teleportation
    qureg::Qureg
    adapted_prep_angles::Vector{Float64}
    server_indices::Vector{Union{Int,Int64}}
end

function get_quantum_backend(bst::BellStateTeleportation)
    bst.qureg
end

function get_num_qubits(bst::BellStateTeleportation)
    qureg = get_quantum_backend(bst)
    QuEST.get_num_qubits(qureg)
end
function server_size(bst::BellStateTeleportation)
    get_num_qubits(bst) - 1
end

function server_index(bst::BellStateTeleportation)
    bst.bell_pair.server_idx + 1 # Client qubit is 1
end

function client_index(bst::BellStateTeleportation)
    bst.bell_pair.client_idx
end

function angle_index(bst::BellStateTeleportation)
    bst.bell_pair.server_idx
end

function angle(bst::BellStateTeleportation)
    bst.basis_angle[angle_index(bst)]
end

function measure(bst::BellStateTeleportation)
    QuEST.measure(get_quantum_backend(bst),client_index(bst))
end

function Base.range(bst::BellStateTeleportation)
    num_qubits = get_num_qubits(bst)
    setdiff(Base.OneTo(num_qubits),client_index(bst))
end



function basis_specification(bst::BellStateTeleportation)
    return BasisSpecification(get_quantum_backend(bst),client_index(bst),angle(bst))
end



function apply_basis_change!(bm::BasisSpecification)
    qureg,client_idx,θ = bm.qureg,bm.client_idx,bm.basis_angle
    rotateZ(qureg,client_idx,-θ)   
    hadamard(qureg,client_idx)
end

function entangle!(bst::BellStateTeleportation)
    qureg = get_quantum_backend(bst)
    client_idx = client_index(bst)
    server_idx = server_index(bst)
    max_damping!(qureg,client_idx)
    max_damping!(qureg,server_idx)
    pauliX(qureg,client_idx)
    pauliX(qureg,server_idx)
    hadamard(qureg,client_idx)
    controlledNot(qureg,client_idx,server_idx)
end  



function teleport!(te::Teleportation) 
    bst = te.model
    qureg = get_quantum_backend(bst)
    server_num_qubits = server_size(bst)
    cidx = client_index(bst)
    outcomes = []
    for s in Base.OneTo(server_num_qubits)
        bp = BellPair(cidx,s)
        bst = BellStateTeleportation(qureg,bp,bst.basis_angle)
        entangle!(bst)
        basis_specification(bst) |> apply_basis_change!
        o = measure(bst)
        state_prep_angle = angle(bst) + π*o*1.0 + π*1.0
        push!(outcomes,state_prep_angle)

    end
    InitialisedServer(qureg,outcomes,range(bst))

end

end