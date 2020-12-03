function isValid1(lowl, upl, ch, str)
	s = count(c->c==ch, str)
	lowl <= s <= upl
end

function isValid2(lowl, upl, ch, str)
	(str[lowl] == ch) ⊻ (str[upl] == ch)
end

s1=0
s2=0
for l in readlines("input02.txt")
	m = match(r"(\d+)-(\d+) (.): (.*)", l)
	if isValid1(parse(Int,m[1]),
			parse(Int,m[2]),
			m[3][1], # odd way to convert a string to a char
			m[4])
		global s1+=1
	end
	if isValid2(parse(Int,m[1]),
		parse(Int,m[2]),
		m[3][1],
		m[4])
	global s2+=1
end
end
println("Valid in rule 1 = ",s1)
println("Valid in rule 2 = ",s2)
