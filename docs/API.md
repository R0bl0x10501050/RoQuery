# Installation

Install RoQuery by requiring the module.

=== "Lua"

    ```lua
    local S = require("path/to/RoQuery.lua")
    ```

[Get The Module](#){ .md-button .md-button--primary }

# RoQuery

## RoQuery(selector)
**Type:**

`Class:Method:constructor`

**Params:**

`selector: string`
:   The selector used to fetch Instances from the Instance tree.

**Returns:**

[ElementGroup](#elementgroup)

# ElementGroup

## ElementGroup:add(param)
**Type:**

`Class:Method`

**Params:**

`param: string`
:   In string form, param is used to create the appropriate Instance using QuerySelector.

`param: table`
:   In table form, param is used to create the appropriate Instance by recreating an Instance from the table values.

`param: string`
:   In Instance form, param is used to create the appropriate Instance by literally using the Instance provided.

**Returns:**

[ElementGroup](#elementgroup)

## ElementGroup:all(get, set)
**Type:**

`Class:Method`

**Params:**

`get: string`
:   This will check the current Element's instance for the property `get`. If only get is provided, this will return the value of the property. If the property doesn't exist,       it will check attributes.

`set: any`
:   This will check the current Element's instance for the property `get`. If set is provided, this will set the value of the propert `get` to `set`. If the property doesn't         exist, it will set an attribute.

**Returns:**

IF get AND set: [ElementGroup](#elementgroup)

IF get AND NOT set: `any`
