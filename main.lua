gameBackground = require 'src/background'

game = require 'src/game'

windowWidth = 514
windowHeight = 836

function love.load()
	love.window.setTitle("ZZType")
    love.window.setMode(windowWidth, windowHeight)

    num = 0
	text = "ntm"

	--love.graphics.setNewFont("resources/kenvector_future.ttf", 12) -- unreadable

	gameBackground.initialize()

	game.initialize()

	text = dictionary.maxWordLength
 end
 
function love.draw()
	gameBackground.draw()
	
	game.draw()

	-- debug
    love.graphics.print(text, 300, 300)
end

function love.focus(f) 
    gameIsPaused = not f 
end

function love.update(dt)
    if gameIsPaused then 
        return 
    end

	game.update(dt)
 end
