if(#arg < 1) then
	print("luajit grid.lua <input file>")
	return
end

-- Just a list of strings
local grid = {}
function GridChar(x, y)
	return grid[y]:sub(x,x)
end

-- Returns number, (x, length)
function LeftmostDigit(line, start)
	-- Roll back to first digit
	local pos = start
	while(line:sub(pos,pos):find("%d")) do
		pos = pos - 1
	end

	local m = line:match("%d+", pos)
	return tonumber(m), {x = pos, len = string.len(m)}
end

-- Return sum of adjacent numbers
-- X,Y is symbol location
function ClockSearch(x, y, masks)
	local acc = 0

	--local masks = {}
	function IsMasked(x,y) 
		for k,curmask in pairs(masks) do 
			if(y == curmask.y and (x >= curmask.x and x <= curmask.x + curmask.len)) then 
				return true 
			end 
		end 
		return false 
	end
	
	for _y = -1,1 do for _x = -1,1 do
		local c = GridChar(x + _x, y + _y)
		local p = c:find("%d")
		
		if p and not IsMasked(x + _x, y + _y) then
			-- find leftmost digit
			local num, msk = LeftmostDigit(grid[y + _y], x + _x)
			msk.y = y + _y
			masks[#masks+1] = msk
			
			acc = acc + num
		end
	end end
	
	return acc
end

function ClockSearchGearRatio(x, y, masks)
	local acc = 0
	
	local bIsGear = GridChar(x, y) == "*"
	local nums = {}
	print(GridChar(x,y))

	function IsMasked(x,y) 
		for k,curmask in pairs(masks) do 
			if(y == curmask.y and (x >= curmask.x and x <= curmask.x + curmask.len)) then 
				return true 
			end 
		end 
		--print("Not masked @ " .. x .. "," .. y)
		return false 
	end

	for _y = -1,1 do for _x = -1,1 do
		local c = GridChar(x + _x, y + _y)
		local p = c:find("%d")
		
		if p and not IsMasked(x + _x, y + _y) then
			-- find leftmost digit
			local num, msk = LeftmostDigit(grid[y + _y], x + _x)
			msk.y = y + _y
			masks[#masks+1] = msk

			acc = acc + num
			nums[#nums + 1] = num
		end
	end end
	
	if(bIsGear and #nums == 2) then
		return nums[1] * nums[2]
	else
		return 0
	end
end

-- gmatch iterator to find symbols 
-- numbers seem to only be able to be adjacent to one symbol

-- Returns sum of all adjacent numbers
function Part1(path)
	local symbols = {}
	
	for l in io.lines(path) do
		grid[#grid+1] = l
		
		local pos = 0
		while pos ~= nil do
			pos = l:find("[^%a%d%.]", pos + 1)
			if(pos) then symbols[#symbols+1] = {x = pos, y = #grid} end
		end
	end
	
	local masks = {}
	
	local acc = 0
	for k,v in pairs(symbols) do 
		--print(GridChar(v.x, v.y))
		acc = acc + ClockSearch(v.x, v.y, masks)
	end
	
	return acc
end


function Part2(path)
	local symbols = {}
	
	for l in io.lines(path) do
		grid[#grid+1] = l
		
		local pos = 0
		while pos ~= nil do
			pos = l:find("[^%a%d%.]", pos + 1)
			if(pos) then symbols[#symbols+1] = {x = pos, y = #grid} end
		end
	end
	
	local masks = {}
	
	local acc = 0
	for k,v in pairs(symbols) do 
		--print(GridChar(v.x, v.y))
		acc = acc + ClockSearchGearRatio(v.x, v.y, masks)
	end
	
	return acc
end

print(Part1(arg[1]))
print(Part2(arg[1]))