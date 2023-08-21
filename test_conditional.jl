using CPLEXCP
using MathOptInterface
using ConstraintProgrammingExtensions

const MOI = MathOptInterface
const CP = ConstraintProgrammingExtensions

model = CPLEXCP.Optimizer()

x = first(MOI.add_constrained_variable(model, MOI.Integer()))
p = first(MOI.add_constrained_variable(model, MOI.Integer()))
q = first(MOI.add_constrained_variable(model, MOI.Integer()))

# if x = 10 then p + 5 = q

# p - q
affine::MOI.ScalarAffineFunction{Int64} = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm{Int64}.([1, -1], [p, q]), 0)

# [x, p - q]
terms::MOI.VectorAffineFunction{Int64} = MOI.Utilities.operate(vcat, Int64, x, affine)

# [10, - 5]
implication::CP.Implication{MOI.EqualTo{Int64}, MOI.EqualTo{Int64}} = CP.Implication(MOI.EqualTo(10), MOI.EqualTo(-5))

# x = 10 => p - q = - 5
MOI.add_constraint(model, terms, implication)

MOI.add_constraint(model, x, MOI.EqualTo(10))

MOI.add_constraint(model, p, MOI.GreaterThan(0))
MOI.add_constraint(model, p, MOI.LessThan(10))

MOI.optimize!(model)

@show MOI.get(model, MOI.VariablePrimal(), x)
@show MOI.get(model, MOI.VariablePrimal(), p)
@show MOI.get(model, MOI.VariablePrimal(), q)
