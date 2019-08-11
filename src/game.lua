game = { state = "game"}

ship = require 'src/ship'
missile = require 'src/missile'
meteor = require 'src/meteor'

dictionary  = require 'src/dictionary'

local musicTheme

local textScore = ""
local textCombo = ""
local textWave = ""

function game.initialize()
	musicTheme = love.audio.newSource('resources/musicGameTheme.wav', 'stream')
	musicTheme:setLooping(true)

	dictionary.initialize()
	
	ship.initialize()
	meteor.initialize()
	missile.initialize()
 end

function game.play()
	if (mode.theme == true) then
		love.audio.stop()
		musicTheme:play()
	else
		if (love.audio.getActiveSourceCount() == 0) then
			mainmenu.music:play()
		end
		
	end
	
	stats.setStat("score", 0)
	stats.setStat("combo", 0)
	stats.setStat("waveLevel", 1)
	
	ship.play()
	missile.play()
	
	launchWave()
end

function game.stop()
	musicTheme:stop()
	stats.setStat("bestCombo", math.max(stats.getStat("combo"), stats.getStat("bestCombo")))
	stats.setStat("bestScore", math.max(stats.getStat("score"), stats.getStat("bestScore")))
	stats.setStat("bestWave", math.max(stats.getStat("waveLevel"), stats.getStat("bestWave")))
	meteor.reset()
	missile.reset()
end

function game.update(dt)
	meteor.update(dt)
	missile.update(dt)
	
	textScore = "Score : " .. stats.getStat("score")
	textCombo = "Combo : "	 .. stats.getStat("combo")
	textWave = "Wave "	 .. stats.getStat("waveLevel")
end

function game.draw()
	meteor.draw()
	missile.draw()
	ship.draw()

    love.graphics.print(textScore, 10, windowHeight - 20)
    love.graphics.print(textCombo, 10, windowHeight - 40)
    love.graphics.print(textWave, windowWidth - 100, windowHeight - 20)
end

function launchWave()
	local waveLevel = stats.getStat("waveLevel")
	local meteorInWave = 3 + math.floor(waveLevel / 3)
	local minWordLength = math.min(3 + math.floor(waveLevel/ 5), dictionary.maxWordLength - 1)
	minWordLength = math.max(minWordLength, dictionary.minWordLength)
	local maxWordLength = math.min(3 + math.floor(waveLevel/ 3), dictionary.maxWordLength)
	
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
	stats.setStat("waveLevel", stats.getStat("waveLevel") + 1)
	launchWave()
end

function game.textinput(t)
    meteorId = meteor.onTexteEntered(t)

	if (0 == meteorId) then
		stats.setStat("bestCombo", math.max(stats.getStat("combo"), stats.getStat("bestCombo")))
		stats.setStat("combo", 0)
	else
		stats.setStat("combo", stats.getStat("combo") + 1)
		ship.launchMissile(meteorId)
		local res, meteorScore = meteor.consumeLetter(meteorId)
		if (res == true) then
			stats.setStat("score", stats.getStat("score") + meteorScore)
		end
	end
end

function game.keypressed(key)
	if key == "space" then	
		game.waveEnded()
	elseif key == "escape" then
		game.takeDamage()
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