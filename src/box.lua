

-- sizes of box
BOX_WIDTH = 650
BOX_HEIGHT = 650

-- box position
BOX_X = (love.graphics.getWidth() - BOX_WIDTH)/2
BOX_Y = (love.graphics.getHeight() - BOX_HEIGHT)/2

-- force absorption - how much force does the box absorb when a particle collides with it
BOX_FORCE_ABSORPTION = 0.4 -- 60%


-- draw the box
function draw_box()
    love.graphics.setColor(0.2, 0.2, 0.2, 1)

    love.graphics.rectangle("line", BOX_X, BOX_Y, BOX_WIDTH, BOX_HEIGHT)
end