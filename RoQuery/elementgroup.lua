-- Script: ElementGroup.lua

local QuerySelector = require(script.Parent.QuerySelector)

local methods = {
	'add',
	'all',
	'attr',
	'children',
	'click',
	'clone',
	'die',
	'fadeIn',
	'fadeOut',
	'fadeTo',
	'fadeToggle',
	'focusin',
	'focusout',
	'hide',
	'hover',
	'on',
	'off',
	'prop',
	'setParent',
	'setText',
	'show'
}

local hasReturnValue = {
	'add',
	'all',
	'attr',
	'children',
	'clone',
	'prop'
}

----------

local ElementGroupClass = {}
ElementGroupClass.__index = ElementGroupClass

----------

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

local function forEach(self, method, params)
	local returnTbl = {}
	
	table.foreachi(self.Elements, function(i,v)
		local params2 = deepCopy(params)
		table.insert(params2, i)
		local res = v[method](unpack(params2))
		if table.find(hasReturnValue, method) then
			if method == "all" or method == "attr" or method == "prop" then
				if res == self then
					returnTbl = self
				else
					returnTbl[self.Elements[i].instance:GetFullName()] = res
				end
			elseif method == "children" then
				for _, v in pairs(res) do
					table.insert(returnTbl, v)
				end
			else
				returnTbl[self.Elements[i].instance:GetFullName()] = res
			end
		else
			returnTbl = self
		end
	end)
	
	self.length = table.getn(self.Elements)
	
	if not returnTbl['Elements'] then
		for k, v in pairs(returnTbl) do
			if v['Elements'] then
				returnTbl[k] = nil
			end
		end
	end
	
	if method == "children" then
		returnTbl = ElementGroupClass.new(returnTbl)
	end
	
	return returnTbl
end

----------

ElementGroupClass.new = function(elements)
	local self = setmetatable({['Elements'] = {}, ['length'] = 0}, ElementGroupClass)
	
	for _, v in pairs(elements) do
		table.insert(self.Elements, v)
		self.length = table.getn(self.Elements)
	end
	
	function self:even()
		local newTbl = {}
		for k, v in ipairs(self.Elements) do
			if k % 2 == 0 then
				table.insert(newTbl, v)
			end
		end
		return ElementGroupClass.new(newTbl)
	end
	
	function self:filter(query)
		local queried = QuerySelector(query)
		local elements = {}
		
		for _, v in ipairs(self.Elements) do
			if table.find(queried, v.instance) then
				table.insert(elements, v)
			end
		end
		
		return ElementGroupClass.new(elements)
	end
	
	function self:first()
		self.Elements = self.Elements[1]
		self.length = table.getn(self.Elements)
		return self
	end
	
	function self:foreach(callback)
		local resultTbl = {}
		for i, v in pairs(self.Elements) do
			local res = callback(i, v)
			table.insert(resultTbl, res)
		end
		return resultTbl
	end
	
	function self:has(query)
		local elements = QuerySelector(query)
		for index, existingElement in pairs(self.Elements) do
			local exists = false
			for _, queriedInstance in pairs(elements) do
				if queriedInstance:IsDescendantOf(existingElement.instance) then
					exists = true
					break
				end
			end
			if not exists then
				table.remove(self.Elements, index)
			end
		end
		self.length = table.getn(self.Elements)
		return self
	end
	
	function self:is(query)
		local elements = QuerySelector(query)
		local amountExists = 0
		for _, existingElement in pairs(self.Elements) do
			for _, queriedInstance in pairs(elements) do
				if existingElement.instance == queriedInstance then
					amountExists += 1
					break
				end
			end
		end
		if amountExists > 0 then
			return true
		else
			return false
		end
	end
	
	function self:last()
		self.Elements = self.Elements[#self.Elements]
		self.length = table.getn(self.Elements)
		return self
	end
	
	function self:isNot(query) -- 'not' is a reserved keyword
		local elements = QuerySelector(query)
		for k, existingElement in pairs(self.Elements) do
			for _, queriedInstance in pairs(elements) do
				if existingElement.instance == queriedInstance then
					table.remove(self.Elements, k)
					break
				end
			end
		end
		return ElementGroupClass.new(self.Elements)
	end
	
	function self:odd()
		local newTbl = {}
		for k, v in ipairs(self.Elements) do
			if k % 2 == 1 then
				table.insert(newTbl, v)
			end
		end
		return ElementGroupClass.new(newTbl)
	end
	
	function self:parent()
		local elements = {}
		for k, v in ipairs(self.Elements) do
			table.insert(elements, v:parent(k))
		end
		return ElementGroupClass.new(elements)
	end
	
	function self:parents(query)
		local elements = {}
		
		for k, v in ipairs(self.Elements) do
			local parents = v:parents(k)
			for _, vv in ipairs(parents) do
				table.insert(elements, vv)
			end
		end
		
		if query then
			local queried = QuerySelector(query)
			local finalElements = {}
			
			for k, v in ipairs(elements) do
				local inst = v.instance
				if table.find(queried, inst) then
					table.insert(finalElements, v)
				end
			end
			
			return ElementGroupClass.new(finalElements)
		else
			return ElementGroupClass.new(elements)
		end
	end
	
	function self:parentsUntil(query)
		local queried = QuerySelector(query)
		local elements = {}
		
		for k, v in ipairs(self.Elements) do
			local parents = v:parents(k)
			for _, vv in ipairs(parents) do
				table.insert(elements, vv)
			end
		end
		
		local finalElements = {}
		
		for k, v in ipairs(elements) do
			local inst = v.instance
			if table.find(queried, inst) then
				break
			else
				table.insert(finalElements, v)
			end
		end
		
		return ElementGroupClass.new(finalElements)
	end
	
	function self:remove(query)
		local queried = QuerySelector(query)
		local elements = {}
		local returnTbl = {}
		
		for _, v in ipairs(self.Elements) do
			if table.find(queried, v.instance) then
				table.insert(elements, v)
			else
				table.insert(returnTbl, v)
			end
		end
		
		for _, v in ipairs(elements) do
			v.instance:Destroy()
			for _, vv in ipairs(v.Listeners) do
				for _, vvv in ipairs(vv['Connections']) do
					vvv() -- Disconnect
				end
			end
		end
		
		return ElementGroupClass.new(returnTbl)
	end
	
	function self:wait(duration: number)
		if type(duration) == 'number' then
			task.wait(duration)
		end
		return self
	end
	
	for _, v in ipairs(methods) do
		self[v] = function(...)
			return forEach(self, v, {...})
		end
	end
	
	return self
end

return ElementGroupClass
