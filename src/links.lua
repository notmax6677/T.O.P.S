-- array to store links
links = {}

-- mode to link particles
link_mode = false

-- last chosen particle
last_chosen = 0

-- creates a fixed size link between two particles
function create_link(p1, p2)
    table.insert(links, {
        p1,
        p2,
        size = math.sqrt( -- pythagoras theorem to find distance and that will be the constant size between the two particles
            math.abs(particles[p1].pos[1] - particles[p2].pos[1])*math.abs(particles[p1].pos[1] - particles[p2].pos[1])
            +
            math.abs(particles[p1].pos[2] - particles[p2].pos[2])*math.abs(particles[p1].pos[2] - particles[p2].pos[2])
        )
    })

    -- activate linked booleans in both particles
    particles[p1].linked = true
    particles[p2].linked = true

end

-- step forward in link creation
function link_step()

    found = false

    for i in ipairs(particles) do
    
        -- get distance between mouse and centre of particle
        local dist = math.sqrt(
            math.abs(love.mouse.getX() - particles[i].pos[1])^2
            +
            math.abs(love.mouse.getY() - particles[i].pos[2])^2
        )

        -- if distance is smaller than the radius of the particle
        -- that means that the mouse is inside of the particle so it is chosen
        if dist <= particles[i].size then
            
            if last_chosen == 0 then
                last_chosen = i
            else
                create_link(last_chosen, i)
                last_chosen = 0
            end

            found = true
        end

    end

    if not found then
        last_chosen = 0
        link_mode = false
    end

end

