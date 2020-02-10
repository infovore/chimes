-- chimes

local Vector2 = include 'lib/vector2'
local Striker = include 'lib/striker'

screen.aa(1)

screen_center = Vector2:new(64,32)

striker_radius = 3

chime_count = 5
chime_circle_radius = 5
chime_radius = 22

origin = Vector2.new(0,0)

bpm = 120
alt = false

wind = {direction= 270, intensity = 2}
striker = Striker:new(wind.direction, wind.intensity)

function init()
  m = metro.init(metro_update, 6.0/bpm)
  m:start()
    
  screen_m = metro.init(metro_redraw)
  screen_m:start(1.0/60)
  
  redraw()
end

function metro_update()
  striker:tick()
end

function metro_redraw()
  redraw()
end

function redraw()
  screen.clear()
  
  calc_striker_pos = screen_center:add(striker.position)
  
  screen.move(calc_striker_pos.x + striker_radius, calc_striker_pos.y)
  screen.circle(calc_striker_pos.x, calc_striker_pos.y, striker_radius)
  screen.stroke()

  draw_chimes()
  draw_wind_arrow()

  screen.move(0,10)
  screen.text(bpm)
  
  screen.update()
end

function key(n,z)
  if n==1 then
    alt = z==1
  elseif(n == 2 and z== 1) then
    noise_offset = Vector2:new(0,0)
    striker:reset()
  end
end

function enc(n,d)
  if(n==1) then
    bpm = bpm+d
    m.time = 6.0/bpm
  elseif (n==2) then
    if alt then
      chime_count = util.clamp(chime_count + d, 3, 12)
    else
      wind.direction = (wind.direction + d) % 360
      striker:set_angle(wind.direction)
    end
  elseif (n==3) then
    wind.intensity = (wind.intensity + d)
    wind.intensity = util.clamp(wind.intensity,1,20)
    striker:set_velocity_mult(wind.intensity/20.0)
    striker:set_rad(wind.intensity/20.0* 35)
  end
end

function draw_chimes()
  local chime_pos = Vector2:new(0,0-chime_radius)
  chime_rotation = 360.0 / chime_count
  
  for i = 1,chime_count do
    calc_chime_pos = chime_pos:rotate(chime_rotation * i-1)
    calc_chime_pos = calc_chime_pos:add(screen_center)
    
    screen.move(calc_chime_pos.x, calc_chime_pos.y)
    screen.circle(calc_chime_pos.x, calc_chime_pos.y, chime_circle_radius)
    screen.fill()
  end
end

function draw_wind_arrow()
  arrow_length = 10.0
  
  arrow_end = Vector2:new(0,wind.intensity/2)
  arrow_tip = Vector2:new(0,0-(wind.intensity/2))
  blade_1 = Vector2:new(-3,(0-(wind.intensity/2))+3)
  blade_2 = Vector2:new(3,(0-(wind.intensity/2))+3)
  
  offset = Vector2:new(52,20)
  
  arrow_tip = arrow_tip:rotate(0-wind.direction+90):add(screen_center):add(offset)
  arrow_end = arrow_end:rotate(0-wind.direction+90):add(screen_center):add(offset)
  blade_1 = blade_1:rotate(0-wind.direction+90):add(screen_center):add(offset)
  blade_2 = blade_2:rotate(0-wind.direction+90):add(screen_center):add(offset)
  
  screen.move(arrow_end.x, arrow_end.y)
  screen.line(arrow_tip.x, arrow_tip.y)
  screen.line(blade_1.x,blade_1.y)
  screen.move(arrow_tip.x, arrow_tip.y)
  screen.line(blade_2.x, blade_2.y)
  screen.stroke()
  
  screen.move(128,40)
  screen.text_right(((wind.direction-270) % 360 .. "º"))
end