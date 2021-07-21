-- Script: Element.lua

local HTTP = game:GetService("HttpService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")

local QuerySelector = require(script.Parent.QuerySelector)
local ElementGroupClass = require(script.Parent.ElementGroup)

----------

local ElementClass = {}
ElementClass.__index = ElementClass
ElementClass.Listeners = {}
ElementClass.GUID = HTTP:GenerateGUID()

----------
local function hasProperty(object, propertyName)
	local success, _ = pcall(function() 
		object[propertyName] = object[propertyName]
	end)
	return success
end

local function hasEvent(object, eventName)
	local success, _ = pcall(function()
		local connection = object[eventName]:Connect(function() end)
		connection:Disconnect()
	end)
	return success
end

local function querySelector(query)
	local tbl = QuerySelector(query)
	for k, v in pairs(tbl) do
		tbl[k] = ElementClass.new(v)
	end
	return ElementGroupClass.new(tbl)
end

local function getProperSelf(class, index)
	if typeof(class) == 'number' then
		local oldClass = class
		class = index
		index = oldClass
	end
	if class.GUID then return class end
	local correct = class.Elements
	correct = correct[index]
	if correct then
		return correct
	else
		return nil
	end
end
----------

function ElementClass:add(param, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	if typeof(param) == "string" then
		local elements = querySelector(param)
		local elementsClone = {}
		for _, v in ipairs(elements) do
			table.insert(elementsClone, v:clone(false))
		end
		for _, v in ipairs(elementsClone) do
			v:setParent(self)
		end
	elseif typeof(param) == "table" then
		for _, v in ipairs(param) do
			if typeof(v) == "table" then
				if not v['ClassName'] then return nil end
				local newInstance = Instance.new(v['ClassName'])
				for k, vv in pairs(v) do
					if hasProperty(newInstance, k) then
						newInstance[k] = vv
					elseif hasEvent(newInstance, k) then
						newInstance[k]:Connect(vv)
					end
				end
				local newElement = ElementClass.new(newInstance):setParent(self)
				return ElementGroupClass.new{newElement}
			elseif typeof(v) == "Instance" then
				return self:add(v, i)
			end
		end
	elseif typeof(param) == "Instance" then
		local newElement = ElementClass.new(param:Clone()):setParent(self)
		return ElementGroupClass.new{newElement}
	end
end

function ElementClass:all(get, set, i)
	local oldSelf = self
	
	if get and not set and not i then
		return oldSelf
	elseif get and set and not i then
		self = getProperSelf(self, set)
		
		local prop = self:prop(get, set) -- set is i
		
		if prop ~= nil then
			return prop
		else
			return self:attr(get, set) -- set is i
		end
	elseif get and set and i then
		self = getProperSelf(self, i)
		
		if hasProperty(self.instance, get) then
			self:prop(get, set, i)
		else
			self:attr(get, set, 1)
		end
		
		return oldSelf
	else
		return oldSelf
	end
end

function ElementClass:attr(get, set, i)
	local oldSelf = self
	
	if not i then
		self = getProperSelf(self, set)
		set = nil
	else
		self = getProperSelf(self, i)
	end
	
	if set == nil then
		return self.instance:GetAttributes()[get]
	else
		self.instance:SetAttribute(get, set)
		return oldSelf
	end
end

function ElementClass:children(selector: string, i)
	local oldSelf = self
	
	if selector and i then
		self = getProperSelf(self, i)
		
		local elements = {}
		
		local queried = querySelector(selector)
		
		for _, v in ipairs(self.instance:GetDescendants()) do
			if table.find(queried, v) then
				table.insert(elements, ElementClass.new(v))
			end
		end
		
		return elements
	elseif selector and not i then
		self = getProperSelf(self, selector)
		
		local elements = {}
		
		for _, v in ipairs(self.instance:GetDescendants()) do
			table.insert(elements, ElementClass.new(v))
		end
		
		return elements
	else
		return oldSelf
	end
end

--- :click
-- @param {Function} callback
-- @returns {void}
function ElementClass:click(callback, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	if callback then
		self:on("MouseButton1Click", tostring(math.random(1,1000).."_MouseButton1Click"), callback, i)
	elseif self.Listeners["MouseButton1Click"]['Callback'] then
		for _, v in ipairs(self.Listeners["MouseButton1Click"]['Callbacks']) do
			v()
		end
	end
	
	return oldSelf
end

--- :clone
-- @param {Boolean} setParentAutomatically
-- @returns {Element} newElement
function ElementClass:clone(setParentAutomatically, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	local newElement = setmetatable({}, self)
	newElement.GUID = HTTP:GenerateGUID()
	newElement.instance = self.instance:Clone()
	if setParentAutomatically then newElement.instance.Parent = self.instance.Parent end
	return newElement
end

--- Practically useless, but not worth deleting as it may be useful later
--- Use :children() instead!
--function ElementClass:contents(selector: string, i)
--	local oldSelf = self
	
--	if not i then
--		self = getProperSelf(self, selector)
--	else
--		self = getProperSelf(self, i)
		
--		local append = self.instance.Name.."."..self.instance.ClassName
--		if self.instance:GetAttribute("ROQUERY_ID") then append = append.."#"self.instance:GetAttribute("ROQUERY_ID") end
--		selector = append.." "..selector
--		return querySelector(selector)
--	end
--end

function ElementClass:die(i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	for _, v in pairs(self.Listeners['Connections']) do
		for _, vv in ipairs(v['Connections']) do
			vv() --vv:Disconnect()
		end
	end
	self.Listeners['Connections'] = {}
	
	return oldSelf
end

function ElementClass:fadeIn(i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	self:fadeTo(0, i)
	
	return oldSelf
end

function ElementClass:fadeOut(i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	self:fadeTo(1, i)
	
	return oldSelf
end

function ElementClass:fadeTo(target, i)
	local oldSelf = self
	
	if target and i then
		self = getProperSelf(self, i)
		
		local prop = ""
		
		if self.instance:IsA("GuiBase2d") then
			prop = "BackgroundTransparency"
		elseif self.instance:IsA("BasePart") then
			prop = "Transparency"
		end
		
		assert(typeof(target) == "number", "Parameter 'target' of ElementClass:fadeTo() must be of type 'number'!")
		if target > 100 then target = 100 end
		if target > 1 then target = target/100 end
		
		if self.instance:IsA("GuiBase2d") then
			TS:Create(self.instance, TweenInfo.new(0.5), {BackgroundTransparency = target}):Play()
			if hasProperty(self.instance, "Text") then
				TS:Create(self.instance, TweenInfo.new(0.5), {TextTransparency = target}):Play()
			end
			if hasProperty(self.instance, "Image") then
				TS:Create(self.instance, TweenInfo.new(0.5), {ImageTransparency = target}):Play()
			end
		elseif self.instance:IsA("BasePart") then
			TS:Create(self.instance, TweenInfo.new(0.5), {Transparency = target}):Play()
		end
		
		return oldSelf
	else
		self = getProperSelf(self, target)
		
		if self.instance:IsA("GuiBase2d") then
			TS:Create(self.instance, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
			if hasProperty(self.instance, "Text") then
				TS:Create(self.instance, TweenInfo.new(0.5), {TextTransparency = 0.5}):Play()
			end
			if hasProperty(self.instance, "Image") then
				TS:Create(self.instance, TweenInfo.new(0.5), {ImageTransparency = 0.5}):Play()
			end
		elseif self.instance:IsA("BasePart") then
			TS:Create(self.instance, TweenInfo.new(0.5), {Transparency = 0.5}):Play()
		end
		
		return oldSelf
	end
end

function ElementClass:fadeToggle(i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	local prop = ""
	
	if self.instance:IsA("GuiBase2d") then
		prop = "BackgroundTransparency"
	elseif self.instance:IsA("BasePart") then
		prop = "Transparency"
	end
	
	if self.instance[prop] == 0 then
		self:fadeOut(i)
	elseif self.instance[prop] == 1 then
		self:fadeIn(i)
	elseif self.instance[prop] <= 0.5 then
		self:fadeIn(i)
	elseif self.instance[prop] > 0.5 then
		self:fadeOut(i)
	end
	
	return oldSelf
end

function ElementClass:focusin(callback, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	if callback then
		self:on("MouseEnter", tostring(math.random(1,1000).."_MouseEnter"), callback, i)
	elseif self.Listeners["MouseEnter"]['Callback'] then
		for _, v in ipairs(self.Listeners["MouseEnter"]['Callbacks']) do
			v()
		end
	end
	
	return oldSelf
end

function ElementClass:focusout(callback, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	if callback then
		self:on("MouseLeave", tostring(math.random(1,1000).."_MouseLeave"), callback, i)
	elseif self.Listeners["MouseLeave"]['Callback'] then
		for _, v in ipairs(self.Listeners["MouseLeave"]['Callbacks']) do
			v()
		end
	end
	
	return oldSelf
end

function ElementClass:hide(duration, i)
	local oldSelf = self
	
	if not i then
		self = getProperSelf(self, duration)
		
		self.instance.BackgroundTransparency = 1
		if hasProperty(self.instance, "Text") then
			self.instance.TextTransparency = 1
		end
		if hasProperty(self.instance, "Image") then
			self.instance.ImageTransparency = 1
		end
	else
		self = getProperSelf(self, i)
		
		TS:Create(self.instance, TweenInfo.new(duration), {BackgroundTransparency = 1}):Play()
		if hasProperty(self.instance, "Text") then
			TS:Create(self.instance, TweenInfo.new(duration), {TextTransparency = 1}):Play()
		end
		if hasProperty(self.instance, "Image") then
			TS:Create(self.instance, TweenInfo.new(duration), {ImageTransparency = 1}):Play()
		end
	end
	
	return oldSelf
end

function ElementClass:hover(mouseIn, mouseOut, i)
	if typeof(mouseOut) == "number" then i = mouseOut end
	
	local oldSelf = self
	self = getProperSelf(self, i)
	
	if typeof(mouseIn) == "function" then
		self:focusin(mouseIn, i)
		if typeof(mouseOut) == "function" then
			self:focusout(mouseOut, i)
		end
	end
	
	return oldSelf
end

--- .new
-- @param {Instance} instance
-- @returns {Element} element
function ElementClass.new(instance)
	local self = setmetatable({['instance'] = instance}, ElementClass)
	return self
end

--- :on
-- @param {String} eventName The name of the event
-- @param {Function} callback Callback function
-- @returns {void}
function ElementClass:on(eventName, tagName, callback, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	if hasEvent(self.instance, eventName) then
		if not self.Listeners[eventName] then self.Listeners[eventName] = {['Connections'] = {}, ['Callbacks'] = {}} end
		if not self.Listeners[eventName]['Connections'] then self.Listeners[eventName]['Connections'] = {} end
		if not self.Listeners[eventName]['Callbacks'] then self.Listeners[eventName]['Callbacks'] = {} end
		if self.Listeners[eventName]['Callbacks'][string.lower(tagName)] == callback then return end
		
		local newConnection = self.instance[eventName]:Connect(callback)
		self.Listeners[eventName]['Connections'][string.lower(tagName)] = newConnection.Disconnect
		self.Listeners[eventName]['Callbacks'][string.lower(tagName)] = callback
	end
	
	return oldSelf
end

function ElementClass:off(eventName, tagName, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	if hasEvent(self.instance, eventName) then
		if self.Listeners[eventName]['Callbacks'][string.lower(tagName)] then
			self.Listeners[eventName]['Connections'][string.lower(tagName)]()
			self.Listeners[eventName]['Callbacks'][string.lower(tagName)] = nil
		end
	end
	
	return oldSelf
end

function ElementClass:parent(i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	return ElementClass.new(self.instance.Parent)
end

function ElementClass:parents(i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	local ancestors = {}
	local currentAncestor = self.instance.Parent
	
	repeat
		table.insert(ancestors, ElementClass.new(currentAncestor))
		currentAncestor = currentAncestor.Parent
	until currentAncestor.Parent == game
	
	return ancestors
end

function ElementClass:prop(get, set, i)
	local oldSelf = self
	if not i then
		self = getProperSelf(self, set)
		set = nil
	else
		self = getProperSelf(self, i)
	end
	
	if hasProperty(self.instance, get) then
		if set == nil then
			return self.instance[get]
		else
			self.instance[get] = set
			return oldSelf
		end
	end
end

function ElementClass:setParent(Element, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	self.Parent = Element
	self.instance.Parent = Element.instance
	
	return oldSelf
end
	
function ElementClass:setText(text, i)
	local oldSelf = self
	self = getProperSelf(self, i)
	
	text = tostring(text) -- For numbers & booleans
	assert(typeof(text) == "string", "Parameter 'text' of ElementClass:setText() must be of type 'string'!")
	if hasProperty(self.instance, "Text") then
		self.instance.Text = text
	else
		warn("Method 'setText' of ElementClass must only be called on GuiBases with the 'Text' property!")
	end
	
	return oldSelf
end

function ElementClass:show(duration, i)
	local oldSelf = self
	
	if not i then
		self = getProperSelf(self, duration)
		
		self.instance.BackgroundTransparency = 0
		if hasProperty(self.instance, "Text") then
			self.instance.TextTransparency = 0
		end
		if hasProperty(self.instance, "Image") then
			self.instance.ImageTransparency = 0
		end
	else
		self = getProperSelf(self, i)
		
		TS:Create(self.instance, TweenInfo.new(duration), {BackgroundTransparency = 0}):Play()
		if hasProperty(self.instance, "Text") then
			TS:Create(self.instance, TweenInfo.new(duration), {TextTransparency = 0}):Play()
		end
		if hasProperty(self.instance, "Image") then
			TS:Create(self.instance, TweenInfo.new(duration), {ImageTransparency = 0}):Play()
		end
	end
	
	return oldSelf
end

return ElementClass
