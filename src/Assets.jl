"""
Assets

This package provides various types to represent certain financial assets:

    `Cash`: which is based on a particular currency type, along with the minor unit
    `ListedEquity`: which represents some form of equity such as a stock, that is listed
                    on a particular exchange.

It also provides methods for Position of Cash (such as for a bank account).

See README.md for the full documentation

Copyright 2019-2020, Eric Forgy, Scott P. Jones and other contributors

Licensed under MIT License, see LICENSE.md
"""
module Assets

using Currencies, Instruments, FixedPointDecimals
import Instruments: Position, currency, symbol, unit, code, name

export Cash, ListedEquity

"""
`Cash` is a financial instrument represented by a singleton type with its currency symbol and the number of digits in the minor units, typically 0, 2, or 3, as parameters.
"""
struct Cash{S, N} <: Instrument{S,Currency{S}} end
Cash(S::Symbol) = Cash{S,unit(S)}()
Cash(::Currency{S}) where {S} = Cash(S)

unit(::Cash{C,N}) where {C,N} = N
symbol(::Cash{C}) where {C} = C
currency(::Cash{C}) where {C} = currency(C)
code(::Cash{C}) where {C} = code(C)
name(::Cash{C}) where {C} = name(C)

Base.show(io::IO, ::Cash{C}) where {C} = print(io, string(C))

function Position{Cash{C,N}}(a) where {C,N}
    T = FixedDecimal{Int,N}
    Position{Cash{C,N},T}(T(a))
end

"""
`ListedEquity` is a financial instrument represented by a singleton type with the exchange it is listed on, and its symbol (such as :MSFT)
"""
struct ListedEquity{E,C,S} <: Instrument{C,S}
    ListedEquity(E, C, S::Symbol) = new{E,C,S}()
end
currency(::ListedEquity{E,S,C}) where {E,S,C} = currency(C)
symbol(::ListedEquity{E,S}) where {E,S} = S

# Set up short names for all of the currencies (as instances of the Cash instruments)
# This is really done as a convenience

for (s,(ccy,u,c,n)) in Currencies.allpairs()
    @eval const $s = Cash($ccy)
end

end # module
