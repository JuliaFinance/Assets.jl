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

export Cash, cash, @cash_str, @cash
export Stock, stock, @stock_str, @stock

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
    :( cash(Symbol($(esc(uppercase(str))))) )
end

macro cash(syms)
    args = syms isa Expr ? syms.args : [syms]
    for nam in args
        lownam = Symbol(lowercase(string(nam)))
        Base.eval(__module__, :( const $nam = cash($(QuoteNode(nam))) ) )
        Base.eval(__module__, :( const $lownam = $nam() ) )
    end
end

function Position{S}(amt) where {C,N,S<:Cash{C,N}}
    T = FixedDecimal{Int,N}
    Position{S,T}(T(amt))
end

"""
`Stock` is an implementation of a simple `Instrument` represented by a singleton type
with a stock symbol and currency, e.g. `Stock{:MSFT,ccy"USD"}`.
The currency can be omitted and it will default to USD, e.g. `Stock(:MSFT)`.
"""
struct Stock{S,C} <: Instrument{S,Currency}
    Stock(sym::Symbol, ccy::Type{<:Currency}=Currency(:USD)) = new{sym,currency(ccy)}()
    Stock(sym::Symbol, pos::Type{<:Cash}) = new{sym,currency(pos)}()
end
stock(sym::Symbol, ccy::Type{<:Currency}=Currency(:USD)) = typeof(Stock(sym, currency(ccy)))
stock(sym::Symbol, pos::Type{<:Cash}) = typeof(Stock(sym, currency(pos)))

symbol(::Type{Stock{S,C}}) where {S,C} = S
currency(::Type{Stock{S,C}}) where {S,C} = C

macro stock_str(str, ccy="USD")
    :( stock(Symbol($(esc(str))), $(esc(currency(Symbol(uppercase(ccy))))) ) )
end

macro stock(syms)
    args = syms isa Expr ? syms.args : [syms]
    for nam in args
        lownam = Symbol(lowercase(string(nam)))
        Base.eval(__module__, :( const $nam = stock($(QuoteNode(nam))) ) )
        Base.eval(__module__, :( const $lownam = $nam() ) )
    end
end

function Position{S}(amt) where {S<:Stock}
    T = FixedDecimal{Int,4}
    Position{S,T}(T(a))
end

end # module Assets
