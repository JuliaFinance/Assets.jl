module ListedEquities

using ..Instruments
import Instruments: Position

export ListedEquity, Nasdaq

struct ListedEquity{E,S} <: AbstractInstrument{S,Currency{:USD}} end

# function Position(eq::ListedEquity{E,S}, a::A) where {E,S,A}
#     Position{ListedEquity{E,S},A}(eq,a)
# end

include("Nasdaq.jl"); using .Nasdaq

end