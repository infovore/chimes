-- chimes

local Vector2 = include 'lib/vector2'

screen.aa(1)

screen_center = Vector2:new(64,32)

hammer_radius = 3

chime_count = 5
chime_circle_radius = 5
chime_radius = 22

noise_offset = Vector2.new(0,0)

function redraw()
  screen.clear()
  
  calc_hammer_pos = screen_center:add(hammer_pos)
  calc_hammer_pos = calc_hammer_pos:add(noise_offset)
  
  screen.move(calc_hammer_pos.x + hammer_radius, calc_hammer_pos.y)
  screen.circle(calc_hammer_pos.x, calc_hammer_pos.y, hammer_radius)
  screen.stroke()
  draw_chimes()
  screen.update()
end

function init()
  hammer_pos = Vector2:new(0,0)
  
  m = metro.init(metro_redraw,0.1)
  m:start()
  redraw()
end

function key(n,d)
  if(n == 2 and d== 1) then
    noise_offset = Vector2:new(0,0)
  end
end

function rand()
  return 2.0 * math.random()-1
end

function metro_redraw()
  random_vector = Vector2:new_from_deg_and_intensity(math.random()*360, math.random()*chime_radius)
  
  noise_offset = random_vector

  redraw()
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