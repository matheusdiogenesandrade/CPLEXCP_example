using CPLEXCP
using MathOptInterface
using ConstraintProgrammingExtensions

const MOI = MathOptInterface
const CP = ConstraintProgrammingExtensions

model = CPLEXCP.Optimizer()

x = first(MOI.add_constrained_variable(model, MOI.Interval(0.0, 10.0)))
p = first(MOI.add_constrained_variable(model, MOI.Interval(0.0, 10.0)))
q = first(MOI.add_constrained_variable(model, MOI.Interval(0.0, 10.0)))

# if x = 10 then p + 5 = q

# p - q
affine::MOI.ScalarAffineFunction{Float64} = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm{Float64}.([1, -1], [p, q]), 0.0)

# [x, p - q]
terms::MOI.VectorAffineFunction{Float64} = MOI.Utilities.operate(vcat, Float64, x, affine)

# [10, - 5]
implication::CP.Implication{MOI.EqualTo{Float64}, MOI.EqualTo{Float64}} = CP.Implication(MOI.EqualTo(10.0), MOI.EqualTo(-5.0))

# x = 10 => p - q = - 5
MOI.add_constraint(model, terms, implication)

MOI.add_constraint(model, x, MOI.EqualTo(10))

MOI.optimize!(model)

@show MOI.get(model, MOI.VariablePrimal(), x)
@show MOI.get(model, MOI.VariablePrimal(), p)
@show MOI.get(model, MOI.VariablePrimal(), q)
