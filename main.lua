gameBackground = require 'src/background'
game = require 'src/game'
mainmenu = require 'src/mainmenu'

-- /!\ too much indistinguishable letters for gameplay on futur_font, menu only.
defaultFont, futurFontTiny, futurFont, futurFontHuge = nil

-- Stats
score, bestScore, combo, bestCombo, waveLevel, bestWave = 0, 0, 0, 0, 0, 0

gameState = 
{
	mainmenu = true,
	game = false,
	pause = false
}

local currentState = mainmenu

windowWidth = 514
windowHeight = 836

function switchState(newState)
	gameState[currentState.state] = false
	currentState.stop()
	currentState = newState
	currentState.play()
	gameState[currentState.state] = true
end

function love.load()
	love.window.setTitle("ZZType")
    love.window.setMode(windowWidth, windowHeight)

	love.filesystem.setIdentity("ZZType")

    num = 0
	textdbg = "ntm"

	defaultFont = love.graphics.getFont()
	futurFontTiny = love.graphics.newFont("resources/Kenney_Rocket_Square.ttf", 7) 
	futurFont = love.graphics.newFont("resources/Kenney_Rocket_Square.ttf", 15) 
	futurFontHuge = love.graphics.newFont("resources/Kenney_Rocket_Square.ttf", 70)

	loadStats()

	gameBackground.initialize()

	mainmenu.initialize()
	game.initialize()

	textdbg = dictionary.maxWordLength
 end

function love.update(dt)
    if gameIsPaused then 
        return 
    end

	currentState.update(dt)
 end

function love.draw()
	gameBackground.draw()
	
	currentState.draw()

	-- debug
    --love.graphics.print(textdbg, 350, 750)
end

function love.focus(f) 
    gameIsPaused = not f 
end

function love.quit()
	saveStats()
end

function love.textinput(t)
    currentState.textinput(t)
end

function love.keypressed(key)
	currentState.keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
	currentState.mousepressed(x, y, button, istouch, presses)
end

function love.mousemoved(x, y, dx, dy, istouch)
	currentState.mousemoved(x, y, dx, dy, istouch)
end

function loadStats()
	local fileName = "stats.lua"
	if love.filesystem.getInfo(fileName) == nil then
		love.filesystem.newFile(fileName)
		saveStats()
	end
	
	stats = love.filesystem.load(fileName)
	stats()
end

function saveStats()	
	local fileName = "stats.lua"
	if love.filesystem.getInfo(fileName) == nil then
		love.filesystem.newFile(fileName)
	end
	
    save = "score = " .. score
    save = save.. ";bestScore = " .. bestScore
    save = save.. ";combo = " .. combo
    save = save.. ";bestCombo = " .. bestCombo
    save = save.. ";waveLevel = " .. waveLevel
    save = save.. ";bestWave = " .. bestWave
	
    love.filesystem.write(fileName, save)
end