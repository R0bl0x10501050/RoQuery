local QuerySelector = require(script.QuerySelector)
local ElementGroupClass = require(script.ElementGroup)
local ElementClass = require(script.Element)

--local RoQuery = {}
--setmetatable(RoQuery, RoQuery)

--RoQuery.__call = function(query)
return function(query)
	if typeof(query) == "table" then return end
	local finalElements = QuerySelector(query)
	for k, v in pairs(finalElements) do
		finalElements[k] = ElementClass.new(v)
	end
	return ElementGroupClass.new(finalElements)
end

--return RoQuery

-- The metatable structure is there in case I end up adding functions to the base.
