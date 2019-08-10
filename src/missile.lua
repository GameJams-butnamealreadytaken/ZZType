missile = { missileCpt = 0, maxMissileId = 0, speedFactor = 5}

local missileSprite

function missile.initialize()
    missileSprite = love.graphics.newImage("resources/spaceMissile.png")
end

function missile.launch(startx, starty, meteorId)
	missile.missileCpt = missile.missileCpt + 1	
	missile.maxMissileId = missile.maxMissileId + 1
	missile[missile.maxMissileId] = { sprite = missileSprite, x = startx, y = starty, angle = 0, meteorId = meteorId }
end

function missile.update(dt)
	for i = 1, missile.maxMissileId do
		if (missile[i] ~= nil ) then
			local targetMeteor = meteor[missile[i].meteorId]
			if (targetMeteor == nil) then removeMissile(i) return end
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

			-- Reached its meteore ?
			if (vecLength < 10) then
				meteor[meteorId].lifePoint = meteor[meteorId].lifePoint - 1
				if (meteor[meteorId].lifePoint == 0) then
					meteor.removeMeteor(missile[i].meteorId)
				end
				removeMissile(i)
			end
		end
	end
end

function missile.draw()
	for i = 1, missile.maxMissileId do
		if (missile[i] ~= nil ) then
			love.graphics.draw(missile[i].sprite, missile[i].x, missile[i].y, missile[i].angle, 0.75, 0.75)
		end
	end
end

function removeMissile(missileId)
	missile[missileId] = nil
	missile.missileCpt = missile.missileCpt - 1
	if (missileId == missile.maxMissileId) then missile.maxMissileId = missile.maxMissileId - 1 end
end

return missile