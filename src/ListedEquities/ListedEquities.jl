module ListedEquities

using ..Instruments
import Instruments: Position

export ListedEquity, Nasdaq

struct ListedEquity{E,S} <: AbstractInstrument{S,Currency{:USD}} end
ListedEquity(exch::Symbol, sym::Symbol) = ListedEquity{exch,sym}()

include("Nasdaq.jl"); using .Nasdaq

end