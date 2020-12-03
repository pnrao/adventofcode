F = readlines("input03.txt") # forest

function slide(rt, dn)
    colMax = length(F[1])
    rowMax = length(F)
    row,col=1,1
    tN = F[row][col]=='#' ? 1 : 0
    while row<rowMax
        col+=rt
        row+=dn
        if col>colMax
            col -= colMax
        end
        if F[row][col] == '#'
            tN += 1
        end
    end
    tN
end

println(slide(3, 1))

println(slide(1, 1)*
        slide(3, 1)*
        slide(5, 1)*
        slide(7, 1)*
        slide(1, 2)
)
