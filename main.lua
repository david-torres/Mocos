require 'Basalt'

Basalt:init(320, 480)
Basalt:background_color(255, 0, 0)

-- could easily use a background image instead
-- bg = Basalt:entity()
-- bg.add(Basalt.Components.Image, {image_path, width, height})

happy_face = {
    image_path = 'happy-face.png',
    width = 64,
    height = 64,
}

-- Click test
entity = Basalt:entity()
entity.add(Basalt.Components.Image, happy_face)
entity.get('prop'):setLoc(-50, 50)
entity.add(Basalt.Components.Click, function()
    print('Click Entity #1')
end)

-- Draggable test
entity2 = Basalt:entity()
entity2.add(Basalt.Components.Image, happy_face)
entity2.get('prop'):setLoc(50, 50)
entity2.add(Basalt.Components.Draggable)

-- Rect test
rect = {
    width = 64,
    height = 64,
    r = 130,
    g = 130,
    b = 130,
}
entity3 = Basalt.entity()
entity3.add(Basalt.Components.Rect, rect)
entity3.get('prop'):setLoc(-50, -50)
entity3.add(Basalt.Components.Click, function()
    print('Click Entity #3')
end)

-- Circle test
circle = {
    radius = 32,
    steps = 16,
    r = 130,
    g = 130,
    b = 130,
}
entity4 = Basalt:entity()
entity4.add(Basalt.Components.Circle, circle)
entity4.get('prop'):setLoc(50, -50)
entity4.add(Basalt.Components.Draggable)