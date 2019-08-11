missile = { missileCpt = 0, maxMissileId = 0, speedFactor = 5}

local missileSprite, missileSpriteTheme
local explosionSprite, explosionSpriteTheme, explosionCurrent
local launchSound, launchSoundTheme, usedLaunchSound
local hitSound, hitSoundTheme, usedHitSound

function missile.initialize()
    missileSprite = love.graphics.newImage("resources/spaceMissile.png")
    missileSpriteTheme = love.graphics.newImage("resources/spaceMissileTheme.png")
    
	explosionSprite = 
	{
		love.graphics.newImage("resources/explosion1.png"),
		love.graphics.newImage("resources/explosion2.png"),
		love.graphics.newImage("resources/explosion3.png"),
		love.graphics.newImage("resources/explosion4.png"),
		love.graphics.newImage("resources/explosion5.png")
	}
	
	explosionSpriteTheme = 
	{
		love.graphics.newImage("resources/explosionTheme1.png"),
		love.graphics.newImage("resources/explosionTheme2.png"),
		love.graphics.newImage("resources/explosionTheme3.png"),
		love.graphics.newImage("resources/explosionTheme4.png"),
	}

	launchSound = love.audio.newSource("resources/missile_launch.wav", "static")
	hitSound = love.audio.newSource("resources/missile_hit.wav", "static")
	
	launchSoundTheme = love.audio.newSource("resources/missile_launchTheme.wav", "static")
	hitSoundTheme = love.audio.newSource("resources/missile_hitTheme.wav", "static")	
	
	launchSound:setVolume(.3)
	launchSoundTheme:setVolume(.3)
	hitSound:setVolume(.3)
	hitSoundTheme:setVolume(1)
end

function missile.play()
	if (mode.theme == true) then
		explosionCurrent = explosionSpriteTheme
		
		usedLaunchSound = launchSoundTheme
		usedHitSound = hitSoundTheme
	else
		explosionCurrent = explosionSprite
		
		usedLaunchSound = launchSound
		usedHitSound = hitSound
	end
end

function missile.reset()
	for i = 1, missile.maxMissileId do
		missile[i] = nil
	end
	missile.missileCpt = 0
	missile.maxMissileId = 0
	
	usedLaunchSound:stop()
	usedHitSound:stop()
end

function missile.launch(startx, starty, meteorId)
	missile.missileCpt = missile.missileCpt + 1	
	missile.maxMissileId = missile.maxMissileId + 1
	
	local sprite
	local exploSprite
	if (mode.theme == true) then
		sprite = missileSpriteTheme
	else
		sprite = missileSprite
	end
	missile[missile.maxMissileId] = 
	{ 
		sprite = sprite, 
		x = startx, 
		y = starty, 
		angle = 0, 
		meteorId = meteorId, 
		explode = false, 
		explosionDt = 0, 
		exploSprite = explosionCurrent[1], 
		explosionCpt = 1,
		launchSound = usedLaunchSound:play()
	}
end

function missile.update(dt)
	for i = 1, missile.maxMissileId do
		if (missile[i] ~= nil ) then
			local targetMeteor = meteor[missile[i].meteorId]
			if (targetMeteor == nil) then removeMissile(i) return end
			
			if (missile[i].explode == true) then
				-- Explosion Animation
				missile[i].explosionDt = missile[i].explosionDt + dt
				if (missile[i].explosionDt > 0.1) then
					missile[i].explosionDt = 0
					missile[i].explosionCpt = missile[i].explosionCpt + 1
					if (missile[i].explosionCpt > #explosionCurrent) then
						-- Exploded, deal damage to meteor and check if dead
						if (targetMeteor.lifePoint == 0) then
							if (meteor.removeMeteor(missile[i].meteorId) == true) then return end
						end
						removeMissile(i)
					else
						missile[i].exploSprite = explosionCurrent[missile[i].explosionCpt]
					end
				end
			else
				destx, desty = targetMeteor.x, targetMeteor.y
				x, y = missile[i].x, missile[i].y
				
				missile[i].angle = math.atan2((desty - y), (destx - x)) + (math.pi / 2)
				
				local vecx, vecy = destx - x, desty - y
				local vecLength = math.sqrt(vecx * vecx + vecy * vecy)
				local dirx = vecx / vecLength
				local diry = vecy / vecLength
			
				local speedx = dirx * missile.speedFactor * 60 * dt
				local speedy = diry * missile.speedFactor * 60 * dt
				
				missile[i].x = missile[i].x + speedx
				missile[i].y = missile[i].y + speedy

				-- Reached its meteore
				if (vecLength < 5) then
					missile[i].launchSound:stop()
					usedHitSound:play()
					missile[i].explode = true
					if (targetMeteor.lifePoint == 1) then
						-- Last meteor life point, stop moving it
						targetMeteor.isDead = true
					end
					targetMeteor.lifePoint = targetMeteor.lifePoint - 1
				end
			end
		end
	end
end

function missile.draw()
	for i = 1, missile.maxMissileId do
		if (missile[i] ~= nil ) then
			if (missile[i].explode) then
				love.graphics.draw(missile[i].exploSprite, missile[i].x , missile[i].y , 0, 0.75, 0.75, missile[i].exploSprite:getWidth()/2, missile[i].exploSprite:getHeight()/2)
			else
				love.graphics.draw(missile[i].sprite, missile[i].x, missile[i].y, missile[i].angle, 0.75, 0.75, missile[i].sprite:getWidth() / 2, missile[i].sprite:getHeight() / 2)
			end
		end
	end
end

function removeMissile(missileId)
	missile[missileId] = nil
	missile.missileCpt = missile.missileCpt - 1
	if (missileId == missile.maxMissileId) then missile.maxMissileId = missile.maxMissileId - 1 end
end

return missile