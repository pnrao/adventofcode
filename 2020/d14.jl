function part1()
    msk_or =0
    msk_and=0
    mem=Dict{Int,Int}()
    function setmask(mstr)
        msk_and = parse(Int, replace(mstr, "X"=>"1"), base=2)
        msk_or  = parse(Int, replace(mstr, "X"=>"0"), base=2)
    end
    function setval(addr, value)
        mem[addr] = (value & msk_and) | msk_or
    end

    for line in eachline("input14.txt")
        if startswith(line, "mask")
            s = split(line)
            setmask(s[3])
        else
            m=match(r"mem\[(?<adr>\d+)\] = (?<val>\d+)", line)
            adr = parse(Int, m[:adr])
            val = parse(Int, m[:val])
            setval(adr, val)
        end
    end
    @info "Part 1: $(sum(values(mem)))"
end
part1()

function part2()
    msk_xs  = []
    msk_and = 0
    msk_or  = 0
    mem=Dict{Int,Int}()
    function setmask(m)
        msk_and = parse(UInt, replace(replace(m,r"0|1"=>"1"), "X"=>"0"), base=2)
        msk_or  = parse(UInt,         replace(m,r"0|X"=>"0"),            base=2)
        xaddrs=[m]
        #@info "Part 2 input:" xaddrs[1] msk_and msk_or
        while 'X' ∈ xaddrs[1]
            x = popfirst!(xaddrs)
            push!(xaddrs, replace(x, 'X'=>'0', count=1))
            push!(xaddrs, replace(x, 'X'=>'1', count=1))
        end
        msk_xs=[parse(UInt, addr, base=2) for addr in xaddrs]
        #@info "Part 2 addrs:" msk_xs
    end
    function setval(adr, val)
        for x ∈ msk_xs
            mem[(adr&msk_and)|msk_or|x] = val
        end
    end

    for line in eachline("input14.txt")
        if startswith(line, "mask")
            s = split(line)
            setmask(s[3])
        else
            m=match(r"mem\[(?<adr>\d+)\] = (?<val>\d+)", line)
            adr = parse(Int, m[:adr])
            val = parse(Int, m[:val])
            setval(adr, val)
        end
    end
    @info "Part 2: $(sum(values(mem)))"
end
part2()
