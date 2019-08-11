game = { state = "game", score = 0, bestScore = 0, combo = 0, bestCombo = 0, waveLevel = 1}

ship = require 'src/ship'
missile = require 'src/missile'
meteor = require 'src/meteor'

dictionary  = require 'src/dictionary'

mode =
{
	classic = true,
	theme = false,
	custom = false
}

local textScore = ""
local textCombo = ""
local textWave = ""

function game.initialize()
	dictionary.initialize()

	ship.initialize()
	meteor.initialize()
	missile.initialize()

 end

function game.play()
	game.score = 0
	game.combo = 0
	game.waveLevel = 1
	launchWave()
end

function game.stop()
	game.bestCombo = math.max(game.combo, game.bestCombo)
	game.bestScore = math.max(game.score, game.bestScore)
	meteor.reset()
	missile.reset()
end

function game.update(dt)
	meteor.update(dt)
	missile.update(dt)
end

function game.draw()
	gameBackground.draw()
	meteor.draw()
	missile.draw()
	ship.draw()

	textScore = "Score : " .. game.score
	textCombo = "Combo : "	 .. game.combo
	textWave = "Wave "	 .. game.waveLevel

    love.graphics.print(textScore, 10, windowHeight - 20)
    love.graphics.print(textCombo, 10, windowHeight - 40)
    love.graphics.print(textWave, windowWidth - 100, windowHeight - 20)
end

function launchWave()
	local meteorInWave = 3 + math.floor(game.waveLevel / 3)
	local minWordLength = math.min(3 + math.floor(game.waveLevel / 5), dictionary.maxWordLength - 1)
	minWordLength = math.max(minWordLength, dictionary.minWordLength)
	local maxWordLength = math.min(3 + math.floor(game.waveLevel / 3), dictionary.maxWordLength)
	
	--text=game.waveLevel  .. " : " .. meteorInWave .. " " .. minWordLength .. " " .. maxWordLength
	
	for i = 1, meteorInWave do
		meteor.create(minWordLength, maxWordLength)
	end
end

-- Called when a meteor reach the ship
function game.takeDamage()
	switchState(mainmenu)
end

function game.waveEnded()
	meteor.reset()
	missile.reset()
	game.waveLevel = game.waveLevel + 1
	launchWave()
end

function game.textinput(t)
    meteorId = meteor.onTexteEntered(t)

	if (0 == meteorId) then
		game.bestCombo = math.max(game.combo, game.bestCombo)
		game.combo = 0
	else
		game.combo = game.combo + 1
		ship.launchMissile(meteorId)
		local res, score = meteor.consumeLetter(meteorId)
		if (res == true) then
			game.score = game.score + score
		end
	end
end

function game.keypressed(key)
	if key == "space" then	
		game.waveEnded()
	elseif key == "backspace" then
		meteor.focusedId = 0
	end
end

function game.mousepressed(x, y, button, istouch, presses)
	-- do smthg
end

function game.mousemoved(x, y, dx, dy, istouch)
	-- do smthg
end

return game