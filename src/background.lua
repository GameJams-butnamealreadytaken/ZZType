background = {}

local backgroundSprite
local spriteWidth
local spriteHeight

function background.initialize()
	rand = love.math.random(1, 3)
	if (rand == 1) then
		backgroundSprite = love.graphics.newImage("resources/background_purple.png")
	elseif (rand == 2) then	
		backgroundSprite = love.graphics.newImage("resources/background_black.png")
	else
		backgroundSprite = love.graphics.newImage("resources/background_blue.png")
	end

	spriteWidth = backgroundSprite:getWidth()
	spriteHeight = backgroundSprite:getHeight()
end
 
function background.draw()
	local height = 0
	
	for i = 0, 3 do
		love.graphics.draw(backgroundSprite, 0, height)
		love.graphics.draw(backgroundSprite, spriteWidth, height)
		height = height + spriteHeight
	end
end

return background