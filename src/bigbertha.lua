bigBertha = { cptBertha = 0 }

local bigBerthaSprite, bigBerthaSpriteTheme, usedSprite
local explosionSprite
local launchSound, launchSoundTheme, usedLaunchSound
local hitSound, hitSoundTheme, usedHitSound

local x,y

local explode = false
local explodeScale = 1

function bigBertha.initialize()
    bigBerthaSprite = love.graphics.newImage("resources/bigBertha.png")
    bigBerthaSpriteTheme = love.graphics.newImage("resources/bigBerthaTheme.png")
    
	explosionSprite = love.graphics.newImage("resources/explosion1.png")

	launchSound = love.audio.newSource("resources/missile_launch.wav", "static")
	hitSound = love.audio.newSource("resources/missile_hit.wav", "static")
	
	launchSoundTheme = love.audio.newSource("resources/bigbertha_launchTheme.mp3", "static")
	hitSoundTheme = love.audio.newSource("resources/bigbertha_hitTheme.mp3", "static")	
	
	launchSound:setVolume(.5)
	launchSoundTheme:setVolume(.5)
	hitSound:setVolume(.5)
	hitSoundTheme:setVolume(1)
end

function bigBertha.play()
	if (mode.theme == true) then		
		usedLaunchSound = launchSoundTheme
		usedHitSound = hitSoundTheme
	else	
		usedLaunchSound = launchSound
		usedHitSound = hitSound
	end
end

function bigBertha.reset()
	usedSprite = nil
	explode = false
	explodeScale = 1
	
	usedLaunchSound:stop()
	usedHitSound:stop()
end

function bigBertha.launch()
	if(bigBertha.cptBertha == 0) then return end
	
	bigBertha.cptBertha = bigBertha.cptBertha - 1
	
	if (mode.theme == true) then
		usedSprite = bigBerthaSpriteTheme
	else
		usedSprite = bigBerthaSprite
	end
	
	x = (windowWidth / 2)
	y = windowHeight - 45
	
	usedLaunchSound:play()
end

function bigBertha.update(dt)
	if (explode) then
		explodeScale = explodeScale + 1
		if (explodeScale > 150) then
			bigBertha.removeMissile()
		end
	elseif (usedSprite ~= nil) then
		local speed = 5 * 60 * dt
		y = y - speed
		
		if (y < windowHeight / 2) then
			usedSprite = explosionSprite
			explode = true
			usedLaunchSound:stop()
			usedHitSound:play()
		end
	end
end

function bigBertha.draw()
	if (usedSprite ~= nil ) then
		if (explode) then
			love.graphics.draw(usedSprite, x , y , 0, explodeScale, explodeScale, usedSprite:getWidth()/2, usedSprite:getHeight()/2)
		else
			love.graphics.draw(usedSprite, x, y, 0, 0.75, 0.75, usedSprite:getWidth() / 2, usedSprite:getHeight() / 2)
		end
	end
end

function bigBertha.removeMissile()
	bigBertha.reset()
	stats.setStat("score", stats.getStat("score") + meteor.meteorCpt * 50)
	game.waveEnded()
end

function bigBertha.isLaunched()
	return usedSprite ~= nil
end

return bigBertha