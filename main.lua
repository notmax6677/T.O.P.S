require "src.particles"
require "src.links"
require "src.box"
require "src.pointer_force"
require "src.ui"

require "src.verlet"

-- load function
function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")

    love.window.setIcon(love.image.newImageData("assets/icon.png"))

    load_ui()
end

-- update function
function love.update(dt)
    update_pointer_force()

    update_particles(dt)

    update_links(dt)

    -- update title of program with amount of particles
    love.window.setTitle("T.O.P.S Particle Physics | Particle Count: "..particle_count)
end

-- draw function
function love.draw()
    love.graphics.clear(0.1, 0.1, 0.1)

    draw_box()

    draw_links()

    draw_particles()

    draw_ui()
end


-- keyboard buttons that are only pressed
function love.keypressed(key, isrepeat)

    if key == "c" then
        colored_particles = not colored_particles
    elseif key == "s" then
        static_mode = not static_mode
    elseif key == "l" then
        link_mode = not link_mode
    elseif key == "backspace" then
        clear_particles = true
    end

end


function love.wheelmoved(x, y)

    if gravity_mode then
        -- wheel moved up
        if y > 0 and gravity < MAX_GRAVITY then
            gravity = gravity + 1
        -- wheel moved down
        elseif y < 0 and gravity > MIN_GRAVITY then
            gravity = gravity - 1
        end
    else
        -- wheel moved up
        if y > 0 and particle_size < MAX_PARTICLE_SIZE then
            particle_size = particle_size + particle_size_change
        -- wheel moved down
        elseif y < 0 and particle_size > MIN_PARTICLE_SIZE then
            particle_size = particle_size - particle_size_change
        end
    end

end