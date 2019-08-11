mainmenu = { state = "mainmenu", music = nil}

local title
local buttonSprite

local musicEasterEgg
local musicEasterEggPlayed = false

local textClassic, textHelpClassic
local textTheme, textHelpTheme
local textCustom, textHelpCustom
local currentHelpText

local cursorAngle, cursorAngleFactor, cursorSprite, cursorX, cursorY = 0, 0.1

function mainmenu.initialize()
	title = "ZZType"

	mainmenu.music = love.audio.newSource('resources/musicMenuMercury.mp3', 'stream')
	mainmenu.music:setLooping(true)
	musicEasterEgg = love.audio.newSource('resources/ZZ Top - La Grange.mp3', 'stream')
	
	buttonSprite = love.graphics.newImage("resources/button.png")
	
	textClassic = "Classic"
	textHelpClassic = "Infinite waves of words from dictionary"
	
	textTheme = "Theme"
	textHelpTheme = "Same that classic but..\nWTF are those unlikely combinations of assets ??? :o"
	
	textCustom = "Custom"
	textHelpCustom = "No waves, every words from a custom file in a row.\nGreat to play with lyrics\n(wip)"
	
	currentHelpText = nil
	
	cursorSprite = love.graphics.newImage("resources/cursor.png")
	cursorX, cursorY = love.mouse.getPosition()
 end
 
function mainmenu.play()
	if (love.audio.getActiveSourceCount() == 0) then
		mainmenu.music:play()
	end
	
	mode.classic = true; -- to get stats from their full name
end

function mainmenu.stop()
	musicEasterEgg:stop()
	if (mode.theme == true) then
		mainmenu.music:stop()
	end
	
	currentHelpText = nil
end
 
function mainmenu.update(dt)
	if (musicEasterEggPlayed == true) then
		if (love.audio.getActiveSourceCount() == 0) then
			musicEasterEggPlayed = false
			music:play()
		end
	end
	--TODO update cursor location to rotate around mouse location
	--cursorAngle = cursorAngle + cursorAngleFactor
end

function mainmenu.draw()
	local x = windowWidth / 2
	local y = windowHeight / 4
	-- Title
	love.graphics.setFont(futurFontHuge)
	love.graphics.print(title, x, y, 0, 1, 1, futurFontHuge:getWidth(title) / 2, futurFontHuge:getHeight(title) / 2)
	love.graphics.setFont(futurFont)
	
	y = y + 150
	-- Classic
	love.graphics.draw(buttonSprite, x, y, 0, 2, 0.3, buttonSprite:getWidth() / 2, buttonSprite:getHeight() / 2)
	love.graphics.print(textClassic, x, y, 0, 1, 1, futurFont:getWidth(textClassic) / 2, futurFont:getHeight(textClassic) / 2)
	
	y = y + 50
	-- Theme
	love.graphics.draw(buttonSprite, x, y, 0, 2, 0.3, buttonSprite:getWidth() / 2, buttonSprite:getHeight() / 2)
	love.graphics.print(textTheme, x, y, 0, 1, 1, futurFont:getWidth(textTheme) / 2, futurFont:getHeight(textTheme) / 2)
	
	y = y + 50
	-- Custom
	love.graphics.draw(buttonSprite, x, y, 0, 2, 0.3, buttonSprite:getWidth() / 2, buttonSprite:getHeight() / 2)
	love.graphics.print(textCustom, x, y, 0, 1, 1, futurFont:getWidth(textCustom) / 2, futurFont:getHeight(textCustom) / 2)

	y = y + 50
	if (currentHelpText ~= nil) then
		--love.graphics.print(currentHelpText, x, y, 0, 1, 1, futurFont:getWidth(currentHelpText) / 2, futurFont:getHeight(currentHelpText) / 2)
		love.graphics.printf(currentHelpText, x, y, 400, "center", 0, 1, 1, 200)
	end
	
	y = y + 100
	love.graphics.print("classic"						, x - 70 , y)
	love.graphics.print("theme"							, x + 50, y)
	love.graphics.print("custom"						, x + 150, y)
	y = y + 25
	love.graphics.print("Best Score", x - 225, y)
	love.graphics.print(stats.getStat("bestScore")		, x - 70 , y)
	love.graphics.print(stats.getStat("bestScoreTheme")	, x + 50, y)
	love.graphics.print(stats.getStat("bestScoreCustom"), x + 150, y)
	y = y + 25
	love.graphics.print("Last Score", x - 225, y)
	love.graphics.print(stats.getStat("score")			, x - 70 , y)
	love.graphics.print(stats.getStat("scoreTheme")		, x + 50, y)
	love.graphics.print(stats.getStat("scoreCustom")	, x + 150, y)
	y = y + 25
	love.graphics.print("Best Wave", x - 225, y)
	love.graphics.print(stats.getStat("bestWave")		, x - 70 , y)
	love.graphics.print(stats.getStat("bestWaveTheme")	, x + 50, y)
	love.graphics.print("-"								, x + 150, y)
	y = y + 25
	love.graphics.print("Last Wave", x - 225, y)
	love.graphics.print(stats.getStat("waveLevel")		, x - 70 , y)
	love.graphics.print(stats.getStat("waveLevelTheme")	, x + 50, y)
	love.graphics.print("-"								, x + 150, y)
	y = y + 25
	love.graphics.print("Best Combo", x - 225, y)
	love.graphics.print(stats.getStat("bestCombo")		, x - 70 , y)
	love.graphics.print(stats.getStat("bestComboTheme")	, x + 50, y)
	love.graphics.print(stats.getStat("bestComboCustom"), x + 150, y)

	-- Cursor
	x, y = love.mouse.getPosition()
    love.graphics.draw(cursorSprite, x, y, cursorAngle, 0.5, 0.5)
