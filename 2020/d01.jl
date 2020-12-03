nums = Array{Int,1}()
for l in readlines("input01.txt")
	append!(nums, parse(Int, l))
end

println("Raw loops")
@time for i in 1:length(nums)-1, j in i+1:length(nums)
	if (nums[i] + nums[j]) == 2020
		println(nums[i], " * ", nums[j], " = ", nums[i]*nums[j])
	end
end

@time for i in 1:length(nums)-2, j in i+1:length(nums)-1, k in j+1:length(nums)
	if (nums[i] + nums[j] + nums[k]) == 2020
		println(nums[i], " * ", nums[j], " * ", nums[k], " = ", nums[i]*nums[j]*nums[k])
	end
end

using IterTools
println("\nIterTools")
@time for s in subsets(nums, 2)
	if s[1]+s[2] == 2020
		println(s[1], '*', s[2],'=',s[1]*s[2])
	end
end

@time for s in subsets(nums, 3)
	if s[1]+s[2]+s[3] == 2020
		println(s[1], '*', s[2], '*', s[3],'=',s[1]*s[2])
	end
end
