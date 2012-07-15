Basalt is an [Entity-Component system](http://www.gamasutra.com/blogs/MeganFox/20101208/6590/Game_Engines_101_The_EntityComponent_Model.php) built on top of the Moai SDK. Its purpose is to provide a simplified api for performing common tasks while retaining the ability to use lower-level functionality.

Basalt will provide some common utility methods such as initialization

    Basalt.init(width, height [, window_name])

And setting a background color

    Basalt.background_color(r, g, b)

The primary way to interact with Basalt is by creating entities. An entity is a game
object that can have functionality applied to it in the form of components.

    entity = Basalt.entity()

This entity's prop could be an image

	entity.add(Basalt.Component.Image, {image_path='', width=0, height=0})

Or a filled rectangle

    entity.add(Basalt.Component.Rect, {width=0, height=0, r=255, g=255, b=255})

Or circle

    entity.add(Basalt.Component.Circle, {radius=0, steps=0, r=255, g=255, b=255})

It could be draggable

    entity.add(Basalt.Component.Draggable)

Or clickable with an onClick callback

    entity.add(Basalt.Component.Click, callback_function = function() end)

Or be collision-aware with an onCollide callback

    -- not yet implemented
    entity.add(Basalt.Component.Collision, callback_function = function() end)