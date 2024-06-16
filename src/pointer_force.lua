-- pointer data
pointer_pos = {0, 0}
pointer_on = false

-- the strength at which the pointer attracts particles
POINTER_FORCE_MULTIPLIER = 12

-- radius at which the force stops affecting the particles
POINTER_RADIUS = 20

-- update data of the mouse pointer
function update_pointer_force()
    -- check if mouse left button is down
    if love.mouse.isDown(1) then
        -- enable pointer force
        pointer_on = true

        -- update pointer position
        pointer_pos[1] = love.mouse.getX()
        pointer_pos[2] = love.mouse.getY()
    else
        -- disable pointer force
        pointer_on = false
    end
end