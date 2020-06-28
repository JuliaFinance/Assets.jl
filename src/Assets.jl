"""
Assets

This package provides implementations of `Instrument` for various financial assets:

- `Cash`: which is based on a particular currency type, along with the minor unit.
- `Stock`: which represents a general common stock.

It also provides a specialized `Position` for `Cash that uses the currency's minor unit.

See README.md for the full documentation

Copyright 2019-2020, Eric Forgy, Scott P. Jones and other contributors

Licensed under MIT License, see LICENSE.md
"""
module Assets

using Currencies, FixedPointDecimals, Instruments
import Currencies: symbol, currency, unit, code, name

export Cash, Stock, cash, stock, @cash_str, @stock_str

"""
`Cash` is an implementation of `Instrument` represented by a singleton type,
with its currency symbol and the number of digits in the minor units,
typically 0, 2, or 3, as parameters.
"""
struct Cash{S, N} <: Instrument{S,Currency{S}}
    function Cash{S,N}() where {S,N}
        unit(S) === N || error("Currency minor unit does not match.")
        new{S,N}()
    end
end

# Functions to return the types, not instances, with the constructors
cash(S::Symbol) = Cash{S,unit(S)}
cash(::Type{Currency{S}}) where {S} = cash(S)

# Handle using the type instead of an instance for Cash
symbol(::Type{<:Cash{S}}) where {S} = S
unit(::Type{Cash{S,N}}) where {S,N} = N
code(::Type{<:Cash{S}}) where {S} = code(S)
name(::Type{<:Cash{S}}) where {S} = name(S)
currency(::Type{<:Cash{S}}) where {S} = currency(S)

macro cash_str(str)
    :( cash(Symbol($(esc(str)))) )
end

function Position{Cash{C,N}}(a) where {C,N}
    T = FixedDecimal{Int,N}
    Position{Cash{C,N},T}(T(a))
end

"""
`Stock` is an implementation of a simple `Instrument` represented by a singleton type
with a stock symbol and currency, e.g. `Stock{:MSFT,:USD}`.
The currency can be omitted and it will default to USD, e.g. `Stock(:MSFT)`.
"""
struct Stock{S,C} <: Instrument{S,C}
    Stock(sym::Symbol, ccy::Symbol=:USD) = new{sym,currency(ccy)}()
    Stock(sym::Symbol, ::Type{T}) where {T<:Currency} = new{sym,T}()
end

"""
Return the singleton type for a particular general stock, given it's symbol.
Defaults to USD for the currency
"""
stock(sym::Symbol, ccy::Symbol=:USD) = Stock{sym,currency(ccy)}
stock(sym::Symbol, ::Type{T}) where {T<:Currency} = Stock{sym,T}

macro stock_str(str,ccy="USD")
    :( stock(Symbol($(esc(str))),Symbol($(esc(ccy)))) )
end

# Set up short names for all of the currencies (as Cash instrument types).
# This is really done as a convenience
for (s,(ccy,u,c,n)) in Currencies.allpairs()
    @eval const $s = cash($ccy)
end

end # module Assets
