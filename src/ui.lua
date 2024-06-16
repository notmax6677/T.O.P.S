-- create new font object
font = love.graphics.newFont(12)

-- load ui-relevant stuff such as font
function load_ui()
    -- load and set new font
    font = love.graphics.newFont("assets/PoetsenOne-Regular.ttf", 12)
    love.graphics.setFont(font)

    -- disable mouse visibility
    love.mouse.setVisible(false)
end

-- brings together all of the ui functions into one
function draw_ui()
    draw_controls()

    draw_mouse()
end


-- draws all ui related to controls
function draw_controls()

    -- draw the box
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("line", BOX_X, BOX_Y*0.2, BOX_WIDTH, BOX_Y*0.6)


    -- draw the actual text

    -- controls label
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.print("CONTROLS:", BOX_X+10, BOX_Y*0.25)

    -- colored particles
    if colored_particles then
        love.graphics.setColor(0, 1, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print("[ Colored Particles - KEY C ]", BOX_X+10, BOX_Y*0.25 + 20)

    -- gravity pointer
    if pointer_on then
        love.graphics.setColor(1, 0.5, 0, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print("[ Gravity Pointer - LMB ]", BOX_X+10+148+12, BOX_Y*0.25 + 20)

    -- gravity pointer
    if love.mouse.isDown(2) then
        love.graphics.setColor(1, 0, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print("[ Create Particle - RMB ]", BOX_X+10+148+142+12, BOX_Y*0.25 + 20)

    -- particle size
    love.graphics.setColor(particle_size*2 / MAX_PARTICLE_SIZE, 1.0-particle_size / MAX_PARTICLE_SIZE, 0.8-particle_size / MAX_PARTICLE_SIZE, 1)
    love.graphics.print("[ Particle Size ("..particle_size..") - SCRLL WHL ]", BOX_X+10+148+142+142+12, BOX_Y*0.25 + 20)

    
    -- draw the second box
    love.graphics.setColor(0.2, 0.2, 0.2, 1)
    love.graphics.rectangle("line", BOX_X, BOX_Y+BOX_HEIGHT+BOX_Y*0.2, BOX_WIDTH, BOX_Y*0.6)

    -- second controls label
    love.graphics.setColor(0.5, 0.5, 0.5, 1)
    love.graphics.print("MORE CONTROLS:", BOX_X+10, BOX_Y+BOX_HEIGHT+BOX_Y*0.25)

    -- static particles mode
    if static_mode then
        love.graphics.setColor(0, 1, 0.2, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print("[ Static Mode - KEY S ]", BOX_X+10, BOX_Y+BOX_HEIGHT+BOX_Y*0.25 + 20)

    -- link mode
    if link_mode then
        love.graphics.setColor(1, 0, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    love.graphics.print("[ Link Mode - KEY L ]", BOX_X+10+128, BOX_Y+BOX_HEIGHT+BOX_Y*0.25 + 20)

    -- clearing particles
    if not clear_particles then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(245/255, 12/255, 86/255, 1)
    end
    love.graphics.print("[ Clear - BACKSPACE ]", BOX_X+10+128+116, BOX_Y+BOX_HEIGHT+BOX_Y*0.25 + 20)

    -- gravity
    if not gravity_mode then
        love.graphics.setColor(1, 1, 1, 1)
    else
        love.graphics.setColor(gravity*2 / MAX_GRAVITY, 1.0-gravity / MAX_GRAVITY, 0.8-gravity / MAX_GRAVITY, 1)
    end
    love.graphics.print("[ Gravity ("..gravity..") - KEY G + SCRLL WHL ]", BOX_X+10+128+116+124, BOX_Y+BOX_HEIGHT+BOX_Y*0.25 + 20)

    -- draw mouse coordinates
    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    
    local mX = love.mouse.getX() - BOX_X
    local mY = love.mouse.getY() - BOX_Y

    if mX < 0 or mX > BOX_WIDTH then
        mX = "N/A"
    end
    if mY < 0 or mY > BOX_HEIGHT then
        mY = "N/A"
    end

    love.graphics.print("X: "..mX, BOX_X+BOX_WIDTH+10, BOX_Y)
    love.graphics.print("Y: "..mY, BOX_X+BOX_WIDTH+10, BOX_Y+16)
end

-- draws the mouse cursor
function draw_mouse()
    love.graphics.setColor(255/255, 184/255, 69/255, 1)

    love.graphics.line(
        love.mouse.getX() + particle_size,
        love.mouse.getY(),
        love.mouse.getX() - particle_size,
        love.mouse.getY()
    )
    love.graphics.line(
        love.mouse.getX(),
        love.mouse.getY() + particle_size,
        love.mouse.getX(),
        love.mouse.getY() - particle_size
    )
end