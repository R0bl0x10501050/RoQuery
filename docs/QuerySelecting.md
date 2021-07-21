## How QuerySelecting Works

**Note: If you know CSS, this should be a piece of cake - literally. 🍰**

Consider the following string:
```lua
"baseplate.part part.part#somerandomid"
```

This is an example of a valid selector. Let's break it down.

`baseplate.part`

* `baseplate` = Name of the Instance (case-insensitive)
* `.part` = ClassName of the Instance (case-insensitive)

___

`part.part#somerandomid`

Since this comes after the first query, it means that it will only return `part.part#somerandomid` elements that are descendants of `baseplate.part`.

* `part` = Name of the Instance (case-insensitive)
* `.part` = ClassName of the Instance (case-insensitive)
* `#somerandomid` = ROQUERY_ID (attribute) of the Instance (case-insensitive)

??? info "How To Set A RoQuery ID"
    To set a RoQuery ID that can be recognized by the QuerySelector, create a new attribute called "ROQUERY_ID" (case-sensitive) and set the value to whatever you want the ID to be.

This expression would return **any** Instance that 1) has a parent that is of class "Part" and named "baseplate" (case-insensitive) and 2) is of class "Part", named "Part" (case-insensitive), and has a RoQuery ID of "somerandomid" (case-insensitive).
