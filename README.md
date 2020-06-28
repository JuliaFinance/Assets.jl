# Assets

[pkg-url]: https://github.com/JuliaFinance/Assets.jl.git

[travis-url]:   https://travis-ci.org/JuliaFinance/Assets.jl
[travis-s-img]: https://travis-ci.org/JuliaFinance/Assets.jl.svg
[travis-m-img]: https://travis-ci.org/JuliaFinance/Assets.jl.svg?branch=master

[![][travis-s-img]][travis-url]  [![][travis-m-img]][travis-url] 

This package provides concrete implementations of `Instrument` for various financial assets:

- `Cash`: which is based on a particular currency type, along with the minor unit.
- `Stock`: which represents a general common stock.

It also provides a specialized `Position` for `Cash` that uses the currency's minor unit.

## `Cash{S,N} <: Instrument{S,currency(S))}`

When a currency is thought of as a financial instrument (as opposed to a mere label), we choose to refer to it as "Cash" as it would appear in a balance sheet. This package implements the `Cash` instrument with parameter `S` being the 3-character ISO 4217 alpha label of the currency as a `Symbol` and an integer `N` representing the number of decimal places in the currency (typically 0, 2 or 3).

Short constants are set up, matching the ISO 4217 names, so that you can use `USD` instead of `Cash{:USD,2}()`.

For example:

```julia
julia> import Assets: JPY, USD, JOD

julia> typeof(JPY)
Cash{:JPY,0}

julia> typeof(USD)
Cash{:USD,2}

julia> typeof(JOD)
Cash{:JOD,3}
```

Although `Cash` is a singleton type, other financial instruments may contain various fields needed for cashflow projections, pricing, etc.

## `Stock{S,C} <: Instrument{S,C}`

`Stock` is an implementation of a simple `Instrument` representing common stock issued by a company. It is implemented as a singleton type with a stock symbol and currency, e.g. `Stock{:MSFT,:USD}`. The currency can be omitted and it will default to `USD`, e.g. `Stock(:MSFT)`.

## `Position{I<:Instrument, A}`

A `Position` represents an amount of ownership of a financial instrument. For example, Microsoft stock

```julia
const MSFT = Stock(:MSFT,:USD)
```
is a financial instrument. A position could be 1,000 shares of `MSFT` and can be represented in one of two ways:

```julia
julia> MSFT(1000)
1000MSFT
```

or 

```julia
julia> 1000MSFT
1000MSFT
```

Similarly, cash positions can be constructed as

```julia
julia> USD(1000)
1000.00USD
```

and

```julia
julia> 1000USD
1000.00USD
```

Note that since the minor unit of `USD` is `2`, a `USD` cash position has 2 decimal places.

```julia
julia> typeof(1000USD)
Position{Cash{:USD,2},FixedDecimal{Int64,2}}
```

Simple algebraic operations can be performed on positions of an `Instrument`:

```julia
julia> 10USD+20USD
30.00USD

julia> 1000MSFT+20MSFT
2000MSFT

julia> 5*20USD
100.00USD

julia> 100USD/5
20.00USD

julia> 100USD/5USD
FixedDecimal{Int64,2}(20.00)

julia> 100JPY/5JPY
FixedDecimal{Int64,0}(20)

julia> 100USD+100JPY
ERROR: Can't add Positions of different Instruments USD, JPY
```

Algebraic operations on positions require the positions to be of the same instrument. 

For more information, see

- [Currencies.jl](https://github.com/JuliaFinance/Currencies.jl.git)
- [Ledgers.jl](https://github.com/JuliaFinance/Ledgers.jl.git)