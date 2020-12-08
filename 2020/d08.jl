function simulate(code)
    acc = 0
    cpc = 1 # current pc
    inf = false # infinite loop detected
    visited = falses(length(code))
    while true
        op = code[cpc] # only for viewing in the debugger
        if visited[cpc] == false
            visited[cpc]=true
        else
            inf = true
            break
        end
        if code[cpc][1] == 'a'
            acc+=code[cpc][2]
            cpc+=1
        elseif code[cpc][1] == 'j'
            cpc+=code[cpc][2]
        else
            cpc+=1
        end
        if cpc<1 || cpc>length(code)
            break
        end
    end
    return acc,cpc,inf
end

rominstrs = readlines("input08.txt").|>split.|>p->[p[1][1], parse(Int, p[2])]

for modpc in 0:length(rominstrs)
    myinstrs = deepcopy(rominstrs)
    if modpc>0
        myinstrs[modpc][1]=='a' && continue
        myinstrs[modpc][1] = myinstrs[modpc][1]=='j' ? 'n' : 'j'
    end
    local a,c,i=simulate(myinstrs)
    (i==false||modpc==0) && println("Mod@pc $modpc: acc=$a, cpc=$c, inf=$i")
end
