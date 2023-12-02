if(#arg < 1) then
	print("luajit part2.lua <input file>")
	return
end

local cubes = {
	red = 12,
	green = 13,
	blue = 14
}

function ParseLine(str)
	local gameNum = tonumber(str:match("Game (%d+):"))
	local formatStr = str:sub(str:find(":")+2)	-- Get everything after the colon (the rectum string if you will)
	-- Remove commas, tokenize by spaces and semicolons

	local maxima = {red = 0, green = 0, blue = 0}
	local curCubes = {red = 0, green = 0, blue = 0}
	local num
	
	-- Resets state and evaluates new maxima
	function evaluate()
		for k,v in pairs(curCubes) do
			if(curCubes[k] > maxima[k]) then maxima[k] = curCubes[k] end
		end
		curCubes = {red = 0, green = 0, blue = 0}
	end
	
	for curTok in formatStr:gsub(",", ""):gmatch("[^%s]+") do
		-- In-situ parsing; rock back and forth between a number and a color, semicolon or EOL triggers evaluation
		if(not num) then
			num = tonumber(curTok)
		else
			local trimTok = curTok:gsub(";", "")
			curCubes[trimTok] = num
			num = nil
			
			if(#curTok > #trimTok) then evaluate() end
		end
	end
	
	evaluate()
	
	return maxima.red * maxima.green * maxima.blue
end

function ParseFile(path)
	local acc = 0
	for l in io.lines(path) do
		acc = acc + ParseLine(l)
	end
	
	return acc
end

print(ParseFile(arg[1]))