module ListedEquities

using ..Instruments
import Instruments: Position

export ListedEquity, Nasdaq

struct ListedEquity{E,S,C} <: AbstractInstrument{S,Currency{C}} end
ListedEquity(E::Symbol, S::Symbol, C::Symbol) = ListedEquity{E,S,C}()

include("Nasdaq.jl"); using .Nasdaq

end