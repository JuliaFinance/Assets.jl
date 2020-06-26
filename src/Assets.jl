"""
Assets

This package provides implementations of `Instrument` for various financial assets:

- `Cash`: which is based on a particular currency type, along with the minor unit.
- `Stock`: which represents a general common stock.
- `ListedStock`: which represents a common stock listed on an exchange.

It also provides a specialized `Position` for `Cash` that uses the currency's minor unit.

See README.md for the full documentation

Copyright 2019-2020, Eric Forgy, Scott P. Jones and other contributors

Licensed under MIT License, see LICENSE.md
"""
module Assets

using Currencies, FixedPointDecimals
using Instruments: Instrument; import Instruments: Position, symbol, currency, unit, code, name

export Cash, ListedStock

"""
`Cash` is an implementation of `Instrument` represented by a singleton type with its currency symbol and the number of digits in the minor units, typically 0, 2, or 3, as parameters.
"""
struct Cash{S, N} <: Instrument{S,Currency{S}} end
Cash(S::Symbol) = Cash{S,unit(S)}()
Cash(::Type{Currency{S}}) where {S} = Cash(S)
Cash(::Currency{S}) where {S} = Cash(S)

unit(::Cash{S,N}) where {S,N} = N
code(::Cash{S}) where {S} = code(S)
name(::Cash{S}) where {S} = name(S)

function Position{Cash{C,N}}(a) where {C,N}
    T = FixedDecimal{Int,N}
    Position{Cash{C,N},T}(T(a))
end

"""
`Stock` is an implementation of a simple `Instrument` represented by a singleton type with a stock symbol and currency, e.g. `Stock{:MSFT,:USD}`. The currency can be omitted and it will default to USD, e.g. `Stock(:MSFT)`.
"""
struct Stock{S,C} <: Instrument{S,Currency{C}}
    Stock(S::Symbol) = new{S,:USD}()
    Stock(S::Symbol,C::Symbol) = new{S,C}()
end

"""
`ListedStock` is an implementation of `Instrument` represented by a singleton type with the exchange it's listed, its symbol and its currency, e.g. `ListedStock{:NASDAQ,:MSFT,:USD}`. The currency can be omitted and it will default to USD, e.g. `ListedStock(:NASDAQ,:MSFT)`.
"""
struct ListedStock{E,S,C} <: Instrument{S,Currency{C}}
    ListedStock(E::Symbol, S::Symbol) = new{E,S,:USD}()
    ListedStock(E::Symbol, S::Symbol, C::Symbol) = new{E,S,C}()
end

# Set up short names for all of the currencies (as instances of the Cash instruments). This is really done as a convenience
for (s,(ccy,u,c,n)) in Currencies.allpairs()
    @eval const $s = Cash($ccy)
end

end # module
