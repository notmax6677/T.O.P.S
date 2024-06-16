-- array of particles
particles = {}
particle_count = 0

-- particle size
particle_size = 6
particle_size_change = 1
MAX_PARTICLE_SIZE = 20
MIN_PARTICLE_SIZE = 4

-- general settings --
gravity = 5
gravity_mode = false
MAX_GRAVITY = 10
MIN_GRAVITY = -10

TERMINAL_VEL = 1000 -- terminal velocity

-- the strength of rolling
ROLL_FACTOR = 50

-- color settings
colored_particles = true
RED_STRENGTH = 0.8

-- create particle cooldown vars and constants
create_particle_cooldown_count = 0
create_particle_cooldown_SPEED = 50
INITIAL_CREATE_PARTICLE_COOLDOWN = 50
create_particle_cooldown = 0

-- static mode
static_mode = false
STATIC_FORCE_ABSORPTION = 0.75 -- how much of the force do static particles absorb - 25% in this case

-- clear particles settings
clear_particles = false
clear_particles_count = 0
CLEAR_PARTICLES_COUNT_MAX = 0.5


-- creates a particle at given coordinates and adds it to the particles array
function create_particle(x, y)

    table.insert(particles, {
        pos = {x, y},
        vel = {0, 0},
        size = particle_size,

        static = static_mode,

        last_acceleration = {0, 0},

        time = 0,

        linked = false
    })

    particle_count = particle_count + 1

end


