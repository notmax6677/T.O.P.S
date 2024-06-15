# T.O.P.S
<ins><b>Physics Simulation Utilizing Verlet Integration</b></ins>

finish the todo list in the project first man !!!!

INSERT EDITED GIF HERE

Totally Operational Particle Simulation (or TOPS) is my first attempt at creating something similar to a physics engine/simulation, whilst utilizing [Verlet Integration](https://en.wikipedia.org/wiki/Verlet_integration). It isn't perfect, but I believe that it's a good introduction for me to gain a grasp at the mathematics at hand when programming physics related programs such as this. The program is built upon [LOVE2D](https://love2d.org) (specifically version 11.5, so I am not sure about its compatibility with future builds), so it only requires the LOVE interpreter to be run and otherwise is pretty much self contained without any other prerequisites.

My goal has been to learn from this so that in future projects where I may write similar functionality, I'll have a non-nullar foundation to begin with and can bring it to the next level of complexity and variation with more ease, and yeah thats all lol

## Usage Guide

Here is a quick but comprehensive guide to the usage of the physics simulation and how to interact with its environment, it can be a bit confusing at first, but I couldn't pass by the opportunity of creating the UI in the style that I enjoy using. Also I do admit that I could have improved upon the organization and presentation of the controls panels, but I hope you may forgive me for this haha

### <i> 1) Particle Creation </i>

To create a particle, you can simply right click with the mouse, and it will be instanced at the location of your cursor, as long as the cursor is within the boundaries of the box, which behaves as the "workspace". You may find the coordinates of your cursor within the box on the top right side of the window!

### <i> 2) The Gravity Pointer </i>

By holding the left mouse button, you can generate a gravitational force separate from the vertical gravitational force already present, which emanates from your cursor, this can attract particles towards its position and is just generally fun to play around with lol

### <i> 3) Changing the Particle Sizes </i>

You can change the set particle size - which represents the particle's radius - by simply turning your scroll wheel, there are maximum and minimum values for the particles to prevent some weird stuff from happening. All generated particles are always created with the currently set particle size. You may also notice that the crosshair-like cursor changes size with the currently set particle size values as a way of correlating the two, I thought it's pretty cool so yeah

### <i> LAST !!!!!!!!) Color-Coding Particles </i>

Well this one is simple, you can press C to toggle between the particles being colored or not, particles that are travelling at relatively high speeds appear to the red, lower speeds make them more blue-ish, static particles are always green and linked particles are always purple, it's really cool to be seeing all of the different colors on the workspace, but I understand that some may not like it, so I just added a feature to be able to toggle it around as you please!
