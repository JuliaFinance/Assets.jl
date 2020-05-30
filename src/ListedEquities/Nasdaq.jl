module Nasdaq

import ..ListedEquities: ListedEquity
import ...HTTP, ...JSON3

function download(;port=8000,force=false)
    jsonfile = joinpath(@__DIR__,"nasdaq.json")
    if isfile(jsonfile) && force
        response = JSON3.read(read(jsonfile, String))
    else
        response = JSON3.read(HTTP.get("http://localhost:$(port)/api/nasdaq/list").body)
        open(io -> print(io,JSON3.write(response)), jsonfile, "w")
    end
    for stock in response
        s = stock["Symbol"]
        d = stock["Description"]
        @eval Nasdaq begin
            $(Symbol(s)) = ListedEquity{:NASDAQ,Symbol($s)}()
            _nasdaq_data[Symbol($s)] = ($(Symbol(s)),$d)
        end
    end
end
const _nasdaq_data = Dict{Symbol,Tuple{ListedEquity,String}}()

allsymbols() = keys(_nasdaq_data)
allpairs() = pairs(_nasdaq_data)

end