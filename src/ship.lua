ship = { focusedMeteorId = 0 }

local shipSprite, shipSpriteTheme
local x, y, missileOffset

function ship.initialize()
	shipSpriteTheme = love.graphics.newImage("resources/ship_theme.png")
	shipSprite = love.graphics.newImage("resources/ship.png")
end

function ship.play()
	if (mode.theme == true) then
		x = (windowWidth / 2) - shipSprite:getWidth() / 4
		y = windowHeight - 90
		missileOffset = 0
	else
		x = (windowWidth / 2) - shipSprite:getWidth() / 4 -- / 4 because of scale
		y = windowHeight - 50
		missileOffset = 15
	end
end

function ship.launchMissile(meteorId)
	missile.launch(x + (shipSprite:getWidth() / 4) + missileOffset, y, meteorId)
	missileOffset = missileOffset * -1
end

function ship.draw()
	if (mode.theme == true) then
		love.graphics.draw(shipSpriteTheme, x, y, 0, 0.75, 0.75)
	else
		love.graphics.draw(shipSprite, x, y, 0, 0.5, 0.5)
	end
end

return ship