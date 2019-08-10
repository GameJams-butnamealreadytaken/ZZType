ship = { focusedMeteorId = 0 }

local shipSprite, x, y, missileOffset

function ship.initialize()
    shipSprite = love.graphics.newImage("resources/ship.png")
	x = (windowWidth / 2) - 21
	y = windowHeight - 50
	
	missileOffset = 10
end

function ship.launchMissile(meteorId)
	missile.launch(x + missileOffset, y, meteorId)
	missileOffset = missileOffset * -1
end

function ship.draw()
    love.graphics.draw(shipSprite, x, y, 0, 0.5, 0.5)
end

return ship