--Module Sript
-- PlayerInfo (server-side class)
local PlayerInfo = {}
PlayerInfo.__index = PlayerInfo

--[[
When adding or removing anything from the table,
	make sure to also modify these functions:
	- PlayerInfo.new 				// Check : 
	- PlayerInfo:GetData 			// Check : 
	- PlayerInfoClient.new 			// Check : 
	- PlayerInfoClient:Update 		// Check : 
	- PlayerDataManager:getReadOnly // Check : 
	
	ALWAYS DO IT FIRST, in case you forget! Don't wait until later.
	Last Update = 25/10/2025 Added Moves table
]]

function PlayerInfo.new(player)
	local self = setmetatable({}, PlayerInfo)
	self.Player = player
	self.isParrying = false
	self.secondsBeingStunnedFor = 0
	self.parried = false
	self.dodgeAmount = 60.0
	self.SkillPointsRemaining = 100
	self.Skills = {
		Sword = 0,
		Gun = 0,
		Strength = 0,
		Speed = 0
	}
	self.Moves = {
		
	}
	return self
end

-- Methods
function PlayerInfo:SetSkill(skill, amount)
	if self.Skills[skill] then
		self.Skills[skill] += amount
	end
end

function PlayerInfo:GetSkill(skill)
	return self.Skills[skill]
end

function PlayerInfo:GetData()
	-- Return a *safe copy* for the client
	return {
		SkillPointsRemaining = self.SkillPointsRemaining,
		Skills = table.clone(self.Skills),
		isParrying = self.isParrying,
		secondsBeingStunnedFor = self.secondsBeingStunnedFor,
		parried = self.parried,
		dodgeAmount = self.dodgeAmount,
		Moves = table.clone(self.Moves)
	}
end

return PlayerInfo
