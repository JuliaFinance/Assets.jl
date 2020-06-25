using Assets; using Assets: USD, EUR, JPY, JOD, CNY
using Currencies; using Currencies: currency, symbol, unit, code, name
using Instruments, FixedPointDecimals

using Test

# Check that some basic currencies have been loaded correctly
# (this part should really be in Currencies.jl, not here)
currencies = ((USD, :USD, 2, 840, "US Dollar"),
              (EUR, :EUR, 2, 978, "Euro"),
              (JPY, :JPY, 0, 392, "Yen"),
              (JOD, :JOD, 3, 400, "Jordanian Dinar"),
              (CNY, :CNY, 2, 156, "Yuan Renminbi"))

@testset "Basic currencies" begin
    for (ccy, s, u, c, n) in currencies
        @test symbol(ccy) == s
        @test unit(ccy) == u
        @test name(ccy) == n
        @test code(ccy) == c
    end
end
    
@testset "All currencies" begin
    for sym in Currencies.allsymbols()
        ccy = Currency{sym}()
        cash = Base.eval(Assets, sym)
        @test cash == Cash(ccy)
        @test cash == Cash(symbol(ccy))
        @test currency(cash) == ccy
        @test symbol(cash) == symbol(ccy)
        @test unit(cash) == unit(ccy)
        @test code(cash) == code(ccy)
        @test name(cash) == name(ccy)

        CT = typeof(cash)
        position = Position{CT}(1)
        @test currency(position) == currency(cash)
        @test currency(1cash) == ccy
        @test 1cash == position
        @test cash * 1 == position
        @test 1cash + 1cash == Position{CT}(2)
        @test 1cash - 1cash == Position{CT}(0)
        @test 20cash / 4cash == FixedDecimal{Int,unit(cash)}(5)
        @test 20cash / 4 == Position{CT}(5)
    end
end