-- update particle movement
function update_particles(dt)

    -- change gravity mode based on whether g key is down or not
    if love.keyboard.isDown("g") then
        gravity_mode = true
    else
        gravity_mode = false
    end

    -- update particle cooldown based on current particle size
    create_particle_cooldown = INITIAL_CREATE_PARTICLE_COOLDOWN * (particle_size / MAX_PARTICLE_SIZE)

    -- incremement create particle cooldown count
    create_particle_cooldown_count = create_particle_cooldown_count + dt * create_particle_cooldown_SPEED

    -- if surpassed particle creation cooldown
    if create_particle_cooldown_count > create_particle_cooldown then
        -- if right mouse button is down
        if love.mouse.isDown(2) and (
            (love.mouse.getX() < BOX_X+BOX_WIDTH and love.mouse.getX() > BOX_X) and
            (love.mouse.getY() < BOX_Y+BOX_HEIGHT and love.mouse.getY() > BOX_Y)
        ) then

            -- if link mode is active then step forward in link creation
            if link_mode then
                link_step()

                -- reset particle creation cooldown count
                create_particle_cooldown_count = 0
            else -- otherwise
                -- create the particle at mouse coordinates (offset by 1 in random direction to make it seem a bit more "natural")
                create_particle(love.mouse.getX() + math.random(-1, 1), love.mouse.getY() + math.random(-1, 1))
                
                -- reset particle creation cooldown count
                create_particle_cooldown_count = 0
            end

        end
    end

    -- if particle deletion is on
    if clear_particles then
        -- increment clear particles by delta time
        clear_particles_count = clear_particles_count + dt

        -- if maximum clear particles count has been reached
        if clear_particles_count >= CLEAR_PARTICLES_COUNT_MAX then
            -- reset clear particles count to be reused
            clear_particles_count = 0

            -- clear all particles and links
            particles = {}
            links = {}

            -- reset particle count
            particle_count = 0

            -- reset clear particles to false
            clear_particles = false
        end
    end



    for i in ipairs(particles) do

        if not particles[i].static then

            -- increment time
            particles[i].time = particles[i].time + 1


            -- !!! CALCULATE CURRENT ACCELERATION !!! ---

            -- current acceleration and current jerk
            curr_acc = {0, 0}

            -- apply gravity
            curr_acc[2] = curr_acc[2] + gravity

            if pointer_on == true then
                -- apply pointer force by moving towards it - x axis

                -- thanks chatgpt for this calculation here!

                -- calculate the direction vector from particle to pointer
                local direction_x = pointer_pos[1] - particles[i].pos[1]
                local direction_y = pointer_pos[2] - particles[i].pos[2]

                -- normalize direction vector 
                local direction_length = math.sqrt(direction_x^2 + direction_y^2)

                if direction_length > 0 then
                    direction_x = direction_x / direction_length
                    direction_y = direction_y / direction_length
                end

                -- apply the pointer force by adding to the current acceleration
                curr_acc[1] = curr_acc[1] + direction_x * POINTER_FORCE_MULTIPLIER
                curr_acc[2] = curr_acc[2] + direction_y * POINTER_FORCE_MULTIPLIER
            end

            -- !!! FINISH CALCULATING CURRENT ACCELERATION !!! ---


            -- thanks chatgpt for writing this part for me im super lazy :)
            local magnitude = math.sqrt(particles[i].vel[1]^2 + particles[i].vel[2]^2)  -- calculate current velocity magnitude
            
            -- if magnitude (diagonal direction of velocity) is more than terminal velocity
            if magnitude > TERMINAL_VEL then
                -- find scale factor
                local scaleFactor = TERMINAL_VEL / magnitude

                -- cap velocity by multiplying by scale factor
                particles[i].vel[1] = particles[i].vel[1] * scaleFactor  
                particles[i].vel[2] = particles[i].vel[2] * scaleFactor
            end

            -- apply verlet integration
            output = verlet(
                particles[i].pos,
                particles[i].vel,
                curr_acc,
                particles[i].last_acceleration,
                dt,
                particles[i].time
            )

            -- update last acceleration
            particles[i].last_acceleration = curr_acc

            -- assign the particle's position and velocity to the verlet integration's output
            particles[i].pos = {output[1], output[2]}
            particles[i].vel = {output[3], output[4]}


            -- !!! APPLY CONSTRAINTS !!! ---

            -- check for collision with box and bounce back with less force

            -- x axis rebound
            if (particles[i].pos[1] + particles[i].size >= BOX_X+BOX_WIDTH) then -- right

                particles[i].pos[1] = BOX_X+BOX_WIDTH - particles[i].size -- set x position to right wall
                particles[i].vel[1] = -particles[i].vel[1] * BOX_FORCE_ABSORPTION -- reverse velocity with less force

            elseif (particles[i].pos[1] - particles[i].size <= BOX_X) then -- left

                particles[i].pos[1] = BOX_X + particles[i].size -- set x position to left wall
                particles[i].vel[1] = -particles[i].vel[1] * BOX_FORCE_ABSORPTION -- reverse velocity with less force

            end

            -- y axis rebound
            if (particles[i].pos[2] + particles[i].size >= BOX_Y+BOX_HEIGHT) then -- bottom

                particles[i].pos[2] = BOX_Y+BOX_HEIGHT - particles[i].size -- set y position to bottom wall
                particles[i].vel[2] = -particles[i].vel[2] * BOX_FORCE_ABSORPTION -- reverse velocity with less force
            
            elseif (particles[i].pos[2] - particles[i].size <= BOX_Y) then -- top

                particles[i].pos[2] = BOX_Y + particles[i].size -- set y position to top wall
                particles[i].vel[2] = -particles[i].vel[2] * BOX_FORCE_ABSORPTION -- reverse velocity with less force
            
            end

            -- check for collision with each other
            for p in ipairs(particles) do
                -- if not the same particle index
                if i ~= p then
                    -- get x distance (keeping velocity in check too)
                    x_dist = math.abs( ( particles[i].pos[1] + particles[i].vel[1]*dt ) - ( particles[p].pos[1] + particles[p].vel[1]*dt ) )

                    -- get y distance (keeping velocity in check too)
                    y_dist = math.abs( ( particles[i].pos[2] + particles[i].vel[2]*dt ) - ( particles[p].pos[2] + particles[p].vel[2]*dt ) )

                    -- get proper distance between the two centres (pythagoras theorem)
                    distance = math.sqrt(x_dist^2 + y_dist^2)
                    dx = particles[p].pos[1] - particles[i].pos[1]
                    dy = particles[p].pos[2] - particles[i].pos[2]

                    -- get total velocity
                    total_vel_x = math.abs(particles[i].vel[1]) + math.abs(particles[p].vel[1])
                    total_vel_y = math.abs(particles[i].vel[2]) + math.abs(particles[p].vel[2])

                    -- if the distance is less than the two radius' added together
                    if distance < particles[i].size+particles[p].size then

                        -- if particle p is static
                        if particles[p].static then

                            -- thanks to chatgpt for these formulas

                            -- calculate normal vector
                            local normal = {dx / distance, dy / distance}
                            local dot_product = particles[i].vel[1] * normal[1] + particles[i].vel[2] * normal[2]
                            particles[i].vel[1] = particles[i].vel[1] - 2 * dot_product * normal[1]
                            particles[i].vel[2] = particles[i].vel[2] - 2 * dot_product * normal[2]

                            -- apply absorption factor
                            particles[i].vel[1] = particles[i].vel[1] * STATIC_FORCE_ABSORPTION
                            particles[i].vel[2] = particles[i].vel[2] * STATIC_FORCE_ABSORPTION

                        else -- otherwise

                            -- get ratio of mass (size)
                            i_mass_ratio = particles[p].size / particles[i].size * 0.5
                            p_mass_ratio = particles[i].size / particles[p].size * 0.5

                            -- in this next bit, i split the velocity in half and distribute it evenly between them
                            -- in different directions based on their positioning

                            -- if particle i is on the left of particle p
                            if particles[i].pos[1] < particles[p].pos[1] then
                                -- make particle i go left and particle p go right
                                particles[i].vel[1] = -(total_vel_x/2) * i_mass_ratio
                                particles[p].vel[1] = total_vel_x/2 * p_mass_ratio
                            else
                                -- vice versa
                                particles[p].vel[1] = -(total_vel_x/2) * p_mass_ratio
                                particles[i].vel[1] = total_vel_x/2 * i_mass_ratio
                            end

                            -- if particle i is above particle p
                            if particles[i].pos[2] < particles[p].pos[2] then
                                -- make particle i go up and particle p go down
                                particles[i].vel[2] = -(total_vel_y/2) * i_mass_ratio
                                particles[p].vel[2] = total_vel_y/2 * p_mass_ratio
                            else
                                -- vice versa
                                particles[p].vel[2] = -(total_vel_y/2) * p_mass_ratio
                                particles[i].vel[2] = total_vel_y/2 * i_mass_ratio
                            end


                        end

                        -- this next part is for the rolling effect between particles

                        -- if they arent approximately on the same axis value
                        if not (
                            particles[i].pos[1] - particles[i].size > particles[p].pos[1] - particles[p].size - 2
                            and
                            particles[i].pos[1] + particles[i].size < particles[p].pos[1] + particles[p].size + 2
                            or
                            particles[i].pos[2] - particles[i].size > particles[p].pos[2] - particles[p].size - 2
                            and
                            particles[i].pos[2] + particles[i].size < particles[p].pos[2] + particles[p].size + 2
                        ) then

                            -- get perpendicular gradient of line that is normal to the line between particle centres
                            perp_gradient = (particles[p].pos[1] - particles[i].pos[1]) / (particles[p].pos[2] - particles[i].pos[2])

                            -- Adjust velocities based on perpendicular gradient
                            particles[i].vel[1] = particles[i].vel[1] + perp_gradient * ROLL_FACTOR
                        end


                        -- run verlet again
                        output = verlet(
                            particles[i].pos,
                            particles[i].vel,
                            curr_acc,
                            particles[i].last_acceleration,
                            dt,
                            particles[i].time
                        )

                        -- update last acceleration
                        particles[i].last_acceleration = curr_acc

                        -- assign the particle's position and velocity to the verlet integration's output
                        particles[i].pos = {output[1], output[2]}
                        particles[i].vel = {output[3], output[4]}

                    end
                end
            end

        end

        --- !!! FINISH APPLYING CONSTRAINTS !!! ---

    end

end


-- draws all current particles
function draw_particles()
    for i in ipairs(particles) do

        if not colored_particles then
            love.graphics.setColor(1, 1, 1, 1)
        
            love.graphics.circle("fill", particles[i].pos[1], particles[i].pos[2], particles[i].size)
        elseif particles[i].static then
            love.graphics.setColor(0, 1, 0.2, 1)
        
            love.graphics.circle("fill", particles[i].pos[1], particles[i].pos[2], particles[i].size)
        elseif particles[i].linked then
            love.graphics.setColor(1, 0, 1, 1)
        
            love.graphics.circle("fill", particles[i].pos[1], particles[i].pos[2], particles[i].size)
        else
            strength = (math.abs(particles[i].vel[1]) + math.abs(particles[i].vel[2])) / TERMINAL_VEL * RED_STRENGTH

            love.graphics.setColor(strength, 0.8 - strength, 1 - strength, 1)

            love.graphics.circle("fill", particles[i].pos[1], particles[i].pos[2], particles[i].size)
        end

    end
end

