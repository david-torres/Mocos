--
-- Basalt, a high-level entity-component system for Moai SDK
--
Basalt = {
    -- shared bucket for component variables
    shared = {},

    -- event callback stacks
    mouseleft_callback_stack = {},
    pointer_callback_stack = {},

    -- common
    entities = {},
    decks = {},
    props = {},
}

--
-- Initialize the window, viewport, and base layer
-- @param int width The width of the window and viewport
-- @param int height The height of the window and viewport
-- @param string name The name of the window
--
function Basalt:init(width, height, name)

    if name == nil then
        name = 'Basalt'
    end
    MOAISim.openWindow(name, width, height)

    viewport = MOAIViewport.new()
    viewport:setSize(0, 0, width, height)
    viewport:setScale(width, height)

    layer = MOAILayer2D.new()
    layer:setViewport(viewport)
    MOAISim.pushRenderPass(layer)

    --
    -- mouse-left callback function
    -- calls all functions that have been registered as
    -- a mouse-left callback
    -- @param bool down True if the left mouse button is down
    --
    local mouseleft = function(down)
        for i = 1, #Basalt.mouseleft_callback_stack do
            Basalt.mouseleft_callback_stack[i](down)
        end
    end

    --
    -- pointer callback handler
    -- calls all functions that have been registered as a
    -- pointer callback
    -- @param int x,y The x,y coordinates of the pointer
    --
    local pointer = function(x, y)
        for i = 1, #Basalt.pointer_callback_stack do
            Basalt.pointer_callback_stack[i](x, y)
        end
    end

    MOAIInputMgr.device.mouseLeft:setCallback(mouseleft)
    MOAIInputMgr.device.pointer:setCallback(pointer)
end

--
-- Set a background fill color
-- @param int r Value from 0-255 representing red
-- @param int g Value from 0-255 representing green
-- @param int b Value from 0-255 representing blue
--
function Basalt:background_color(r, g, b)

    local color = MOAIColor.new()
    color:setColor(r, g, b, 1)
    MOAIGfxDevice.setClearColor(color)
end

--
-- Capture the current coordinates of the pointer
-- @return int x,y The x,y coordinates of the pointer
--
function Basalt:pointer_coords()
     return layer:wndToWorld(MOAIInputMgr.device.pointer:getLoc())
end



--
-- Components supported by Basalt
--
Basalt.Components = {}

--
-- Creates an image prop and adds it to the layer
-- @param table arg
-- @param table self
--
function Basalt.Components.Image(arg, self)

    local image_path = arg[2]['image_path']
    local width = arg[2]['width']
    local height = arg[2]['height']

    local width_half = width * 0.5
    local height_half = height * 0.5

    local deck = nil
    local prop = nil

    -- re-use deck if possible
    if Basalt.decks[image_path] == nil then
        deck = MOAIGfxQuad2D.new()
        deck:setTexture(image_path)
        deck:setRect(-width_half, -height_half, width_half, height_half)
        Basalt.decks[image_path] = deck
    else
        deck = Basalt.decks[image_path]
    end

    self.prop = MOAIProp2D.new()
    self.prop:setDeck(deck)
    layer:insertProp(self.prop)

    table.insert(Basalt.props, self.prop)
end

--
-- Creates a filled rectangle prop and adds it to the layer
-- @param table arg
-- @param table self
--
function Basalt.Components.Rect(arg, self)

    self.width = arg[2]['width']
    self.height = arg[2]['height']
    self.r = arg[2]['r']
    self.g = arg[2]['g']
    self.b = arg[2]['b']

    local x = self.width * 0.5
    local y = self.height * 0.5

    --
    -- onDraw callback that is executed when the prop is added to the layer
    --
    local draw_rect = function()
        MOAIGfxDevice.setPenColor(self.r/255, self.g/255, self.b/255, 1)
        MOAIDraw.fillRect(-x, -y, x, y)
    end

    -- TODO: reuse decks when possible
    local rect_deck = MOAIScriptDeck.new()
    rect_deck:setRect(-x, -y, x, y)
    rect_deck:setDrawCallback(draw_rect)
    table.insert(Basalt.decks, rect_deck)

    self.prop = MOAIProp2D.new()
    self.prop:setDeck(rect_deck)
    layer:insertProp(self.prop)

    table.insert(Basalt.props, self.prop)
end

--
-- Creates a filled circle prop and adds it to the layer
-- @param table arg
-- @param table self
--
function Basalt.Components.Circle(arg, self)

    self.radius = arg[2]['radius']
    self.steps = arg[2]['steps']
    self.r = arg[2]['r']
    self.g = arg[2]['g']
    self.b = arg[2]['b']

    --
    -- onDraw callback that is executed when the prop is added to the layer
    --
    local draw_circle = function()
        MOAIGfxDevice.setPenColor(self.r/255, self.g/255, self.b/255, 1)
        MOAIDraw.fillCircle(0, 0, self.radius, self.steps)
    end

    -- TODO: reuse decks when possible
    local circle_deck = MOAIScriptDeck.new()
    circle_deck:setRect(-64, -64, 64, 64)
    circle_deck:setDrawCallback(draw_circle)
    table.insert(Basalt.decks, circle_deck)

    self.prop = MOAIProp2D.new()
    self.prop:setDeck(circle_deck)
    layer:insertProp(self.prop)
    table.insert(Basalt.props, self.prop)
