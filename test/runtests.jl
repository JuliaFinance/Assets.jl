using Assets, Currencies, Instruments, FixedPointDecimals

using Assets: USD, EUR, JPY, JOD, CNY
using Currencies: currency, symbol, unit, code, name

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
        ct = Base.eval(Assets, sym)
        @test ct == cash(ccy)
        @test ct == cash(sym)
        @test currency(ct) == typeof(ccy)
        @test symbol(ct) == symbol(ccy)
        @test unit(ct) == unit(ccy)
        @test code(ct) == code(ccy)
        @test name(ct) == name(ccy)

        position = Position{ct}(1)
        @test currency(position) == currency(ct)
        @test currency(1ct) == typeof(ccy)
        @test 1ct == position
        @test ct * 1 == position
        @test 1ct + 1ct == Position{ct}(2)
        @test 1ct - 1ct == Position{ct}(0)
        @test 20ct / 4ct == FixedDecimal{Int,unit(ct)}(5)
        @test 20ct / 4 == Position{ct}(5)
    end
end
