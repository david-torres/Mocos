require 'Mocos'

Mocos:init(320, 480)
Mocos:background_color(255, 0, 0)

-- could easily use a background image instead
-- bg = Mocos:entity()
-- bg.add(Mocos.Components.Image, {image_path, width, height})

happy_face = {
    image_path = 'happy-face.png',
    width = 64,
    height = 64,
}

-- Click test
entity = Mocos:entity()
entity.add(Mocos.Components.Image, happy_face)
entity.get('prop'):setLoc(-50, 50)
entity.add(Mocos.Components.Click, function()
    print('Click Entity #1')
end)

-- Draggable test
entity2 = Mocos:entity()
entity2.add(Mocos.Components.Image, happy_face)
entity2.get('prop'):setLoc(50, 50)
entity2.add(Mocos.Components.Draggable)

-- Rect test
rect = {
    width = 64,
    height = 64,
    r = 130,
    g = 130,
    b = 130,
}
entity3 = Mocos.entity()
entity3.add(Mocos.Components.Rect, rect)
entity3.get('prop'):setLoc(-50, -50)
entity3.add(Mocos.Components.Click, function()
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
entity4 = Mocos:entity()
entity4.add(Mocos.Components.Circle, circle)
entity4.get('prop'):setLoc(50, -50)
entity4.add(Mocos.Components.Draggable)