--Module Script
-- PlayerInfoClient (client-side mirror) CLIENT ONLY
local PlayerInfoClient = {}
PlayerInfoClient.__index = PlayerInfoClient

function PlayerInfoClient.new()
	local self = setmetatable({}, PlayerInfoClient)
	self.isParrying = false
	self.secondsBeingStunnedFor = 0
	self.parried = false
	self.dodgeAmount = 60.0
	self.SkillPointsRemaining = 0
	self.Skills = { Sword = 0, Gun = 0, Strength = 0, Speed = 0 }
	self.Moves = { }
	--Sword = {}, Gun = {}, Strength = {}, Speed = {}
	return self
end

function PlayerInfoClient:Update(data) -- data is already a safe version
	self.isParrying = data.isParrying
	self.secondsBeingStunnedFor = data.secondsBeingStunnedFor
	self.parried = data.parried
	self.dodgeAmount = data.dodgeAmount
	self.SkillPointsRemaining = data.SkillPointsRemaining
	self.Skills = data.Skills
	self.Moves = data.Moves
end

function PlayerInfoClient:GetSkill(skill)
	return self.Skills[skill]
end

function PlayerInfoClient:GetSP()
	return self.SkillPointsRemaining
end

return PlayerInfoClient
