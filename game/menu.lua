function menu_load()
	imagelist = {"title", "cloud1", "cloud2", "ground", "bush1", "bush2", "powerup", "rocket", "star", "asteroid-big1", "sunglasses", "awesome", "arrow", "groundwin",
				"asteroid-big2", "asteroid-small1", "asteroid-small2", "bullet", "littleexplosion", "warning", "wheatley", "alert", "randomshit", "bird"}
	
	for i = 1, #imagelist do
		_G[imagelist[i] .. "img"] = love.graphics.newImage("graphics/" .. imagelist[i] .. ".png")
	end
	
	fontimage = love.graphics.newImage("graphics/font.png")
	
	fontglyphs = "0123456789abcdefghijklmnopqrstuvwxyz.:/,'C-_>* !{}?"
	fontquads = {}
	for i = 1, string.len(fontglyphs) do
		fontquads[string.sub(fontglyphs, i, i)] = love.graphics.newQuad((i-1)*8, 0, 8, 8, 408, 8)
	end

	playerimg = love.graphics.newImage("graphics/trosh.png")
	playerquad = {love.graphics.newQuad(0, 0, 14, 25, 54, 25), love.graphics.newQuad(14, 0, 14, 25, 54, 25), love.graphics.newQuad(28, 0, 26, 12, 54, 25), love.graphics.newQuad(28, 12, 26, 12, 54, 25)}
	
	winplayerimg = love.graphics.newImage("graphics/troshwin.png")
	winplayerquad = {}
	for x = 1, 4 do
		winplayerquad[x] = love.graphics.newQuad((x-1)*11, 0, 11, 26, 44, 26)
	end
	
	enemyimg = love.graphics.newImage("graphics/enemy.png")
	enemyquad = {}
	for y = 1, 4 do
		for x = 1, 4 do
			enemyquad[(y-1)*4+x] = love.graphics.newQuad((x-1)*100, (y-1)*96, 100, 96, 400, 384)
		end
	end
	
	explosionimg = love.graphics.newImage("graphics/explosion.png")
	explosionquad = {}
	for y = 1, 5 do
		for x = 1, 5 do
			explosionquad[(y-1)*5+x] = love.graphics.newQuad((x-1)*66, (y-1)*81, 66, 81, 330, 405)
		end
	end
	
	bigexplosionimg = love.graphics.newImage("graphics/bigexplosion.png")
	bigexplosionquad = {}
	for y = 1, 5 do
		for x = 1, 5 do
			bigexplosionquad[(y-1)*5+x] = love.graphics.newQuad((x-1)*108, (y-1)*121, 108, 121, 540, 605)
		end
	end
	
	splatterimg = love.graphics.newImage("graphics/splatter.png")
	splatterquad = {}
	for x = 1, 6 do
		splatterquad[x] = love.graphics.newQuad((x-1)*64, 0, 64, 64, 384, 64)
	end
	
	birdquad = {love.graphics.newQuad(0, 0, 29, 16, 29, 32), love.graphics.newQuad(0, 16, 29, 16, 29, 32)}
	
    if arg[3] then
        scale = arg[3]
    else
        scale = 8
    end
    if arg[4] then
        fullscreen = true
    else
        fullscreen = false
    end

    if not windowSet then
        love.graphics.setMode(100*scale, 80*scale, fullscreen, true, 0)
        windowSet = true
    end
	love.graphics.setIcon( love.graphics.newImage("graphics/icon.png") )
	
	bgmusic = love.audio.newSource("audio/trosong.ogg")
	bgmusic:setLooping(true)
	lasersound = love.audio.newSource("audio/laser.wav")
	bigexplosionsound = love.audio.newSource("audio/bigexplosion.ogg")
	explosionsound = love.audio.newSource("audio/explosion.wav")
	launchsound = love.audio.newSource("audio/launch.ogg")
	gunfire = love.audio.newSource("audio/gunfire.wav")
	space = love.audio.newSource("audio/space.ogg")
	sunglassessound = love.audio.newSource("audio/sunglasses.ogg")
	splat = love.audio.newSource("audio/splat.ogg")
	ding = love.audio.newSource("audio/ding.ogg")
	credits = love.audio.newSource("audio/credits.ogg")
	approach = love.audio.newSource("audio/approach.ogg")
	credits:setLooping(true)
	
	skipupdate = true
	shakeamount = 0
	shake = 0
	fade = 0
	playerframe = 1
	scoreanim = 1
	rainbowi = 0.5
	sini = 0
	sini2 = math.pi/2
	scrollx = 0
	points = 0
	machinedelay = 0.05
	stars = {}
	explosions = {}
	backgroundstripes = 10
	sunrot = 0
	
	lasers = {}
	
	realasteroiddelay = 1
	movement1speed = 100
	laserdelay = 0
	reallaserdelay = 0.4
	starttimer = 0

    rockets = nil
    jumped = nil
    landing = nil
    sunglasses = nil
    massenemies = nil

	love.graphics.setBackgroundColor(153, 217, 234)
	clouds = {}
	bushes = {}
    love.audio.play(bgmusic)
	for i = 1, 5 do
		table.insert(clouds, cloud:new(true))
	end
	for i = 1, 30 do
		table.insert(bushes, bush:new(true))
	end
	
	textpos = {}
	for i = 0, 7 do
		textpos[i] = 10
	end
	playerframetimer = 0
	playery = 50
	playerx = 10
	--				 1    2   3    4     5     6      7
	startactions = {2.3, 4.6, 7, 8.20, 9.20, 10.20, 11.20}
	starti = 0
	
