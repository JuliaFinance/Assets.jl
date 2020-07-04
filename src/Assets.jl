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

export Position, Currency, Cash, cash, @cash, unit, code, name
export Stock, stock, @stock

"`Cash` is an implementation of `Instrument` represented by a singleton type, with its currency symbol and the number of digits in the minor units, typically 0, 2, or 3, as parameters."
struct Cash{S, N} <: Instrument{S,Currency{S}}
    function Cash{S,N}() where {S,N}
        unit(S) === N || error("Currency minor unit does not match.")
        new{S,N}()
    end
end

function Instruments.Position(::Type{I},amt) where {S,N,I<:Cash{S,N}}
    T = FixedDecimal{Int,N}
    Position{I,T}(T(amt))
end

"Return a cash instrument type."
function cash end

cash(S::Symbol) = Cash{S,unit(S)}

cash(::Type{Currency{S}}) where {S} = cash(S)

macro cash(syms)
    args = syms isa Expr ? syms.args : [syms]
    for nam in args
        @eval __module__ const $nam = Assets.$nam
    end
end

Currencies.unit(::Type{Cash{S,N}}) where {S,N} = N

Currencies.code(::Type{C}) where {S,C<:Cash{S}} = code(S)

Currencies.name(::Type{C}) where {S,C<:Cash{S}} = name(S)

"""`Stock` is an implementation of a simple `Instrument` represented by a singleton type with a stock symbol and currency, e.g. `Stock{:MSFT,ccy"USD"}`. The currency can be omitted and it will default to USD, e.g. `Stock(:MSFT)`."""
struct Stock{S,C} <: Instrument{S,C} end

function Instruments.Position(::Type{I},amt) where {I<:Stock}
    Position{I,Int}(amt)
end

Stock(S::Symbol, C::Type{<:Currency}=Currency{:USD}) = Stock{S,C}()

stock(S::Symbol, C::Type{<:Currency}=Currency{:USD}) = Stock{S,C}

macro stock(syms)
    args = syms isa Expr ? syms.args : [syms]
    for nam in args
        @eval __module__ const $nam = typeof(Position(Stock{$(QuoteNode(nam)),Currency{:USD}},0))
    end
end

# Contruct cash position types for convenience.
for (s,(ccy,u,c,n)) in Currencies.allpairs()
    @eval const $s = typeof(Position($(cash(ccy)),0))
end

end # module Assets
