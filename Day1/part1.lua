--[[
	Day 1 part 1
	
	In a sequence of text lines, there are some amount of numbers (as few as 0) embedded in text.
		i.e. "3eightnldtmmmmknkzs2fiveg"
	The challenge is to extract the first and last numbers of each line, compose them into a single
	number (above example becomes 32).
--]]

if(#arg < 1) then
	print("luajit part1.lua <file of strings>")
	return
end

function ParseLine(str)
	local first, last
	
	local pos = 0
	while(pos ~= nil) do
		local a,b = str:find("%d", pos + 1)	-- Get digit
		if(a == nil) then break end
		--print(a,b)
		pos = a
		
		if(first == nil) then first = str:sub(a,a) end
		last = str:sub(a,a)
	end
	
	if(first == nil) then
		return 0
	else
		return (tonumber(first)*10 + tonumber(last))
	end
end

function ParseFile(path)
	local f = io.open(path, "r")
	local acc = 0
	for l in f:lines() do
		acc = acc + ParseLine(l)
	end
	
	return acc
end

print("Answer: " .. ParseFile(arg[1]))