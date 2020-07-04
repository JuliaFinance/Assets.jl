using Assets, Currencies, Instruments, FixedPointDecimals
# using Currencies: currency, symbol, unit, code, name

@cash USD, EUR, JPY, JOD, CNY

using Test

# Check that some basic currencies have been loaded correctly
# (this part should really be in Currencies.jl, not here)
currencies = ((USD, :USD, 2, 840, "US Dollar"),
              (EUR, :EUR, 2, 978, "Euro"),
              (JPY, :JPY, 0, 392, "Yen"),
              (JOD, :JOD, 3, 400, "Jordanian Dinar"),
              (CNY, :CNY, 2, 156, "Yuan Renminbi"))

@testset "Basic currencies" begin
    for (pos, s, u, c, n) in currencies
        ccy = currency(pos(1))
        @test symbol(ccy) == s
        @test unit(ccy) == u
        @test name(ccy) == n
        @test code(ccy) == c
    end
end
    
@testset "All currencies" begin
    for sym in Currencies.allsymbols()
        ccy = Currency{sym}
        ct = cash(sym)
        @test ct == cash(ccy)
        @test ct == cash(sym)
        @test currency(ct) == ccy
        @test symbol(ct) == symbol(ccy)
        @test unit(ct) == unit(ccy)
        @test code(ct) == code(ccy)
        @test name(ct) == name(ccy)

        pos = Position(ct,1)
        pt = typeof(pos)
        @test currency(pos) == currency(ct)
        @test currency(1pt) == ccy
        @test 1pt == pos
        @test pos * 1 == pos
        @test 1pos + 1pos == Position(ct,2)
        @test 1pos - 1pos == Position(ct,0)
        @test 20pos / 4pos == FixedDecimal{Int,unit(ct)}(5)
        @test 20pos / 4 == Position(ct,5)
    end
end
