--[[
	Day 1 part 2
	
	In a sequence of text lines, there are some amount of numbers (as few as 0) embedded in text.
		i.e. "3eightnldtmmmmknkzs2fiveg"
	The challenge is to extract the first and last numbers of each line, compose them into a single
	number (above example becomes 32).
	
	The challenge now expands to include numbers spelled out, like "eight", "nine", etc. that all
	
--]]

if(#arg < 1) then
	print("luajit part2.lua <file of strings>")
	return
end

function ParseLine(str, pos)
	local nums = {}
	local numWords = {"one", "two", "three", "four", "five", "six", "seven", "eight", "nine"}
	local pos = 1
	while(pos <= #str) do
		if(str:sub(pos,pos):find("%d") ~= nil) then
			nums[#nums+1] = tonumber(str:sub(pos,pos))
			pos = pos + 1
		else
			local bMatch = false
			for k,v in pairs(numWords) do
				if(str:sub(pos, pos+#v-1) == v) then
					nums[#nums+1] = k -- handy!
					pos = pos + #v - 1
					bMatch = true
					break
				end
			end
			if(not bMatch) then pos = pos + 1 end
		end
	end
	
	if(#nums == 0) then
		return 0
	elseif(#nums == 1) then
		return ((nums[1]*10) + nums[1])
	else
		return ((nums[1]*10) + nums[#nums])
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