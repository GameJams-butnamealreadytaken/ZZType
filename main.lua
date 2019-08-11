gameBackground = require 'src/background'

game = require 'src/game'
mainmenu = require 'src/mainmenu'

-- /!\ too much indistinguishable letters for gameplay on futur_font, menu only.
defaultFont, futurFont, futurFontHuge = nil, nil, nil

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

    num = 0
	textdbg = "ntm"

	defaultFont = love.graphics.getFont()
	futurFont = love.graphics.newFont("resources/Kenney_Rocket_Square.ttf", 15) 
	futurFontHuge = love.graphics.newFont("resources/Kenney_Rocket_Square.ttf", 70)

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
