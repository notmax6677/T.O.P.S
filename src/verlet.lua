-- iPos - initial position
-- iVel - initial velocity
-- cAcc - current acceleration
-- lAcc - last acceleration
-- dt - deltatime
-- time - the particle's lifetime (calculated in frames)

-- shoutout to chatgpt for helping with this

function verlet(iPos, iVel, cAcc, lAcc, dt, time)

    -- calculate jerk with deltatime in mind
    local jerk = {
        (cAcc[1] - lAcc[1]) / dt,
        (cAcc[2] - lAcc[2]) / dt
    }

    -- calculate current position values
    current_pos_x = iPos[1] + iVel[1]*dt + 0.5*cAcc[1]*dt^2 + (1/6)*jerk[1]*dt^3 * time
    current_pos_y = iPos[2] + iVel[2]*dt + 0.5*cAcc[2]*dt^2 + (1/6)*jerk[2]*dt^3 * time

    -- calculate current velocity values
    current_vel_x = iVel[1] + cAcc[1] * 1 + 0.5 * jerk[1] * dt^2 * time
    current_vel_y = iVel[2] + cAcc[2] * 1 + 0.5 * jerk[2] * dt^2 * time

    -- return all 4 values in a packaged array
    return {current_pos_x, current_pos_y, current_vel_x, current_vel_y}

end
