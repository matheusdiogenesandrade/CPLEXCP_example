using CPLEXCP
using JuMP
using MathOptInterface
using ConstraintProgrammingExtensions

const MOI = MathOptInterface
const CP = ConstraintProgrammingExtensions

model = Model(CPLEXCP.Optimizer)

a = first(MOI.add_constrained_variable(model.moi_backend, MOI.Integer()))
b = first(MOI.add_constrained_variable(model.moi_backend, MOI.Integer()))
c = first(MOI.add_constrained_variable(model.moi_backend, MOI.Integer()))


coeff = [5, 4, 7]
var = [a, b, c]

objFunc = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(map(c -> c, coeff), map(v -> v, var)), 0)

time_limit = 10
#MOI.set(model, MOI.NumberOfThreads(), 1)
#MOI.set(model, MOI.Silent(), true)
#MOI.set(model.moi_backend, MOI.TimeLimitSec(), time_limit)


MOI.optimize!(model.moi_backend)

@show MOI.get(model.moi_backend, MOI.VariablePrimal(), a)

@show MOI.get(model.moi_backend, MOI.VariablePrimal(), b)

@show MOI.get(model.moi_backend, MOI.VariablePrimal(), c)
