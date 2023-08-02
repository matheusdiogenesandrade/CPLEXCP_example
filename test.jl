using CPLEXCP
using MathOptInterface
using ConstraintProgrammingExtensions

const MOI = MathOptInterface
const CP = ConstraintProgrammingExtensions

model = CPLEXCP.Optimizer()

a = first(MOI.add_constrained_variable(model, MOI.Integer()))
b = first(MOI.add_constrained_variable(model, MOI.Integer()))
c = first(MOI.add_constrained_variable(model, MOI.Integer()))


coeff = [5, 4, 7]
var = [a, b, c]

objFunc = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(map(c -> c, coeff), map(v -> v, var)), 0)

model.objective_function = objFunc

model.objective_sense = MOI.MAX_SENSE

MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
MOI.set(model, MOI.ObjectiveFunction{typeof(objFunc)}(), objFunc)

time_limit = 10
#MOI.set(model, MOI.NumberOfThreads(), 1)
#MOI.set(model, MOI.Silent(), true)
#MOI.set(model, MOI.TimeLimitSec(), time_limit)


MOI.optimize!(model)

@show MOI.get(model, MOI.VariablePrimal(), a)

@show MOI.get(model, MOI.VariablePrimal(), b)

@show MOI.get(model, MOI.VariablePrimal(), c)
