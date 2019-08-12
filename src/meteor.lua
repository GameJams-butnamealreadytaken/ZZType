meteor = {meteorCpt = 0, maxMeteorId = 0, speedFactor = 1, focusedId = 0}

local meteorSprites, meteorSpritesTheme

function meteor.initialize()
	meteorSprites = 
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
	
	meteorSpritesTheme = 
	{
		{
			love.graphics.newImage("resources/meteorThemeRound_panda.png"),
			love.graphics.newImage("resources/meteorThemeRound_pig.png"),
			love.graphics.newImage("resources/meteorThemeRound_dog.png"),
			love.graphics.newImage("resources/meteorThemeRound_giraffe.png"),
			love.graphics.newImage("resources/meteorThemeRound_zebra.png"),
			love.graphics.newImage("resources/meteorThemeRound_cow.png"),
			love.graphics.newImage("resources/meteorThemeRound_moose.png"),
			love.graphics.newImage("resources/meteorThemeRound_rhino.png"),
			love.graphics.newImage("resources/meteorThemeRound_elephant.png"),
			love.graphics.newImage("resources/meteorThemeRound_whale.png")
		},
		{
			love.graphics.newImage("resources/meteorThemeSquare_panda.png"),
			love.graphics.newImage("resources/meteorThemeSquare_pig.png"),
			love.graphics.newImage("resources/meteorThemeSquare_dog.png"),
			love.graphics.newImage("resources/meteorThemeSquare_giraffe.png"),
			love.graphics.newImage("resources/meteorThemeSquare_zebra.png"),
			love.graphics.newImage("resources/meteorThemeSquare_cow.png"),
			love.graphics.newImage("resources/meteorThemeSquare_moose.png"),
			love.graphics.newImage("resources/meteorThemeSquare_rhino.png"),
			love.graphics.newImage("resources/meteorThemeSquare_elephant.png"),
			love.graphics.newImage("resources/meteorThemeSquare_whale.png")
		}
	}
	
end

