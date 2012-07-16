Mocos (MOai COmponent System) is an [Entity-Component system](http://www.gamasutra.com/blogs/MeganFox/20101208/6590/Game_Engines_101_The_EntityComponent_Model.php) built on top of the Moai SDK. Its purpose is to provide a high-level interface for performing common tasks while retaining the ability to use lower-level functionality.

Mocos will provide some common utility methods such as initialization

    Mocos.init(width, height [, window_name])

And setting a background color

    Mocos.background_color(r, g, b)

The primary way to interact with Mocos is by creating entities. An entity is a game
object that can have functionality applied to it in the form of components.

    entity = Mocos.entity()

This entity's prop could be an image

	entity.add(Mocos.Component.Image, {image_path='', width=0, height=0})

Or a filled rectangle

    entity.add(Mocos.Component.Rect, {width=0, height=0, r=255, g=255, b=255})

Or circle

    entity.add(Mocos.Component.Circle, {radius=0, steps=0, r=255, g=255, b=255})

It could be draggable

    entity.add(Mocos.Component.Draggable)

Or clickable with an onClick callback

    entity.add(Mocos.Component.Click, callback_function = function() end)

Or be collision-aware with an onCollide callback

    -- not yet implemented
    entity.add(Mocos.Component.Collision, callback_function = function() end)