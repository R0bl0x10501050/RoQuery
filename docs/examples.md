## Examples

### Print A Part's Ancestors

=== "Lua"

    ```lua
    S('.model#model .part .part .part .part'):parents():foreach(function(i,v)
      print(v)
    end)
    ```
    
## Name All Parts "Thingy" (Except HRP)

=== "Lua"

    ```lua
    S('.part'):isNot('humanoidrootpart.part'):prop("Name", "Thingy")
    ```
    
Those are just a few example of what you can do with RoQuery!
