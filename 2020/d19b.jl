const BASE=0x1f300
atoP(s)=Char(parse(Int, s)+BASE) # ascii digit sequence to pictograph
mykey(n)=Char(n+BASE) # ∵ all my keys are pictographs

function readinput(file)
    blck = split(read(file, String), "\n\n")
    rul = Dict()
    for l in split(blck[1], '\n')
        rh,rt = split(l, ": ", limit=2)
        rnum = atoP(rh)
        fragments = []
        grp = occursin("|", rt)
        if grp push!(fragments, "««") end
        for frag in split(rt)
            if frag[1] == '"'
                push!(fragments, strip(frag, '"'))
            elseif frag[1] == '|'
                push!(fragments, "»|«")
            else
                push!(fragments, atoP(frag))
            end
        end
        if grp push!(fragments, "»»") end
        rul[rnum]=replace(join(fragments), r"«(.)»"=>s"\1")
    end
    msg = split(blck[2], '\n')
    return rul, msg
end

function grok!(rules)
    modified=true
    while modified
        modified=false
        for rn in keys(rules)
            newr = rules[rn]
            for qn in keys(rules)
                # it's faster to check only the used rules,
                # but I don't care.
                newr = replace(newr, qn=>rules[qn])
            end
            newr = replace(newr, r"«(\w+)»"=>s"\1")
            if rules[rn] != newr
                modified=true
                rules[rn] = newr
            end
        end
    end
end

function regexify(rule)
    Regex('^'*replace(replace(rule, "«"=>"(?:"), "»"=>")")*'$')
end

function main()
    rls,msgs = readinput("input19.txt")
    grok!(rls)
    rz = regexify(rls[mykey(0)])
    s = sum([occursin(rz, msg) for msg in msgs])
    println("Part 1: $s")

    rls,msgs = readinput("input19.txt")
    rls[mykey(8)]  = "«$(mykey(42))»+"
    rls[mykey(11)] = "($(mykey(42))(?1)?$(mykey(31)))"
    grok!(rls)
    rz = regexify(rls[mykey(0)])
    s = sum([occursin(rz, msg) for msg in msgs])
    println("Part 2: $s")
end
main()
