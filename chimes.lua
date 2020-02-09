-- chimes

local Vector2 = include 'lib/vector2'

screen.aa(1)

screen_center = Vector2:new(64,32)

hammer_radius = 3

chime_count = 5
chime_circle_radius = 5
chime_radius = 22

noise_offset = Vector2.new(0,0)

bpm = 120
alt = false

wind_direction = 180
wind_intensity = 10

function init()
  hammer_pos = Vector2:new(0,0)
  
  m = metro.init(metro_update, 6.0/bpm)
  m:start()
    
  screen_m = metro.init(metro_redraw)
  screen_m:start(1.0/60)
  
  redraw()
end

function key(n,z)
  if n==1 then
    alt = z==1
  elseif(n == 2 and z== 1) then
    noise_offset = Vector2:new(0,0)
  end
end

function metro_redraw()
  redraw()
end

function redraw()
  screen.clear()
  
  calc_hammer_pos = screen_center:add(hammer_pos)
  calc_hammer_pos = calc_hammer_pos:add(noise_offset)
  
  screen.move(calc_hammer_pos.x + hammer_radius, calc_hammer_pos.y)
  screen.circle(calc_hammer_pos.x, calc_hammer_pos.y, hammer_radius)
  screen.stroke()
  draw_chimes()
  
  draw_wind()

  screen.move(0,10)
  screen.text(bpm)
  
  screen.update()
end

function enc(n,d)
  if(n==1) then
    bpm = bpm+d
    m.time = 6.0/bpm
  elseif (n==2) then
    print(alt)
    if alt then
      chime_count = util.clamp(chime_count + d, 3, 12)
    else
      wind_direction = (wind_direction + d) % 360
    end
  elseif (n==3) then
    wind_intensity = (wind_intensity + d)
    wind_intensity = util.clamp(wind_intensity,2,15)
  end
end

function rand()
  return 2.0 * math.random()-1
end

function metro_update()
  random_vector = Vector2:new_from_deg_and_intensity(math.random()*360, math.random()*chime_radius)
  
  noise_offset = random_vector
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

function draw_wind()
  arrow_length = 10.0
  
  arrow_end = Vector2:new(0,wind_intensity/2)
  arrow_tip = Vector2:new(0,0-(wind_intensity/2))
  blade_1 = Vector2:new(-3,(0-(wind_intensity/2))+3)
  blade_2 = Vector2:new(3,(0-(wind_intensity/2))+3)
  
  offset = Vector2:new(52,20)
  
  arrow_tip = arrow_tip:rotate(0-wind_direction):add(screen_center):add(offset)
  arrow_end = arrow_end:rotate(0-wind_direction):add(screen_center):add(offset)
  blade_1 = blade_1:rotate(0-wind_direction):add(screen_center):add(offset)
  blade_2 = blade_2:rotate(0-wind_direction):add(screen_center):add(offset)
  
  screen.move(arrow_end.x, arrow_end.y)
  screen.line(arrow_tip.x, arrow_tip.y)
  screen.line(blade_1.x,blade_1.y)
  screen.move(arrow_tip.x, arrow_tip.y)
  screen.line(blade_2.x, blade_2.y)
  screen.stroke()
  
  screen.move(128,44)
  screen.text_right((wind_direction+180) % 360)
end