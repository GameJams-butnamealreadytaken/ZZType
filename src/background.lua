background = {}

local backgroundSprite
local spriteBlack, spriteBlue, spritePurple
local spriteWidth
local spriteHeight

function background.initialize()
	spritePurple = love.graphics.newImage("resources/background_purple.png")
	spriteBlack = love.graphics.newImage("resources/background_black.png")
	spriteBlue = love.graphics.newImage("resources/background_blue.png")

	background.reroll()

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

function background.reroll()
	rand = love.math.random(1, 3)
	if (rand == 1) then
		backgroundSprite = spritePurple
	elseif (rand == 2) then	
		backgroundSprite = spriteBlack
	else
		backgroundSprite = spriteBlue
	end
end

return background