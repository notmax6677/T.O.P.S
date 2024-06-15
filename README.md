# T.O.P.S
Physics Simulation Utilizing Verlet Integration

INSERT EDITED GIF HERE

Totally Operational Physics Simulation (or TOPS) is my first attempt at creating something similar to a physics engine/simulation, whilst utilizing [Verlet Integration](https://en.wikipedia.org/wiki/Verlet_integration). It isn't perfect, but I believe that it's a good introduction for me to gain a grasp at the mathematics at hand when programming physics related programs such as this. The program is built upon [LOVE2D](love2d.org) (specifically version 11.5, so I am not sure about its compatibility with future builds), so it only requires the LOVE interpreter to be run and otherwise is pretty much self contained without any other prerequisites.

## Usage Guide

Here is a quick but comprehensive guide to the usage of the physics simulation and how to interact with its environment, it can be a bit confusing at first, but I couldn't pass by the opportunity of creating the UI in the style that I enjoy using. Also I do admit that I could have improved upon the organization and presentation of the controls panels, but I hope you may forgive me for this haha

### 1) Particle Creation

To create a particle, you can simply right click with the mouse, and it will be instanced at the location of your cursor, as long as the cursor is within the boundaries of the box, which behaves as the "workspace". You may find the coordinates of your cursor within the box on the top right side of the window!