end

function menu_update(dt)
	for i, v in pairs(clouds) do
		v:update(dt)
	end
	for i, v in pairs(bushes) do
		v:update(dt)
	end
	
	scrollx = scrollx + dt*50
	
	rainbowi = math.mod(rainbowi + dt/2, 1)
	sini = math.mod(sini + dt*10, math.pi*2)
	sini2 = math.mod(sini2 + dt*5, math.pi*2)
	
	if starti >= 0 and starttimer > startactions[starti+1] then
		starti = starti+1
		if starti == 7 then
			changegamestate("scene1")
			return
		end
	end
	
	if starti >= 4 then
		shakeamount = shakeamount + dt*4
	end
	if starti >= 5 then
		shakeamount = shakeamount + dt*10
	end
	if starti >= 6 then
		shakeamount = shakeamount + dt*50
	end
	
	for i = -1, starti-1 do
		if i >= 0 then
			textpos[i] = textpos[i]+(textpos[i]^2*dt)
		end
	end
	
	playerframetimer = playerframetimer + dt*10
	while playerframetimer >= 2 do
		playerframetimer = playerframetimer - 2
	end
	playerframe = math.floor(playerframetimer)+1
	
	playermovement1(dt)
end

function menu_action()
    if starti >= 0 then
        shootlaser()
    end
end

function menu_draw()
	love.graphics.setColor(255, 255, 255)
	for i, v in pairs(clouds) do
		v:draw()
	end
	
	for i = 1, 2 do
		draw(groundimg, -math.mod(scrollx, 120) + (i-1)*120, 59)
	end
	for i, v in pairs(bushes) do
		v:draw()
	end
	
	love.graphics.drawq(playerimg, playerquad[playerframe], playerx*scale, playery*scale, 0, scale, scale, 7, 12)
	for i, v in pairs(lasers) do
		v:draw()
	end

	love.graphics.setColor(getrainbowcolor(rainbowi, 420))
	draw(titleimg, 50, 23, math.sin(sini)/10, (math.sin(sini2)+1)/5+0.7, (math.sin(sini2)+1)/5+0.7, 50, 13)
	
	love.graphics.setColor(255, 0, 0)
	if starti >= 0 then
		properprint("directed by maurice", 13, 40+textpos[0], scale/2)
	end
	if starti >= 1 then
		properprint("utilise les fleches", 11, 40+textpos[1], scale/2)
	end
	if starti >= 2 then
		properprint("et une autre touche", 11, 40+textpos[2], scale/2)
	end
	if starti >= 3 then
		properprint("pret...", 30, 40+textpos[3], scale/2)
	end
	if starti >= 4 then
		properprint("3", 40, 40+textpos[4], scale*2)
	end
	if starti >= 5 then
		properprint("2", 36, 40+textpos[5], scale*3)
	end
	if starti >= 6 then
		properprint("1", 32, 40+textpos[6], scale*4)
	end
	if starti >= 7 then
		properprint("go !", 10, 40+textpos[7], scale*6)
	end
	
	love.graphics.setColor(255, 255, 255)
end

