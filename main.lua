require 'src/slam' -- https://github.com/vrld/slam

gameBackground = require 'src/background'
game = require 'src/game'
mainmenu = require 'src/mainmenu'

-- /!\ too much indistinguishable letters for gameplay on futur_font, menu only.
defaultFont, futurFontTiny, futurFont, futurFontHuge = nil

-- Stats
stats = 
{
	score = 0,
	bestScore = 0, 
	combo = 0, 
	bestCombo = 0, 
	waveLevel = 0, 
	bestWave = 0,
	
	scoreTheme = 0,
	bestScoreTheme = 0, 
	comboTheme = 0, 
	bestComboTheme = 0, 
	waveLevelTheme = 0, 
	bestWaveTheme = 0,
	
	scoreCustom = 0,
	bestScoreCustom = 0, 
	comboCustom = 0, 
	bestComboCustom = 0, 
}

gameState = 
{
	mainmenu = true,
	game = false,
	pause = false
}
mode =
{
	classic = true,
	theme = false,
	custom = false
}

local currentState = mainmenu

windowWidth = 512
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
	textdbg = ""

	defaultFont = love.graphics.getFont()
	futurFontTiny = love.graphics.newFont("resources/Kenney_Rocket_Square.ttf", 7) 
	futurFont = love.graphics.newFont("resources/Kenney_Rocket_Square.ttf", 15) 
	futurFontHuge = love.graphics.newFont("resources/Kenney_Rocket_Square.ttf", 70)

	loadStats()

	gameBackground.initialize()

	mainmenu.initialize()
	game.initialize()
	
	currentState.play()
	
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
	
	loadedStats = love.filesystem.load(fileName)
	loadedStats()
end

function saveStats()	
	local fileName = "stats.lua"
	if love.filesystem.getInfo(fileName) == nil then
		love.filesystem.newFile(fileName)
	end
	
    save = "stats.score = " .. stats.score
    save = save.. ";stats.bestScore = " .. stats.bestScore
    save = save.. ";stats.combo = " .. stats.combo
    save = save.. ";stats.bestCombo = " .. stats.bestCombo
    save = save.. ";stats.waveLevel = " .. stats.waveLevel
    save = save.. ";stats.bestWave = " .. stats.bestWave

    save = save.. ";stats.scoreTheme = " .. stats.scoreTheme
    save = save.. ";stats.bestScoreTheme = " .. stats.bestScoreTheme
    save = save.. ";stats.comboTheme = " .. stats.comboTheme
    save = save.. ";stats.bestComboTheme = " .. stats.bestComboTheme
    save = save.. ";stats.waveLevelTheme = " .. stats.waveLevelTheme
    save = save.. ";stats.bestWaveTheme = " .. stats.bestWaveTheme
	
    save = save.. ";stats.scoreCustom = " .. stats.scoreCustom
    save = save.. ";stats.bestScoreCustom = " .. stats.bestScoreCustom
    save = save.. ";stats.comboCustom = " .. stats.comboCustom
    save = save.. ";stats.bestComboCustom = " .. stats.bestComboCustom
	
    love.filesystem.write(fileName, save)
end

function stats.setStat(name, value)
	if (mode.classic == true) then
		if (stats[name] ~= nil) then
			stats[name] = value
		end
	elseif (mode.theme == true) then
		if (stats[name.."Theme"] ~= nil) then
			stats[name.."Theme"] = value
		end
	else
		if (stats[name.."Combo"] ~= nil) then
			stats[name.."Combo"] = value
		end
	end
end

function stats.getStat(name)
	if (mode.classic == true) then
		if (stats[name] ~= nil) then
			return stats[name]
		end
	elseif (mode.theme == true) then
		if (stats[name.."Theme"] ~= nil) then
			return stats[name.."Theme"]
		end
	else
		if (stats[name.."Combo"] ~= nil) then
			return stats[name.."Combo"]
		end
	end
	
	return 0
end