function meteor.reset()
	for i = 1, meteor.maxMeteorId do
		meteor[i] = nil
	end
	meteor.meteorCpt = 0
	meteor.maxMeteorId = 0
	meteor.focusedId = 0
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
	
	-- angular factor
	local angle = (love.math.random(0 ,200) - 100) / 10000
	
	-- Get word
	local text
	if (mode.custom == true) then
		text = dictionaryToUse[minWordLength][maxWordLength]
	else
		local wordSize = 0
		repeat
			wordSize = love.math.random(minWordLength, maxWordLength)
		until dictionaryToUse[wordSize] ~= nil

		wordId = love.math.random(1, #dictionaryToUse[wordSize])
		text = dictionaryToUse[wordSize][wordId]
	end
	-- Get sprite based on word length
	local texty
	local spriteType = love.math.random(1, 2)
	local spriteSpriteId
	local sprite
	if (mode.theme == true) then
		spriteSpriteId = love.math.random(1, 10)
		sprite = meteorSpritesTheme[spriteType][spriteSpriteId]
		
		texty = y + sprite:getHeight() - sprite:getHeight() / 4
	else
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
	
		spriteSpriteId = love.math.random(spriteMin, spriteMax)
		sprite = meteorSprites[spriteType][spriteSpriteId]
		
		texty = y + sprite:getHeight()
	end

	meteor.maxMeteorId = meteor.maxMeteorId + 1
	meteor.meteorCpt = meteor.meteorCpt + 1
	meteor[meteor.maxMeteorId] = 
	{ 
		sprite = sprite,
		x = x,
		y = y,
		destx = destx,
		angleFactor = angle,
		curAngle = 0,
		lifePoint = #text,
		text = text,
		textx = (x - (defaultFont:getWidth(text) / 2)) + (sprite:getWidth() / 2),
		texty = texty,
		dirx = dirx, 
		diry = diry,
		score = spriteSpriteId * 10,
		isDead = false
	}
end

-- Update sprites and texts locations based on speed and direction
function meteor.update(dt)
	for i = 1, meteor.maxMeteorId do
		if (meteor[i] ~= nil 
			and meteor[i].isDead == false) then
			local speedx = meteor[i].dirx * meteor.speedFactor * 60 * dt
			local speedy = meteor[i].diry * meteor.speedFactor * 60 * dt
			
			meteor[i].x = meteor[i].x + speedx
			meteor[i].textx = meteor[i].textx + speedx
			meteor[i].y = meteor[i].y + speedy
			meteor[i].texty = meteor[i].texty + speedy

			meteor[i].curAngle = meteor[i].curAngle + meteor[i].angleFactor
			
			-- Check if out of screen
			if (meteor[i].y > windowHeight) then
				meteor.removeMeteor(i)
				game.takeDamage()
			end
		end
	end
end

-- Draw sprites and texts. 
-- Draw focused text in red and in front of sprite for visibility purpose
function meteor.draw()
	for i = 1, meteor.maxMeteorId do
		if (meteor[i] ~= nil ) then
			if (mode.theme == true) then
				love.graphics.draw(meteor[i].sprite, meteor[i].x, meteor[i].y, meteor[i].curAngle, 0.4, 0.4, meteor[i].sprite:getWidth() / 2, meteor[i].sprite:getHeight() / 2)
			else
				love.graphics.draw(meteor[i].sprite, meteor[i].x, meteor[i].y, meteor[i].curAngle, 1, 1, meteor[i].sprite:getWidth() / 2, meteor[i].sprite:getHeight() / 2)
			end
		end
	end
			
	love.graphics.setFont(defaultFont)
	for i = 1, meteor.maxMeteorId do
		if (meteor[i] ~= nil ) then

			if (meteor.focusedId == i) then
				love.graphics.setColor(255,0,0)
			end
			-- Have to offset text location because of offset applied on sprite for rotation
			--love.graphics.print(meteor[i].text, meteor[i].textx - meteor[i].sprite:getWidth() / 2, meteor[i].texty - meteor[i].sprite:getHeight() / 2, 0, 1, 1, defaultFont:getWidth(meteor[i].text) / 2, defaultFont:getHeight(meteor[i].text) / 2)
			love.graphics.print(meteor[i].text, meteor[i].textx - meteor[i].sprite:getWidth() / 2, meteor[i].texty - meteor[i].sprite:getHeight() / 2, 0, 1, 1)
			--love.graphics.print(i, meteor[i].textx, meteor[i].texty + 10)
			if (meteor.focusedId == i) then
				love.graphics.setColor(255,255,255)
			end
		end
	end
	love.graphics.setFont(futurFont)
end

-- Check if $text is a valid first letter in every meteors OR in currently focused one
-- Return focused meteor id if $text is a valid input, 0 otherwise
function meteor.onTexteEntered(text)
	if (meteor.focusedId == 0) then
		for i = 1, meteor.maxMeteorId do
			if (meteor[i] ~= nil
				and #meteor[i].text > 0
				and text:match(meteor[i].text:sub(1, 1)) ~= nil) then
				meteor.focusedId = i
				break
			end
		end
	elseif (meteor[meteor.focusedId] == nil
			or text:match(meteor[meteor.focusedId].text:sub(1, 1)) == nil) then
		meteor.focusedId = 0
	end
	
	return meteor.focusedId
end

-- Consume first letter on given meteorId
-- Return true if meteor is fully consumed, false otherwise
function meteor.consumeLetter(meteorId)
	meteor[meteorId].text = meteor[meteorId].text:sub(2)

	if (#meteor[meteorId].text == 0) then
		meteor.focusedId = 0
		return true, meteor[meteorId].score
	end

	return false, 0
end

-- Remove a given meteor
-- Return true if it was the last one
function meteor.removeMeteor(meteorId)
	textdbg = meteorId
	meteor[meteorId] = nil
	meteor.meteorCpt = meteor.meteorCpt - 1
	-- Check if can reduce max ID
	if (meteorId == meteor.maxMeteorId) then meteor.maxMeteorId = meteor.maxMeteorId - 1 end
	-- Check if wave is ended
	if (meteor.meteorCpt == 0) then 
		game.waveEnded()
		return true
	end
	
	return false
end

return meteor