function love.load()
	love.graphics.setDefaultImageFilter("nearest", "nearest")
	
	require "class"
	require "menu"
	require "cloud"
	require "cloud2"
	require "bush"
	require "scene1"
	require "scene2"
	require "scene3"
	require "scene4"
	require "scene5"
	require "scene6"
	require "laser"
	require "enemy"
	require "explosion"
	require "bigexplosion"
	require "splatter"
	require "powerup"
	require "rocket"
	require "star"
	require "asteroid"
	require "bullet"
	require "bird"
	
	changegamestate("menu")
end

function love.update(dt)
	if skipupdate then
		skipupdate = false
		return
	end
	
	sunrot = sunrot + dt*50
	
	starttimer = starttimer + dt
	
	if scoreanim < 1 then
		scoreanim = scoreanim + (1-scoreanim)*8*dt
	end
	
	if laserdelay > 0 then
		laserdelay = math.max(0, laserdelay-dt)
	end
	
	shake = math.random()*shakeamount*2-shakeamount
	
	if _G[gamestate .. "_update"] then
		_G[gamestate .. "_update"](dt)
	end
	
	--LASERS
	local delete = {}
	
	for i, v in pairs(lasers) do
		if v:update(dt) == true then
			table.insert(delete, i)
		end
	end
	
	table.sort(delete, function(a,b) return a>b end)
	
	for i, v in pairs(delete) do
		table.remove(lasers, v) --remove
	end
end

function pointsget(i)
	points = points + i
	scoreanim = 0
	rainbowi = math.random()
	shakeamount = 10
end

function love.draw()
	love.graphics.translate(50*scale, 40*scale)
	love.graphics.rotate(shake/300)
	love.graphics.translate(-50*scale, -40*scale)
	
	love.graphics.translate(shake*scale/4, shake*scale/4)
	
	if _G[gamestate .. "_draw"] then
		_G[gamestate .. "_draw"]()
	end
	
	
	if gamestate ~= "menu" and gamestate ~= "scene6" and not landing then
		local r, g, b = unpack(getrainbowcolor(rainbowi))
		
		local ar = r + (255-r)*scoreanim
		local ag = g + (255-g)*scoreanim
		local ab = b + (255-b)*scoreanim
		
		love.graphics.setColor(ar, ag, ab)
		
		local s = scale*0.5+(1-scoreanim)*10
		love.graphics.rotate((1-scoreanim)*0.4)
		properprint("score: " .. points, 2, 2, s)
		love.graphics.rotate(-(1-scoreanim)*0.4)
	end
	
	love.graphics.translate(-shake*scale/4, -shake*scale/4)
	
	
	love.graphics.translate(50*scale, 40*scale)
	love.graphics.rotate(-shake/300)
	love.graphics.translate(-50*scale, -40*scale)
	if fade > 0 then
		love.graphics.setColor(255, 255, 255, 255*fade)
		love.graphics.rectangle("fill", 0, 0, 100*scale, 80*scale)
		love.graphics.setColor(255, 255, 255, 255)
	end
end

function love.keypressed(key, unicode)
    if key == 'escape' then
        love.event.quit()
    end
	if _G[gamestate .. "_keypressed"] then
		_G[gamestate .. "_keypressed"](key, unicode)
	end
	
	if key ~= "left" and key ~= "up" and key ~= "right" and key ~= "down" then
		if _G[gamestate .. "_action"] then
			_G[gamestate .. "_action"](key)
		end
	end
end

function love.keyreleased(key, unicode)
	if _G[gamestate .. "_keyreleased"] then
		_G[gamestate .. "_keyreleased"](key, unicode)
	end
end

function changegamestate(i)
	gamestate = i
    print("-- " .. gamestate)
	if _G[gamestate .. "_load"] then
		_G[gamestate .. "_load"]()
	end
end

function draw(drawable, x, y, r, sx, sy, ox, oy, kx, ky)
	if not sx then
		sx = 1
	end
	if not sy then
		sy = 1
	end
	love.graphics.draw(drawable, x*scale, y*scale, r, sx*scale, sy*scale, ox, oy, kx, ky )
end

function round(num, idp) --Not by me
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function properprint(s, x, y, sc)
	local sc = sc or scale
	local startx = x
	local skip = 0
	for i = 1, string.len(tostring(s)) do
		if skip > 0 then
			skip = skip - 1
		else
			local char = string.sub(s, i, i)
			if fontquads[char] then
				love.graphics.drawq(fontimage, fontquads[char], x*scale+((i-1)*8+1)*sc, y*scale, 0, sc, sc)
			end
		end
	end
end

function round(num, idp) --Not by me
	local mult = 10^(idp or 0)
	return math.floor(num * mult + 0.5) / mult
end

function getrainbowcolor(i, whiteness)
	local whiteness = whiteness or 255
	local r, g, b
	if i < 1/6 then
		r = 1
		g = i*6
		b = 0
	elseif i >= 1/6 and i < 2/6 then
		r = (1/6-(i-1/6))*6
		g = 1
		b = 0
	elseif i >= 2/6 and i < 3/6 then
		r = 0
		g = 1
		b = (i-2/6)*6
	elseif i >= 3/6 and i < 4/6 then
		r = 0
		g = (1/6-(i-3/6))*6
		b = 1
	elseif i >= 4/6 and i < 5/6 then
		r = (i-4/6)*6
		g = 0
		b = 1
	else
		r = 1
		g = 0
		b = (1/6-(i-5/6))*6
	end
	
	local add = 0
	if whiteness > 255 then
		add = whiteness-255
	end
	
	return {math.min(255, round(r*whiteness)+add), math.min(255, round(g*whiteness)+add), math.min(255, round(b*whiteness)+add), 255}
end
