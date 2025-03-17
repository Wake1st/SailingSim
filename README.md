# Sailing Sim

A simulation to show how it _feels_ to sail a boat.

## Dev Steps

- [x] accect inputs
  - [x] rudder control
  - [x] sail control
- [x] wind calculations
  - [x] generate wind -> vector
  - [x] get projection of wind onto the sail normal
- [x] kinematics
  - [x] pass sail projection into boat
  - [x] pass rudder into boat
- [x] animations
  - [x] animate wind direction and magnitude (flag)
  - [x] animate sail (parabolic bend of the mesh)

### Stretch Goals

- [x] applied realistic relative wind on boat
- [ ] use real aerodynamic forces instead of velocities
- [ ] tilt the boat
- [ ] calculate buoyancy
- [ ] basic waves

## Notes (thanks to Barrett Gaertner)

- <https://sailing-blog.nauticed.org/wp-content/uploads/2017/09/CatamaranPolarPlot.png>
- <https://www.wikihow.com/images/thumb/e/e5/Sail-a-Boat-Step-3-Version-3.jpg/v4-460px-Sail-a-Boat-Step-3-Version-3.jpg>
- <https://upload.wikimedia.org/wikipedia/commons/0/0b/Sunfish_rigged_for_sailing.jpg>
- <https://www.sailingworld.com/uploads/2021/09/screen_shot_2017-01-13_at_9.22.43_am_2.jpg>
- sculling: when in no wind zone, can flap to "paddle" forward a bit or turn
- jibe: when the sail flips sides of the boat really fast
- windward: side of the wind
- leeward: opposite side of the wind
- beam-reach is the fastest position (PI/2)
- rudder is hard to keep still
- balance is important when really windy
- when docking (leeward is better)
  - against the wind, must U-turn into wind
  - with wind, zig-zag
- a proper simulation needs a propper sail (a redesign is in order)

## User Stories

- [x] control the rudder with left/right bumpers
- [x] control the sail with the left stick
- [x] adapt to the wind for effectiveness
- [x] see the sail bend according the wind projection
- [x] read the wind using the flag