function update_links(dt)

    -- iterate thru links array
    for i in ipairs(links) do
        
        -- calculate distance between two particles
        dist = math.sqrt( -- pythagoras theorem to find distance between both particles
            math.abs(particles[links[i][1]].pos[1] - particles[links[i][2]].pos[1])*math.abs(particles[links[i][1]].pos[1] - particles[links[i][2]].pos[1])
            +
            math.abs(particles[links[i][1]].pos[2] - particles[links[i][2]].pos[2])*math.abs(particles[links[i][1]].pos[2] - particles[links[i][2]].pos[2])
        )

        -- distance is longer than link size
        if dist ~= links[i].size then

            -- calculate interpolation ratio
            interpolation_ratio = 1-links[i].size / dist

            -- if both particles arent static, then move both of them halfway towards each other
            if not particles[links[i][1]].static and not particles[links[i][2]].static then

                -- particle 1 increase
                new_p1_pos_x_inc = (particles[links[i][2]].pos[1] - particles[links[i][1]].pos[1])*interpolation_ratio
                new_p1_pos_y_inc = (particles[links[i][2]].pos[2] - particles[links[i][1]].pos[2])*interpolation_ratio
    
                -- particle 2 increase
                new_p2_pos_x_inc = (particles[links[i][1]].pos[1] - particles[links[i][2]].pos[1])*interpolation_ratio
                new_p2_pos_y_inc = (particles[links[i][1]].pos[2] - particles[links[i][2]].pos[2])*interpolation_ratio
    
                -- move particle 1 halfway
                particles[links[i][1]].pos[1] = particles[links[i][1]].pos[1] + new_p1_pos_x_inc * 0.5
                particles[links[i][1]].pos[2] = particles[links[i][1]].pos[2] + new_p1_pos_y_inc * 0.5
    
                -- move particle 2 halfway
                particles[links[i][2]].pos[1] = particles[links[i][2]].pos[1] + new_p2_pos_x_inc * 0.5
                particles[links[i][2]].pos[2] = particles[links[i][2]].pos[2] + new_p2_pos_y_inc * 0.5

            -- if particle 1 is static but particle 2 isnt, then only move particle 2
            elseif particles[links[i][1]].static and not particles[links[i][2]].static then

                -- particle 2 increase
                new_p2_pos_x_inc = (particles[links[i][1]].pos[1] - particles[links[i][2]].pos[1])*interpolation_ratio
                new_p2_pos_y_inc = (particles[links[i][1]].pos[2] - particles[links[i][2]].pos[2])*interpolation_ratio

                -- move particle 2 all the way
                particles[links[i][2]].pos[1] = particles[links[i][2]].pos[1] + new_p2_pos_x_inc
                particles[links[i][2]].pos[2] = particles[links[i][2]].pos[2] + new_p2_pos_y_inc

            -- if particle 2 is static but particle 1 isnt, then only move particle 1
            elseif not particles[links[i][1]].static and particles[links[i][2]].static then

                -- particle 1 increase
                new_p1_pos_x_inc = (particles[links[i][2]].pos[1] - particles[links[i][1]].pos[1])*interpolation_ratio
                new_p1_pos_y_inc = (particles[links[i][2]].pos[2] - particles[links[i][1]].pos[2])*interpolation_ratio

                -- move particle 1 all the way
                particles[links[i][1]].pos[1] = particles[links[i][1]].pos[1] + new_p1_pos_x_inc
                particles[links[i][1]].pos[2] = particles[links[i][1]].pos[2] + new_p1_pos_y_inc

            end

            -- check if particle 1 is inside of any other particle
            for p2 in ipairs(particles) do

                -- get distance
                local dist = math.sqrt(
                    math.abs(particles[links[i][1]].pos[1] - particles[p2].pos[1])^2
                    +
                    math.abs(particles[links[i][1]].pos[2] - particles[p2].pos[2])^2
                )
                
                -- if inside of one another
                if dist < particles[links[i][1]].size + particles[p2].size and links[i][1] ~= p2 and not particles[links[i][1]].static and particles[p2].static then

                    -- just repeat 2 times
                    for _=0, 2 do
                        -- apply verlet integration
                        local output = verlet(
                            particles[links[i][1]].pos,
                            particles[links[i][1]].vel,
                            {0, 0},
                            particles[links[i][1]].last_acceleration,
                            dt,
                            particles[links[i][1]].time
                        )
                        -- apply new pos and vel
                        particles[links[i][1]].pos = {output[1], output[2]}
                        particles[links[i][1]].vel = {output[3], output[4]}

                    end

                end
            end

            -- repeat for particle 2:

            -- check if particle 2 is inside of any other particle
            for p2 in ipairs(particles) do

                -- get distance
                local dist = math.sqrt(
                    math.abs(particles[links[i][2]].pos[1] - particles[p2].pos[1])^2
                    +
                    math.abs(particles[links[i][2]].pos[2] - particles[p2].pos[2])^2
                )
                
                -- if inside of one another
                if dist < particles[links[i][2]].size + particles[p2].size and links[i][2] ~= p2 and not particles[links[i][2]].static and particles[p2].static then

                    -- just repeat 5 times
                    for _=0, 2 do
                        -- apply verlet integration
                        local output = verlet(
                            particles[links[i][2]].pos,
                            particles[links[i][2]].vel,
                            {0, 0},
                            particles[links[i][2]].last_acceleration,
                            dt,
                            particles[links[i][2]].time
                        )
                        -- apply new pos and vel
                        particles[links[i][2]].pos = {output[1], output[2]}
                        particles[links[i][2]].vel = {output[3], output[4]}

                    end

                end
            end

            

        end

    end

end

function draw_links()
    if colored_particles then
        love.graphics.setColor(1, 0, 1, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- iterate thru links array
    for i in ipairs(links) do
    
        -- draw line between them
        love.graphics.line(
            particles[links[i][1]].pos[1], particles[links[i][1]].pos[2],
            particles[links[i][2]].pos[1], particles[links[i][2]].pos[2]
        )

    end

    if last_chosen ~= 0 and link_mode then
        -- draw line between them
        love.graphics.line(
            love.mouse.getX(), love.mouse.getY(),
            particles[last_chosen].pos[1], particles[last_chosen].pos[2]
        )
    end
end