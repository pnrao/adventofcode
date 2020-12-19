atoi(s)=parse(Int, s)

function readinput(file)
    blck = split(read(file, String), "\n\n")
    rul = Dict()
    for l in split(blck[1], '\n')
        rh,rt = split(l, ": ", limit=2)
        rnum = atoi(rh)
        rul[rnum] = []
        grp = occursin("|", rt)
        if grp push!(rul[rnum], "(?:(?:") end
        for frag in split(rt)
            if frag[1] == '"'
                push!(rul[rnum], strip(frag, '"'))
            elseif frag[1] == '|'
                push!(rul[rnum], ")|(?:")
            else
                push!(rul[rnum], atoi(frag))
            end
        end
        if grp push!(rul[rnum], "))") end
    end
    msg = split(blck[2], '\n')
    return rul, msg
end

function lookup(rules, rfrag)
    if typeof(rfrag)<:Int
        newrl = rules[rfrag]
        #@info typeof(newrl) newrl
        if typeof(newrl)<:Char
            return String(newrl)
        else
            if occursin("|", join(newrl))
                return ["(?:", newrl, ")"]
            else
                return newrl
            end
        end
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
    while newlen!=oldlen
        oldlen=length(str)
        str = replace(str, r"\(\?:(\w+)\)"=>s"\1")
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
    grok!(rls)
    regexrules = restring(rls)
    s = sum([occursin(regexrules[0], msg) for msg in msgs])
    println("Part 1: $s")
    rls,msgs = readinput("input19.txt")
    rls[8]  = ["(?:(?:", 42,")+)"]
    rls[11] = ["(?:",
    "(?:(?:", 42, "{1})(?:", 31, "{1}))|",
    "(?:(?:", 42, "{2})(?:", 31, "{2}))|",
    "(?:(?:", 42, "{3})(?:", 31, "{3}))|",
    "(?:(?:", 42, "{4})(?:", 31, "{4}))|",
#    "(?:(?:", 42, "{5})(?:", 31, "{5}))|",
#    "(?:(?:", 42, "{6})(?:", 31, "{6}))|",
#    "(?:(?:", 42, "{7})(?:", 31, "{7}))|",
#    "(?:(?:", 42, "{8})(?:", 31, "{8}))|",
#    "(?:(?:", 42, "{9})(?:", 31, "{9}))|",
    ")"]
    grok!(rls)
    regexrules = restring(rls)
    s = sum([occursin(regexrules[0], msg) for msg in msgs])
    println("Part 2: $s")
    return
end
main()
