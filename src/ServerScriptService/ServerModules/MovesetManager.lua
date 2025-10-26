--Module Script
local MovesetManager = {}
local PlayerDataManager = require(script.Parent.PlayerDataManager)

local RunService = game:GetService("RunService")

local Unlocks = {
	
	Sword = {
		{Level = 10, Move = "Slash"},
		{Level = 30, Move = "Slice n Dice"},
		{Level = 50, Move = "Flurry of Attacks"}
	},
	
	Gun = {
		{Level = 10, Move = "Quick Shot"},
		{Level = 30, Move = "Gun Barrage"},
		{Level = 50, Move = "Silence"}
	},
	
	Strength = {
		{Level = 10, Move = "Ground Slam"},
		{Level = 30, Move = "Starcrusher Jab"},
		{Level = 50, Move = "Meteor Dive"}
	},
	
	Speed = {
		
	}	
	
}

function MovesetManager:UpdatePlayerMoves(player : Player) 
	if RunService:IsClient() then
		warn("CANNOT RUN ON CLIENT! FIX")
		return
	end
	if not player then
		warn("Player not found")
		return
	end
	if not PlayerDataManager:getReadOnly(player) then
		warn("Player data not found")
		return
	end
	if not PlayerDataManager:getOriginalPlayerDataTable(player) then
		warn("Real Player data not found")
		return
	end
	
	local playerData = PlayerDataManager:getReadOnly(player)
	print(player.Name)
	local Skills = playerData.Skills
	local moveset = {}
	
	for skillName, UnlockableMoves in pairs(Unlocks) do
		if not Skills[skillName] then return end
		local playerSkillLevel = Skills[skillName] or 0
		for _, move in ipairs(UnlockableMoves) do
			if playerSkillLevel >= move.Level then
				moveset[move.Move] = true
			end
		end
	end
	print(player)
	PlayerDataManager:getOriginalPlayerDataTable(player).Moves = moveset
	PlayerDataManager:UpdateClient(player)
	
end

return MovesetManager