end

--
-- Registers a click event handler
-- @param table arg
-- @param table self
--
function Basalt.Components.Click(arg, self)
    if Basalt.shared.is_click_enabled ~= true then

        -- initialize Click Component
        Basalt.shared.is_click_enabled = true

        --
        -- checks for clickable entities and triggers callbacks if clicks 
        -- fall within bounds
        -- @param bool down True if the left mouse button is down
        --
        local click_func = function(down)
            if (down) or (isDown) then
                for i = 1, #Basalt.entities do
                    local e = Basalt.entities[i]
                    -- we have somthing clickable
                    if e.get('click') == true then
                        -- check bounds
                        local prop = e.get('prop')
                        local mouse_x, mouse_y = Basalt.pointer_coords()
                        if prop:inside(mouse_x, mouse_y) then
                            e.get('click_callback')()
                        end
                    end
                end
            end
        end

        table.insert(Basalt.mouseleft_callback_stack, click_func)
    end

    -- entity properties
    self.click = true
    self.click_callback = arg[2]
end

--
-- Registers a drag event handler
-- TODO: on_drag_start, on_drag, on_drag_stop callbacks
-- @param table arg
-- @param table self
--
function Basalt.Components.Draggable(arg, self)
    if Basalt.is_drag_enabled ~= true then

        -- initialize Draggable Component
        Basalt.shared.is_drag_enabled = true

        Basalt.shared.is_dragging = false
        Basalt.shared.last_x = 0
        Basalt.shared.last_y = 0

        --
        -- checks for draggable entities and triggers drag if within bounds
        -- @param bool down True if the left mouse button is down
        --
        local drag_left_click_event = function(down)
            -- check if we are dragging
            Basalt.shared.is_dragging = false
            if down or isDown then
                -- get current pointer position
                local mouse_x, mouse_y = Basalt:pointer_coords()

                -- check each entity
                for i = 1, #Basalt.entities do
                    local e = Basalt.entities[i]

                    -- if it has draggable
                    if e.get('draggable') == true then
                        local prop = e.get('prop')
                        -- and is within bounds
                        if prop:inside(mouse_x, mouse_y) then
                            Basalt.shared.is_dragging = true
                        end
                    end
                end
            end
        end

        --
        -- tracks the mouse move event
        -- @param int x X position of pointer
        -- @param int y Y position of pointer
        --
        local drag_mouse_move_event = function(x, y)
            -- check if we are dragging
            if Basalt.shared.is_dragging then

                local mouse_x, mouse_y = Basalt:pointer_coords()

                -- check each entity
                for i = 1, #Basalt.entities do
                    local e = Basalt.entities[i]

                    -- if it has draggable
                    if e.get('draggable') == true then
                        local prop = e.get('prop')
                        -- and is within bounds
                        if prop:inside(mouse_x, mouse_y) then
                            -- move the prop
                            local delta_x = x - Basalt.shared.last_x
                            local delta_y = y - Basalt.shared.last_y
                            prop:moveLoc(delta_x, -delta_y, 0, 0, MOAIEaseType.FLAT)
                        end
                    end
                end
            end

            Basalt.shared.last_x = x
            Basalt.shared.last_y = y
        end

        table.insert(Basalt.mouseleft_callback_stack, drag_left_click_event)
        table.insert(Basalt.pointer_callback_stack, drag_mouse_move_event)
    end

    -- entity properties
    self.draggable = true
    self.drop_callback = arg[2]
    self.last_x = 0
    self.last_y = 0
end

--
-- Registers a collide event handler
-- @param table arg
-- @param table self
--
function Basalt.Components.Collide(arg, self)
    -- TODO: implement this... Box2D?
end

--
-- The base entity
--
function Basalt:entity()
    --
    -- entity data goes in here
    --
    local self = {
        prop = nil,
    }

    --
    -- returns a value by key
    -- @param string n A key to lookup in the self table
    -- @return mixed
    --
    local get = function(n)
        return self[n]
    end

    --
    -- sets a value by key
    -- @param string n A key to set in the self table
    -- @param mixed value The value to set
    --
    local set = function(n, value)
        self[n] = value
    end

    --
    -- add a component to this entity
    -- @param variable This method accepts a variable number of arguments
    --
    local add = function(...)
        local component = arg[1]
        component(arg, self)
    end

    -- TODO: enable/disable components
    -- TODO: remove() components
    -- TODO: update() component messaging

    --
    -- build the entity to return
    --
    local e = {
        get = get,
        set = set,
        add = add,
    }

    -- add it to the list of known entities
    table.insert(Basalt.entities, e)

    return e
end
