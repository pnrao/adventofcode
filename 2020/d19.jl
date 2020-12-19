atoi(s)=parse(Int, s)

function readinput(file)
    blck = split(read(file, String), "\n\n")
    # Rules
    rul = Dict{Int, Array}()
    for l in split(blck[1], '\n')
        rh,rt = split(l, ": ", limit=2)
        rnum = atoi(rh)
        rul[rnum] = []
        grp = occursin("|", rt)
        if grp push!(rul[rnum], "((") end
        for frag in split(rt)
            if frag[1] == '"'
                push!(rul[rnum], strip(frag, '"'))
            elseif frag[1] == '|'
                push!(rul[rnum], ")|(")
            else
                push!(rul[rnum], atoi(frag))
            end
        end
        if grp push!(rul[rnum], "))") end
    end
    # Messages
    msg = split(blck[2], '\n')
    return rul, msg
end

function lookup(rules, rfrag)
    if typeof(rfrag)<:Int
        return ["(", rules[rfrag], ")"]
    elseif typeof(rfrag)<:Array
        newlu = []
        for i in rfrag
            append!(newlu, lookup(rules, i))
        end
        return newlu
    else
        return rfrag
    end
end

function grok!(rules)
    modified=true
    while modified
        modified=false
        for rn in keys(rules)
            lookr = lookup(rules, rules[rn])
            if lookr != rules[rn]
                modified = true
                rules[rn] = lookr
            end
        end
    end
end

@views function printrules(rules)
    for k in sort(collect(keys(rules)))
        println(k,':', join(rules[k],'⋅'))
    end
end

function regexify(rule)
    str = rule
    oldlen = length(str)
    newlen = oldlen+1
    while newlen>oldlen
        oldlen=length(str)
        str = replace(str, r"\((\w+)\)"=>s"\1")
        newlen=length(str)
    end
    str='^'*str*'$'
    return Regex(str)
end

@views function restring(rules)
    newr = Dict{Int, Regex}()
    for n in keys(rules)
        newr[n] = regexify(join(rules[n]))
    end
    newr
end

function main()
    rls,msgs = readinput("input19.txt")
    #printrules(rls)
    grok!(rls)
    #printrules(rls)
    newrules = restring(rls)
    s = sum([occursin(newrules[0], msg) for msg in msgs])
    println("Part 1: $s")
    return
end
main()
