-- vec2 type class

local Vector2 = {}
Vector2.__index = Vector2

function Vector2:new(paramsOrX, y)
  local o = {}
  setmetatable(o, Vector2)
  
  if type(paramsOrX) == "number" then
		o.x = paramsOrX or 0
		o.y = y         or 0
	else
		local p = paramsOrX or {}
		o.x = p.x or 0
		o.y = p.y or 0
	end
	
	return o
end


function Vector2:copy ()
	return Vector2:new(self.x,self.y)
end

function Vector2:tostring ()
	return string.format("<Vector2 %f, %f>", self.x, self.y)
end

function Vector2:eq (other)
	return self.x == other.x and self.y == other.y
end

function Vector2:add (other)
	return Vector2:new(self.x + other.x, self.y + other.y)
end

function Vector2:sub (other)
	return Vector2:new((self.x - other.x), (self.y - other.y))
end

function Vector2:mul (value)
	return Vector2:new((self.x * value), (self.y * value))
end

function Vector2:div (value)
	return Vector2:new(self.x / value, self.y / value)
end

function Vector2:zero ()
	self.x = 0
	self.y = 0
end

function Vector2:isZero ()
	return self.x == 0 and self.y == 0
end

function Vector2:length ()
	return math.sqrt((self.x ^ 2) + (self.y ^ 2))
end

function Vector2:lengthSq ()
	return (self.x ^ 2) + (self.y ^ 2)
end

function Vector2:normalize ()
	local length = self:length()
	if length > 0 then
		self.x = self.x / length
		self.y = self.y / length
	end
end

function Vector2:dot (other)
	return (self.x * other.x) + (self.y * other.y)
end

function Vector2:perp ()
	return Vector2:new(-self.y, self.x)
end

function Vector2:rotate(degrees)
  sin_of_rotation = math.sin(math.rad(degrees))
  cos_of_rotation = math.cos(math.rad(degrees))
  
  tempx = self.x
  tempy = self.y
  
  newx = (cos_of_rotation * tempx) - (sin_of_rotation * tempy)
  newy = (sin_of_rotation * tempx) - (cos_of_rotation * tempy)
  
  return Vector2:new(newx,newy)
end

function Vector2:new_from_deg_and_intensity (angle, intensity)
  return Vector2:new_from_rad_and_intensity(math.rad(angle), intensity)
end

function Vector2:new_from_rad_and_intensity(angle,intensity)
  v = Vector2:new(math.cos(angle), math.sin(angle))
  return v:mul(intensity)
end


return Vector2