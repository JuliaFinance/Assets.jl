using DelimitedFiles, Tables

nasdaq_infile = joinpath("data","NASDAQ.txt")
nasdaq_outfile = joinpath("data","nasdaq.jl")

nasdaq_data = readdlm(nasdaq_infile,'\t','\n',header=true)
nasdaq_table = Tables.table(nasdaq_data[1])

println(nasdaq_table)

function genfile(io)
    for stock in Tables.rows(nasdaq_table)
        ticker = stock[1]
        println(io,"$(ticker) = ListedEquity{:Nasdaq,:$(ticker)}()")
    end
end

open(io -> genfile(io), nasdaq_outfile, "w")
