# Installation

Install RoQuery by requiring the module.

=== "Lua"

    ```lua
    local S = require("path/to/RoQuery.lua")
    ```

[Get The Module](#){ .md-button .md-button--primary }

# RoQuery

## RoQuery(selector)
**Description:**

The beginning constructor for RoQuery.

**Type:**

`Class:Method:constructor`

**Params:**

`selector: string`
:   The selector used to fetch Instances from the Instance tree.

**Returns:**

[ElementGroup](#elementgroup)

# ElementGroup

## ElementGroup:add(param)
**Description:**

Adds an instance in the Element.

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

[ElementGroup](#elementgroup) of the new Element

## ElementGroup:all(get, set)
**Description:**

Gets or sets a property/attribute of the Element.

**Type:**

`Class:Method`

**Params:**

`get: string`
:   This will check the current Element's instance for the property `get`. If only get is provided, this will return the value of the property. If the property doesn't exist,       it will check attributes.

`set: any?`
:   **OPTIONAL:** This will check the current Element's instance for the property `get`. If set is provided, this will set the value of the property `get` to `set`. If the           property doesn't exist, it will set an attribute.

**Returns:**

IF get AND set: [ElementGroup](#elementgroup) (itself)

IF get AND NOT set: `any`

## ElementGroup:attr(get, set)
**Description:**

Gets or sets an attribute of the Element.

**Type:**

`Class:Method`

**Params:**

`get: string`
:   This will check the current Element's instance for the attribute `get`. If only get is provided, this will return the value of the attribute.

`set: any?`
:   **OPTIONAL:** This will check the current Element's instance for the attribute `get`. If set is provided, this will set the value of the attribute `get` to `set`.

**Returns:**

IF get AND set: [ElementGroup](#elementgroup) (itself)

IF get AND NOT set: `any`

## ElementGroup:children(selector)
**Description:**

Gets all children of the Element.

**Type:**

`Class:Method`

**Params:**

`selector: string?`
:   **OPTIONAL:** The selector used to filter out  the children of the current Element's instance.

**Returns:**

[ElementGroup](#elementgroup) of the children

## ElementGroup:click(callback)
**Description:**

Adds a callback to MouseButton1Click. Equivalent to `self:on("MouseButton1Click", callback)`.

**Type:**

`Class:Method`

**Params:**

`callback: function`
:   Binds `callback` to the current Element's `instance.MouseButton1Click`

**Returns:**

[ElementGroup](#elementgroup) (itself)

## ElementGroup:clone(setParentAutomatically)
**Description:**

Clones the Element.

**Type:**

`Class:Method`

**Params:**

`setParentAutomatically: boolean`
:   If `true`, then new Element will be parented to the current Element.

**Returns:**

[ElementGroup](#elementgroup) of the new Element

## ElementGroup:die()
**Description:**

Kills all connnections tied to the Element.

**Type:**

`Class:Method`

**Params:**

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:even()
**Description:**

Returns the even-indexed Elements in the ElementGroup.

**Type:**

`Class:Method`

**Params:**

**Returns:**

[ElementGroup](#elementgroup) (the even-indexed entries)

## ElementGroup:fadeIn()
**Description:**

Fades in the Element.

**Type:**

`Class:Method`

**Params:**

**Returns:**

[ElementGroup](#elementgroup) (itself)

## ElementGroup:fadeOut()
**Description:**

Fades out the Element.

**Type:**

`Class:Method`

**Params:**

**Returns:**

[ElementGroup](#elementgroup) (itself)

## ElementGroup:fadeTo(target)
**Description:**

Fades the Element to `target`.

**Type:**

`Class:Method`

**Params:**

`target: number (default: 0.5)`
:   The target transparency.

**Returns:**

[ElementGroup](#elementgroup) (itself)

## ElementGroup:fadeToggle()
**Description:**

Toggle between invisible and visible.

**Type:**

`Class:Method`

**Params:**

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:filter(selector)
**Description:**

Returns the current Elements that matched with the selector.

**Type:**

`Class:Method`

**Params:**

`selector: string`
:   Selector used to filter out Elements

**Returns:**

[ElementGroup](#elementgroup) (the Elements that matched with the selector)

# ElementGroup:first()
**Description:**

Returns the first Element (in the form of an ElementGroup) of the current ElementGroup.

**Type:**

`Class:Method`

**Params:**

**Returns:**

[ElementGroup](#elementgroup) (the first Element)

# ElementGroup:focusin(callback)
**Description:**

Adds a callback to MouseEnter. Equivalent to `self:on("MouseEnter", callback)`.

**Type:**

`Class:Method`

**Params:**

`callback: function`
:   Binds `callback` to the current Element's `instance.MouseEnter`

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:focusout(callback)
**Description:**

Adds a callback to MouseLeave. Equivalent to `self:on("MouseLeave", callback)`.

**Type:**

`Class:Method`

**Params:**

`callback: function`
:   Binds `callback` to the current Element's `instance.MouseLeave`

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:foreach(callback)
**Description:**

Call the callback on each Element in the current ElementGroup.

**Type:**

`Class:Method`

**Params:**

`callback: function`
:   The callback that is used on each Element. The two callback's params are 1) index, and 2) the Element.

**Returns:**

Table (the return value of all the callbacks)

# ElementGroup:hide(duration)
**Description:**

Like self:fadeOut(), but time is customizable.

**Type:**

`Class:Method`

**Params:**

`duration: number? (default: 0)`
:   Amount of time for Element to fade out.

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:hover(mouseIn, mouseOut)
**Description:**

Adds up to two callbacks (MouseEnter, MouseLeave). Equivalent to `self:on("MouseEnter", mouseIn):on("MouseLeave", mouseOut)`.

**Type:**

`Class:Method`

**Params:**

`mouseIn: function`
:   Binds `mouseIn` to the current Element's `instance.MouseEnter`.

`mouseOut: function`
:   Binds `mouseOut` to the current Element's `instance.MouseLeave`.

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:odd()
**Description:**

Returns the odd-indexed Elements in the ElementGroup.

**Type:**

`Class:Method`

**Params:**

**Returns:**

[ElementGroup](#elementgroup) (the odd-indexed entries)

# ElementGroup:on(eventName, tagName, callback)
**Description:**

Adds a callback to event `instance[eventName]`.

**Type:**

`Class:Method`

**Params:**

`eventName: string`
:   The name of the event.

`tagName: string`
:   The unique name of the connection (used for `self:off()`).

`callback: function`
:   Binds `callback` to the current Element's `instance[eventName]`.

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:off(eventName, tagName)
**Description:**

Removes a callback from event `instance[eventName]`.

**Type:**

`Class:Method`

**Params:**

`eventName: string`
:   The name of the event.

`tagName: string`
:   The unique name for the connection.

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:parent()
**Description:**

Gets the parent of the current Element.

**Type:**

`Class:Method`

**Params:**

**Returns:**

[ElementGroup](#elementgroup) of the parent

# ElementGroup:parents(selector)
**Description:**

Gets the parents of the current Element and filter out the ones that DO NOT match the selector.

**Type:**

`Class:Method`

**Params:**

`selector: string?`
:   The selector used to filter out the parents.

**Returns:**

[ElementGroup](#elementgroup) of the parent

## ElementGroup:prop(get, set)
**Description:**

Gets or sets a property of the Element.

**Type:**

`Class:Method`

**Params:**

`get: string`
:   This will check the current Element's instance for the property `get`. If only get is provided, this will return the value of the property.

`set: any?`
:   **OPTIONAL:** This will check the current Element's instance for the property `get`. If set is provided, this will set the value of the property `get` to `set`.

**Returns:**

IF get AND set: [ElementGroup](#elementgroup) (itself)

IF get AND NOT set: `any`

## ElementGroup:setText(text)
**Description:**

Sets the Text property of the Element.

**Type:**

`Class:Method`

**Params:**

`text: string`
:   The string of text to set `instance.Text` to.

**Returns:**

[ElementGroup](#elementgroup) (itself)

# ElementGroup:show(duration)
**Description:**

Like self:fadeIn(), but time is customizable.

**Type:**

`Class:Method`

**Params:**

`duration: number? (default: 0)`
:   Amount of time for Element to fade in.

**Returns:**

[ElementGroup](#elementgroup) (itself)
