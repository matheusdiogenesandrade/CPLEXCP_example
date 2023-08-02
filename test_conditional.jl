using CPLEXCP
using MathOptInterface
using ConstraintProgrammingExtensions

const MOI = MathOptInterface
const CP = ConstraintProgrammingExtensions

model = CPLEXCP.Optimizer()

x = first(MOI.add_constrained_variable(model, MOI.Integer()))
p = first(MOI.add_constrained_variable(model, MOI.Integer()))
q = first(MOI.add_constrained_variable(model, MOI.Interval(0.0, 10.0)))


coeff = [5.0, 4.0, 7.0]
var = [x, p, q]

objFunc = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(map(c -> c, coeff), map(v -> v, var)), 0.0)

model.objective_function = objFunc

model.objective_sense = MOI.MAX_SENSE

MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
MOI.set(model, MOI.ObjectiveFunction{typeof(objFunc)}(), objFunc)

affine::MOI.ScalarAffineFunction{Float64} = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm{Float64}.([1, -1], [p, q]), 0.0)


MOI.add_constraint(
                   model,
                   MOI.Utilities.operate(vcat, MOI.ScalarAffineFunction{Float64}, MOI.SingleVariable(x), affine),
                   CP.Implication(MOI.EqualTo(10), MOI.EqualTo(-5)),
                  )

MOI.optimize!(model)

@show MOI.get(model, MOI.VariablePrimal(), x)
@show MOI.get(model, MOI.VariablePrimal(), p)
@show MOI.get(model, MOI.VariablePrimal(), q)
