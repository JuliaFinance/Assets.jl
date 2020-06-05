module Assets

using Currencies, Instruments, FixedPointDecimals
using Instruments: currency, symbol
import Instruments: unit, code, name

export Cash, ListedEquity

"""
`Cash` is a financial instrument represented by a singleton type with its currency symbol and the number of digits in the minor units, typically 0, 2, or 3, as parameters.
"""
struct Cash{S, N} <: Instrument{S,Currency{S}}
    Cash(S::Symbol) = new{S,unit(S)}()
end
Cash(::Currency{S}) where {S} = Cash(S)

unit(::Cash{C,N}) where {C,N} = N
code(c::Cash) = code(currency(c))
name(c::Cash) = name(currency(c))

Base.show(io::IO, ::Cash{C}) where {C} = print(io, string(C))

function Instruments.Position(cash::Cash{C,N}, a) where {C,N}
    T = FixedDecimal{Int,N}
    Position{Cash{C,N},T}(cash,T(a))
end

"""
`ListedEquity` is a financial instrument represented by a singleton type with the exchange it is listed on, and its symbol (such as :MSFT)
"""
struct ListedEquity{E,S,C} <: Instrument{S,Currency{C}}
    ListedEquity(E::Symbol, S::Symbol, C::Symbol) = new{E,S,C}()
end

# Set up short names for all of the currencies (as instances of the Cash instruments)
# This is really done as a convenience

for (s,(ccy,u,c,n)) in Currencies.allpairs()
    @eval const $s = Cash($ccy)
end

end # module
