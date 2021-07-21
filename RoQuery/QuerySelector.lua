-- Script: QuerySelector.lua

local RS = game:GetService("RunService")

local function log(thing, trackback)
	if script:GetAttribute('debug') then
		if typeof(trackback) ~= "number" then
			print(debug.traceback())
		else
			if trackback == 2 then
				warn(thing)
			elseif trackback == 3 then
				error(thing)
			else
				print(thing)
			end
		end
	end
end

-- OLD checkHierarchy function, look below for the NEWER one!
local function checkHierarchy2(tbl, tree)
	local returnValue = {}
	log(table.getn(tree))
	log(tbl)
	if table.getn(tree) > 1 then
		-- There are parent elements
		log("There are parent elements")
		for k, v in ipairs(tbl) do
			log("CURRENTLY SCANNING:")
			log(v)
			log("-----")
			local isInTbl = false
			for k2, v2 in ipairs(tbl) do
				log(v2)
				if v2:IsAncestorOf(v) then
					isInTbl = true
					break
				end
			end
			log("isInTbl: "..tostring(isInTbl))
			if isInTbl then
				table.insert(returnValue, #returnValue+1, v)
			end
			log("--------------------")
		end
		--for k, v in ipairs(tbl) do
		--	print(k)
		--	print(v)
		--	print(tbl[k+1])
		--	if tbl[k+1]:IsDescendantOf(v) then
		--		print("Found!")
		--		table.remove(tbl, k)
		--	end
		--	print("------------------")
		--end
	else
		-- No parent elements
		log("No parent elements")
		returnValue = tbl
	end
	log(returnValue)
	return returnValue
end

local function checkHierarchy(tbl, tree)
	if table.getn(tree) > 1 then
		local returnValue = {}
		local grouping = {}
		
		--[[
		Loop through entries in tree and find the elements in tbl that match the branch.
		]]
		
		log(tree, 2)
		
		for _, v in pairs(tree) do
			local name, classname, id = v[1], string.gsub(v[2], "RoQueryCLASS_", ""), v[3]
			
			if id then
				id = string.gsub(id, "RoQueryID_", "")
			end
			
			local groupingPart = {}
			
			log(v, 2)
			
			for k, vv in pairs(tbl) do
				if classname then
					log(vv.ClassName)
					if name and id then
						log(vv.Name)
						log(vv:GetAttribute('ROQUERY_ID'))
						local part1, part2, part3
						if string.lower(vv.Name) == name then
							part1 = true
						end
						if string.lower(vv.ClassName) == classname then
							part2 = true
						end
						if vv:GetAttribute(id) then
							if string.lower(vv:GetAttribute('ROQUERY_ID')) == id then
								part3 = true
							end
						end
						if part2 and part1 and part3 then
							table.insert(groupingPart, vv)
						end
					elseif name then
						log(vv.Name)
						local part1, part2
						if string.lower(vv.Name) == name then
							part1 = true
						end
						if string.lower(vv.ClassName) == classname then
							part2 = true
						end
						if part2 and part1 then
							table.insert(groupingPart, vv)
						end
					elseif id then
						log(vv:GetAttribute('ROQUERY_ID'))
						local part2, part3
						if string.lower(vv.ClassName) == classname then
							part2 = true
						end
						if vv:GetAttribute('ROQUERY_ID') then
							if string.lower(vv:GetAttribute('ROQUERY_ID')) == id then
								part3 = true
							end
						end
						if part2 and part3 then
							table.insert(groupingPart, vv)
						end
					else
						if string.lower(vv.ClassName) == classname then
							if not table.find(groupingPart, vv) then
								table.insert(groupingPart, vv)
							end
						end
					end
				end
			end
			log(groupingPart)
			table.insert(grouping, groupingPart)
		end
		
		-----
		
		local function deepCopy(original)
			local copy = {}
			for k, v in pairs(original) do
				if type(v) == "table" then
					v = deepCopy(v)
				end
				copy[k] = v
			end
			return copy
		end
		
		local grouping2 = deepCopy(grouping)
		
		for _, v in ipairs(grouping2) do
			for k, vv in ipairs(v) do
				v[k] = vv:GetFullName()
			end
		end
		
		log(grouping2, 2)
		
		-----
		
		for k, v in ipairs(grouping) do
			if k == 1 then continue end
			log("New Table: "..k)
			for i, vv in ipairs(v) do
				log(i)
				log(vv)
				log(vv:GetFullName())
				local found = false
				
				for _, vvv in ipairs(grouping[k-1]) do
					if vvv == "ROQUERY_NIL_PLACEHOLDER" then continue end
					if vv:IsDescendantOf(vvv) then
						found = vvv
						break
					end
				end
				
				if not found then
					log("removing "..i.." from table")
					log(vv:GetFullName())
					log(v)
					v[i] = "ROQUERY_NIL_PLACEHOLDER"
				else
					log('found is:')
					log(found:GetFullName())
				end
				
				--if not table.find(grouping[k-1], vv.Parent) then
				--	print("removing "..i.." from table")
				--	print(v)
				--	table.remove(v, i)
				--else
				--	print("Found! "..table.find(grouping[k-1], vv.Parent))
				--end
				
				log("-----------------------------")
			end
		end
		
		log(grouping, 2)
		
		local endTbl = {}
		
		table.foreachi(grouping[#grouping], function(i,v)
			if v ~= "ROQUERY_NIL_PLACEHOLDER" then
				table.insert(endTbl, v)
			end
		end)
		
		return endTbl
	else
		return tbl
	end
end

return function(query: string, treeOnly)
	if treeOnly == nil then treeOnly = false end
	
	if not query then
		warn("QuerySelector Failed: No Query Provided")
		print(debug.traceback())
		return
	end
	
	local divided = string.split(query, " ")
	local elementTree = {}
	
	--[[
	for i, v in ipairs(divided) do
		local thisElement
		local attr
		local currently = "text"
		local exists = false
		
		local tokens = string.split(v, "")
		
		for _, token in ipairs(tokens) do
			if token == "." then
				if tokens[1] == token then
					exists = true
				end
				attr = "CLASS_"
				currently = "class"
			elseif token == "#" then
				if tokens[1] == token then
					exists = true
				end
				attr = "ID_"
				currently = "id"
			else
				if currently == "class" then
					attr = attr .. token
				elseif currently == "id" then
					attr = attr .. token
				elseif currently == "text" then
					if tokens[1] == token then
						thisElement = tostring(token)
					elseif exists == false then
						thisElement = thisElement .. token
					end
				end
			end
		end
		
		elementTree[#elementTree+1] = {thisElement, attr}
	end
	]]
	
	for i, v in ipairs(divided) do
		local thisElement
		local attr1, attr2, currentAttr
		local currently = "text"
		local exists = false
		
		local tokens = string.split(v, "")
		
		for _, token in ipairs(tokens) do
			if token == "." then
				if tokens[1] == token then
					exists = true
				end
				if attr1 == nil then
					attr1 = "RoQueryCLASS_"
					currentAttr = 1
				else
					attr2 = "RoQueryCLASS_"
					currentAttr = 2
				end
				currently = "class"
			elseif token == "#" then
				if tokens[1] == token then
					exists = true
				end
				if attr1 == nil then
					attr1 = "RoQueryID_"
					currentAttr = 1
				else
					attr2 = "RoQueryID_"
					currentAttr = 2
				end
				currently = "id"
			else
				if currently == "class" then
					if currentAttr == 1 then
						attr1 = attr1 .. token
					elseif currentAttr == 2 then
						attr2 = attr2 .. token
					end
				elseif currently == "id" then
					if currentAttr == 1 then
						attr1 = attr1 .. token
					elseif currentAttr == 2 then
						attr2 = attr2 .. token
					end
				elseif currently == "text" then
					if tokens[1] == token then
						thisElement = tostring(token)
					elseif exists == false then
						thisElement = thisElement .. token
					end
				end
			end
		end
		
		elementTree[#elementTree+1] = {thisElement, attr1, attr2}
	end
	
	log(elementTree)
	
	local allowedPlacesForServer = {game.Workspace, game.Players, game.Lighting, game.ReplicatedFirst, game.ReplicatedStorage, game.ServerScriptService, game.ServerStorage, game.StarterGui, game.StarterPack, game.StarterPlayer, game.Teams, game.SoundService, game.Chat}
	local allowedPlacesForClient = {game.Workspace, game.Players, game.Lighting, game.ReplicatedFirst, game.ReplicatedStorage, game.StarterGui, game.StarterPack, game.StarterPlayer, game.Teams, game.SoundService, game.Chat}
	
	local allowedPlaces
	if RS:IsClient() then
		allowedPlaces = allowedPlacesForClient
	else
		allowedPlaces = allowedPlacesForServer
	end
	
	if not treeOnly then
		local finalElements = {}
		
		for k, v in pairs(elementTree) do
			for _, gameChild in ipairs(allowedPlaces) do
				for _, descendant in ipairs(gameChild:GetDescendants()) do
					local checks = table.getn(v)
					local checksDone = 0
					local checksPassed = 0
					
					--
					
					if v[1] then
						local firstCheck = string.split(v[1], "_")
						
						if firstCheck[1] == "RoQueryCLASS" then
							if string.lower(descendant.ClassName) == string.lower(firstCheck[2]) then
								checksPassed += 1
							end
						elseif firstCheck[1] == "RoQueryID" then
							if descendant:GetAttribute("ROQUERY_ID") == firstCheck[2] then
								checksPassed += 1
							end
						else
							if string.lower(descendant.Name) == string.lower(firstCheck[1]) then
								checksPassed += 1
							end
						end
						
						checksDone += 1
					end
					
					--
					
					if v[2] then
						local secondCheck = string.split(v[2], "_")
						
						if secondCheck[1] == "RoQueryCLASS" then
							if string.lower(descendant.ClassName) == string.lower(secondCheck[2]) then
								checksPassed += 1
							end
						elseif secondCheck[1] == "RoQueryID" then
							if descendant:GetAttribute("ROQUERY_ID") == secondCheck[2] then
								checksPassed += 1
							end
						else
							if string.lower(descendant.Name) == string.lower(secondCheck[2]) then
								checksPassed += 1
							end
						end
						
						checksDone += 1
					end
					
					--
					
					if v[3] then
						local thirdCheck = string.split(v[3], "_")
						
						if thirdCheck[1] == "RoQueryCLASS" then
							if string.lower(descendant.ClassName) == string.lower(thirdCheck[2]) then
								checksPassed += 1
							end
						elseif thirdCheck[1] == "RoQueryID" then
							if descendant:GetAttribute("ROQUERY_ID") == thirdCheck[2] then
								checksPassed += 1
							end
						else
							if string.lower(descendant.Name) == string.lower(thirdCheck[2]) then
								checksPassed += 1
							end
						end
						
						checksDone += 1
					end
					
					--
					
					if checksPassed == checksDone and checksPassed ~= 0 then
						table.insert(finalElements, descendant)
					end
				end
			end
		end
		
		log(finalElements)
		
		return checkHierarchy(finalElements, elementTree)
	else
		return elementTree
	end
end
