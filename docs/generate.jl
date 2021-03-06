# generate examples
import Literate

# TODO: Remove items from `SKIPFILE` as soon as they run on the latest
# stable `Optim` (or other dependency)
#ONLYSTATIC = ["optim_linesearch.jl", "optim_initialstep.jl"]
ONLYSTATIC = []

EXAMPLEDIR = joinpath(@__DIR__, "src", "examples")
GENERATEDDIR = joinpath(@__DIR__, "src", "examples", "generated")
myfilter(str) = endswith(str, ".jl")
for example in filter!(myfilter, readdir(EXAMPLEDIR))
    input = abspath(joinpath(EXAMPLEDIR, example))
    script = Literate.script(input, GENERATEDDIR)
    code = strip(read(script, String))
    mdpost(str) = replace(str, "@__CODE__" => code)
    Literate.markdown(input, GENERATEDDIR, postprocess = mdpost,
                      documenter = !(example in ONLYSTATIC))
    Literate.notebook(input, GENERATEDDIR, execute = !(example in ONLYSTATIC))
end
