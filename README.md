# Sailing Sim

A simulation to show how it _feels_ to sail a boat.

## Dev Notes

- [x] accect inputs
  - [x] rudder control
  - [x] sail control
- [x] wind calculations
  - [x] generate wind -> vector
  - [x] get projection of wind onto the sail normal
- [x] kinematics
  - [x] pass sail projection into boat
  - [x] pass rudder into boat
- [ ] animations
  - [ ] animate wind direction and magnitude (flag)
  - [ ] animate sail (parabolic bend of the mesh)

### Stretch

- [ ] use real forces instead of velocities
- [ ] tilt the boat
- [ ] calculate buoyancy
- [ ] basic waves

## User Stories

- [x] control the rudder with left/right bumpers
- [x] control the sail with the left stick
- [x] adapt to the wind for effectiveness
- [ ] read the wind using the flag
- [ ] see the sail bend according the wind projection
