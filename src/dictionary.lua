dictionary = { minWordLength = 2, maxWordLength = 0}

function dictionary.initialize()	
	for line in love.filesystem.lines("resources/dictionary_en.txt") do
	  if (#line > dictionary.minWordLength) then
			if (dictionary[#line] == nil) then 
				dictionary[#line] = {}
				dictionary.maxWordLength = math.max(dictionary.maxWordLength, #line)
			end
			dictionary[#line][#dictionary[#line] + 1] = line
		end
	end
end

return dictionary