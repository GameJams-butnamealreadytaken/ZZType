meteor = {meteorCpt = 0, maxMeteorId = 0, speedFactor = 1, focusedId = 0}

local meteorprites

function meteor.initialize()
	meteorprites = 
	{
		{
			love.graphics.newImage("resources/meteorBrown_tiny1.png"),
			love.graphics.newImage("resources/meteorBrown_tiny2.png"),
			love.graphics.newImage("resources/meteorBrown_small1.png"),
			love.graphics.newImage("resources/meteorBrown_small2.png"),
			love.graphics.newImage("resources/meteorBrown_med1.png"),
			love.graphics.newImage("resources/meteorBrown_med2.png"),
			love.graphics.newImage("resources/meteorBrown_big1.png"),
			love.graphics.newImage("resources/meteorBrown_big2.png"),
			love.graphics.newImage("resources/meteorBrown_big3.png"),
			love.graphics.newImage("resources/meteorBrown_big4.png")
		},
		{
			love.graphics.newImage("resources/meteorGrey_tiny1.png"),
			love.graphics.newImage("resources/meteorGrey_tiny2.png"),
			love.graphics.newImage("resources/meteorGrey_small1.png"),
			love.graphics.newImage("resources/meteorGrey_small2.png"),
			love.graphics.newImage("resources/meteorGrey_med1.png"),
			love.graphics.newImage("resources/meteorGrey_med2.png"),
			love.graphics.newImage("resources/meteorGrey_big1.png"),
			love.graphics.newImage("resources/meteorGrey_big2.png"),
			love.graphics.newImage("resources/meteorGrey_big3.png"),
			love.graphics.newImage("resources/meteorGrey_big4.png")
		}
	}
end

-- Create a new meteor
function meteor.create(minWordLength, maxWordLength)
	-- Start location
	local x = love.math.random(0, windowWidth)
	local y = love.math.random(0, -150)
	local destx = love.math.random(0 + windowWidth / 5 , windowWidth - windowWidth / 5)
	local desty = y + windowHeight
	
	-- dir vector + normalize for speed
	local vecx, vecy = destx - x, desty - y
	local vecLength = math.sqrt(vecx * vecx + vecy * vecy)
	local dirx = vecx / vecLength
	local diry = vecy / vecLength
	
	-- Get word
	local wordSize = 0
	repeat
		wordSize = love.math.random(minWordLength, maxWordLength)
	until dictionary[wordSize] ~= nil

	wordId = love.math.random(1, #dictionary[wordSize])
	local text = dictionary[wordSize][wordId]

	-- Get sprite based on word length
	local spriteType = love.math.random(1, 2)
	local spriteMin, spriteMax
	if (#text < 5) then
		spriteMin, spriteMax = 1, 2
	elseif (#text < 7) then
		spriteMin, spriteMax = 3, 4
	elseif (#text < 9) then
		spriteMin, spriteMax = 5, 6
	else
		spriteMin, spriteMax = 7, 10
	end
	
	local spriteSpriteId = love.math.random(spriteMin, spriteMax)
	local sprite = meteorprites[spriteType][spriteSpriteId]

	meteor.maxMeteorId = meteor.maxMeteorId + 1
	meteor.meteorCpt = meteor.meteorCpt + 1
	meteor[meteor.maxMeteorId] = { sprite = sprite, x = x, y = y, destx = destx, lifePoint = #text, text = text, textx = (x - (love.graphics.getFont():getWidth(text) / 2)) + (sprite:getWidth() / 2), texty = y + sprite:getHeight(), dirx = dirx, diry = diry, score = spriteSpriteId * 10}
end

-- Update sprites and texts locations based on speed and direction
function meteor.update(dt)
	for i = 1, meteor.maxMeteorId do
		if (meteor[i] ~= nil ) then
			local speedx = meteor[i].dirx * meteor.speedFactor * 60 * dt
			local speedy = meteor[i].diry * meteor.speedFactor * 60 * dt
			
			meteor[i].x = meteor[i].x + speedx
			meteor[i].textx = meteor[i].textx + speedx
			meteor[i].y = meteor[i].y + speedy
			meteor[i].texty = meteor[i].texty + speedy

			-- Check if out of screen
			if (meteor[i].y > windowHeight) then
				removeMeteor(i)
				game.takeDamage()
			end
		end
	end
end

-- Draw sprites and texts. Draw focused text in red
function meteor.draw()
	for i = 1, meteor.maxMeteorId do
		if (meteor[i] ~= nil ) then
			love.graphics.draw(meteor[i].sprite, meteor[i].x, meteor[i].y)
		end
	end
	
	for i = 1, meteor.maxMeteorId do
		if (meteor[i] ~= nil ) then

			if (meteor.focusedId == i) then
				love.graphics.setColor(255,0,0)
			end
			love.graphics.print(meteor[i].text, meteor[i].textx, meteor[i].texty)
			if (meteor.focusedId == i) then
				love.graphics.setColor(255,255,255)
			end
		end
	end
end

-- Check if $text is a valid first letter in every meteors OR in currently focused one
-- Return focused meteor id if $text is a valid input, 0 otherwise
function meteor.onTexteEntered(text)
	if (meteor.focusedId == 0) then
		for i = 1, meteor.maxMeteorId do
			if (meteor[i] ~= nil
					and text:match(meteor[i].text:sub(1, 1))) then
				meteor.focusedId = i
				break
			end
		end
	elseif (meteor[meteor.focusedId] == nil
			or not text:match(meteor[meteor.focusedId].text:sub(1, 1))) then
		meteor.focusedId = 0
	end
	
	return meteor.focusedId
end

-- Consume first letter on given meteorId
-- Return true if meteor is fully consumed, false otherwise
function meteor.consumeLetter(meteorId)
	meteor[meteorId].text = meteor[meteorId].text:sub(2)

	if (#meteor[meteorId].text == 0) then
		return true, meteor[meteorId].score
	end

	return false, 0
end

function meteor.removeMeteor(meteorId)
	meteor[meteorId] = nil
	meteor.meteorCpt = meteor.meteorCpt - 1
	if (meteorId == meteor.maxMeteorId) then meteor.maxMeteorId = meteor.maxMeteorId - 1 end
end

return meteor