--Module Script
local Dictionary = require(script:WaitForChild("Dictionary"))

local DictionaryHandler = {}

function DictionaryHandler.addTo(PlayerHumanoid, Action)
	Dictionary[Action][PlayerHumanoid] = true
end

function DictionaryHandler.removeFrom(PlayerHumanoid, Action)
	Dictionary[Action][PlayerHumanoid] = nil
end

function DictionaryHandler.findPlayer(PlayerHumanoid, Action)
	return Dictionary[Action][PlayerHumanoid]
end

return DictionaryHandler
