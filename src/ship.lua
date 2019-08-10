ship = { focusedMeteorId = 0 }

local shipSprite, x, y, missileOffset

function ship.initialize()
    shipSprite = love.graphics.newImage("resources/ship.png")
	x = (windowWidth / 2) - shipSprite:getWidth() / 4 -- / 4 because of scale
	y = windowHeight - 50
	
	missileOffset = 15
end

function ship.launchMissile(meteorId)
	missile.launch(x + (shipSprite:getWidth() / 4) + missileOffset, y, meteorId)
	missileOffset = missileOffset * -1
end

function ship.draw()
    love.graphics.draw(shipSprite, x, y, 0, 0.5, 0.5)
end

return ship