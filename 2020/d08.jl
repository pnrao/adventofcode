using BenchmarkTools

function simulate(code)
    acc = 0
    cpc = 1 # current program counter
    inf = false # infinite loop detected
    visited = falses(length(code))
    while true
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

rominstrs = @btime readlines("input08.txt").|>split.|>p->[p[1][1], parse(Int, p[2])]

a,c,i=@btime simulate(rominstrs)
println("Unmodified: acc=$a, cpc=$c, infinite-loop=$i")

global modpc=0
@btime for modpc in 1:length(rominstrs)
    if rominstrs[modpc][1]=='a'
        continue
    end
    rominstrs[modpc][1] = rominstrs[modpc][1]=='j' ? 'n' : 'j'
    global a,c,i=simulate(rominstrs)
    i==false && break
    rominstrs[modpc][1] = rominstrs[modpc][1]=='j' ? 'n' : 'j'
end
println("Mod@pc $modpc: acc=$a, cpc=$c, infinite-loop=$i")
