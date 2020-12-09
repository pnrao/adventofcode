chkN = 25 # size of last N numbers to check
ns = Array{Int,1}()
n = 0
valid = false
for l in readlines("input09.txt")
    global n=parse(Int,l)
    if length(ns) < chkN
        append!(ns,n)
        continue
    end
    global valid=false
    nslen = length(ns)
    for i ∈ nslen-chkN+1:nslen-1, j ∈ i+1:nslen
        if ns[i]+ns[j]==n
            global valid=true
            break
        end
    end
    !valid && break
    append!(ns,n)
end
if !valid
    println("The first invalid number is $n")
end

for size∈2:length(ns), strt∈1:length(ns)-size+1
    if sum(ns[strt:strt+size-1]) == n
        weakness = max(ns[strt:strt+size-1]...)+min(ns[strt:strt+size-1]...)
        println("Encryption weakness is $weakness")
        break
    end
end
