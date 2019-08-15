dictionary = {dico = nil, custom = nil}

function dictionary.initialize()
	dictionary.dico = { minWordLength = 2, maxWordLength = 0}
	for line in love.filesystem.lines("resources/dictionary_en.txt") do
	  if (#line > dictionary.dico.minWordLength) then
			if (dictionary.dico[#line] == nil) then 
				dictionary.dico[#line] = {}
				dictionary.dico.maxWordLength = math.max(dictionary.dico.maxWordLength, #line)
			end
			line = string.lower(line)
			dictionary.dico[#line][#dictionary.dico[#line] + 1] = line
		end
	end
	
	dictionary.custom = { lineCounter = 0 }
	for line in love.filesystem.lines("resources/LaGrangeLyrics.txt") do
		if (#line ~= 0) then		
			dictionary.custom.lineCounter = dictionary.custom.lineCounter + 1
			dictionary.custom[dictionary.custom.lineCounter] = { wordCounter = 0 }
			for token in line:gmatch("[^%s]+") do
				dictionary.custom[dictionary.custom.lineCounter].wordCounter = dictionary.custom[dictionary.custom.lineCounter].wordCounter + 1
				token = string.lower(token)
				dictionary.custom[dictionary.custom.lineCounter][dictionary.custom[dictionary.custom.lineCounter].wordCounter] = token
			end
		end
	end
end

return dictionary