end

function mainmenu.mousepressed(x, y, button, istouch, presses)
	if (button == 1) then
		local buttonX = windowWidth / 2
		local buttonY = windowHeight / 4
		local scaledButtonHalfWidth = (buttonSprite:getWidth() * 2) / 2
		local scaledButtonHalfHeight = (buttonSprite:getHeight() * 0.3) / 2
				
		-- Title Easter Egg
		if (x < buttonX + futurFontHuge:getWidth(title) / 2 and x > buttonX - futurFontHuge:getWidth(title) / 2 and y < buttonY + futurFontHuge:getHeight(title) / 2 and y > buttonY - futurFontHuge:getHeight(title) / 2) then
			love.audio.stop()
			musicEasterEgg:play()
			musicEasterEggPlayed = true
			return
		end
		
		buttonY = buttonY + 150
		-- Classic
		if (x < buttonX + scaledButtonHalfWidth and x > buttonX - scaledButtonHalfWidth and y < buttonY + scaledButtonHalfHeight and y > buttonY - scaledButtonHalfHeight) then
			mode.classic = true; mode.theme = false; mode.custom = false
			switchState(game)
			return
		end
		
		buttonY = buttonY + 50
		-- Theme
		if (x < buttonX + scaledButtonHalfWidth and x > buttonX - scaledButtonHalfWidth and y < buttonY + scaledButtonHalfHeight and y > buttonY - scaledButtonHalfHeight) then
			mode.classic = false; mode.theme = true; mode.custom = false
			switchState(game)
			return
		end
		
		buttonY = buttonY + 50
		-- Custom
		if (x < buttonX + scaledButtonHalfWidth and x > buttonX - scaledButtonHalfWidth and y < buttonY + scaledButtonHalfHeight and y > buttonY - scaledButtonHalfHeight) then
			mode.classic = false; mode.theme = false; mode.custom = true
			switchState(game)
			return
		end		
	end
end

function mainmenu.mousemoved(x, y, dx, dy, istouch)
		local buttonX = windowWidth / 2
		local buttonY = windowHeight / 4 + 150
		local scaledButtonHalfWidth = (buttonSprite:getWidth() * 2) / 2
		local scaledButtonHalfHeight = (buttonSprite:getHeight() * 0.3) / 2
		
		-- Classic
		if (x < buttonX + scaledButtonHalfWidth and x > buttonX - scaledButtonHalfWidth and y < buttonY + scaledButtonHalfHeight and y > buttonY - scaledButtonHalfHeight) then
			currentHelpText = textHelpClassic
			return
		end
		
		buttonY = buttonY + 50
		-- Theme
		if (x < buttonX + scaledButtonHalfWidth and x > buttonX - scaledButtonHalfWidth and y < buttonY + scaledButtonHalfHeight and y > buttonY - scaledButtonHalfHeight) then
			currentHelpText = textHelpTheme
			return
		end
		
		buttonY = buttonY + 50
		-- Custom
		if (x < buttonX + scaledButtonHalfWidth and x > buttonX - scaledButtonHalfWidth and y < buttonY + scaledButtonHalfHeight and y > buttonY - scaledButtonHalfHeight) then
			currentHelpText = textHelpCustom
			return
		end
		
		currentHelpText = nil
end


function mainmenu.textinput(t)
    --
end

function mainmenu.keypressed(key)
	--
end

return mainmenu