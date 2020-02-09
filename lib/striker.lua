local Vector2 = include 'lib/vector2'

local Striker = {}
Striker.__index = Striker

local origin = Vector2:new()
local radius = 22

function rand_between(a,b)
  range = b - a
  total = math.random() * range
  return total - a
end

function Striker:new(angle, amplitude)
  local o = {}
  setmetatable(o, Striker)

  o.position = origin
  o.velocity = Vector2:new(rand_between(-0.05,0.05),rand_between(-0.05,0.05))
  o.amplitude = self:set_amplitude(amplitude)
  o.angle = self:set_angle(angle)
	return o
end

function Striker:set_angle(deg)
  self.angle = Vector2:new_from_deg_and_intensity(deg,1)
  self.angle:normalize()
  print(self.angle:tostring())
end

function Striker:set_amplitude(amp)
  -- takes a number from 1 to 20
  -- 20 should be '150% radius'
  local rad = amp/20
  self.amplitude = Vector2:new(rand_between(0, rad),rand_between(0, radius))
end

function Striker:apply_force(vec2)
  self.acceleration = self.acceleration:add(vec2)

  -- local dir = origin:sub(self.acceleration)
  -- dir:normalize()
  -- self.acceleration = self.acceleration:add(dir)
end

function Striker:halt()
  self.acceleration = Vector2:new(0,0)
end

function Striker:reset()
  self:halt()
  self.position = Vector2:new(0,0)
end

function Striker:tick()
  self.angle = self.angle:add(self.velocity)
  local x = math.sin(self.angle.x)*self.amplitude.x;
  local y = math.sin(self.angle.y)*self.amplitude.y;
  self.position = Vector2:new(x,y)
end

return Striker