function fib (num)
  if num < 2 then
    return 1
  end
  
  return fib(num - 1) + fib(num - 2)
end

function func(num)
  --return fib(math.floor(num))
  --return math.floor(math.exp(num, 2))
  return num
  --return math.floor(math.sin(num) * 4 + 5)
  --return math.floor(love.math.noise(num / 5) * 8 + 1)
end

function beep (tone)  
  local source = love.audio.newSource("/"..INSTRUMENT.."/"..tone..".mp3", "stream")
  
  source:play()
end

function love.load()
  SPEED = .2
  INSTRUMENT = 1
  
  particles = {}
  bodies = {}
  
  time = 0
  num = 1
  
  for i = 1, 200, 1 do
    table.insert(particles, {x = i * 4, y = 600, xv = 0, yv = -100, cap = 100, life = 0, active = true})
  end
  
  for i = 1, 10, 1 do
    for j = 1, 10, 1 do
      table.insert(bodies, {x = j * 80, y = i * 50, m = (math.random(1, 3) * 200 - 400) * 20})
    end
  end
end

function love.update(dt)
  if time > SPEED then    
    for k = 1, #tostring(func(num)), 1 do
      local offset = tonumber(string.sub(tostring(func(num)), k, k)) * 80
      
      beep(tonumber(string.sub(tostring(func(num)), k, k)) + 1)
    
      for j = 1, 20, 1 do
        for i = 1, 20, 1 do
          table.insert(particles, {x = i * 4 + offset, y = 600 + j, xv = 0, yv = -100, cap = 500, life = 0, active = true})
        end
      end
    end
    
    num = num + 1
    
    time = time - SPEED
  end
  
  for i, v in ipairs(particles) do
    if v.active then
      for j, k in ipairs(bodies) do
        local dx, dy = k.x - v.x, k.y - v.y
        local r = math.sqrt(dx * dx + dy * dy)
        dx, dy = dx / r, dy / r
        
        local mag = 0.06 * k.m / r / r
        dx, dy = dx * mag, dy * mag
        
        v.xv, v.yv = v.xv + dx, v.yv + dy
      end
      
      local dis = math.sqrt(v.xv * v.xv + v.yv * v.yv)
      v.xv, v.yv = v.xv / dis * v.cap * dt, v.yv / dis * v.cap * dt
      
      v.x, v.y = v.x + v.xv, v.y + v.yv
      
      v.life = v.life + dt
      
      if v.life > 5 / v.cap * 100 then
        v.active = false
      end
    end
  end
  
  time = time + dt
end

function love.keypressed(key)
  if key >= "0" and key <= "9" then
    local offset = tonumber(key) * 80
  
    for j = 1, 20, 1 do
      for i = 1, 20, 1 do
        table.insert(particles, {x = i * 4 + offset, y = 600 + j, xv = 0, yv = -100, cap = 500, life = 0, active = true})
      end
    end
  end
end

function love.draw()
  for i, v in ipairs(particles) do
    if v.active then
      love.graphics.setColor(v.life / 5 * v.cap / 100, 1, v.life / 2 * v.cap / 100, 1 - v.life / 5 * v.cap / 100)
      love.graphics.rectangle("fill", v.x, v.y, 2, 2)
    end
  end
  
  for i, v in ipairs(bodies) do
    --love.graphics.rectangle("line", v.x, v.y, 5, 5)
  end
end