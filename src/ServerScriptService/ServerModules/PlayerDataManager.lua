--Module Script
local PlayerDataManager = {}

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local PlayerInfo = require(ServerStorage.Modules.PlayerInfo)
local PlayerInfoEvent = ReplicatedStorage.Remotes:WaitForChild("PlayerInfoEvent")

local playerData = {}

Players.PlayerAdded:Connect(function(player)
	local info = PlayerInfo.new(player)
	playerData[player] = info
	print("info: ")
	print(info)
	-- Send the initial data to the client
	PlayerInfoEvent:FireClient(player, info:GetData())
end)

Players.PlayerRemoving:Connect(function(player)
	playerData[player] = nil
end)

--===================Functions for cross-script data===================--

--Make sure to always keep type security when handling with sensitive 
--	data such as PlayerData and always put in checks.

-- availaible data:

--[[
Player = player
isParrying = false
secondsBeingStunnedFor = 0
parried = false
dodgeAmount = 60.0
SkillPointsRemaining = 100
Skills = {
	Sword = 0,
	Gun = 0,
	Strength = 0,
	Speed = 0
}
]]

--[[
	Get the ACTUAL player data of a player
	WARNING: !!!DONT STORE AS VARIABLE!!!
	@param player : Player
	@return playerData[player] : PlayerInfo
	@return nil if the player data is not found
]]
function PlayerDataManager:getOriginalPlayerDataTable(player : Player)
	--Checks 
	if RunService:IsClient() then
		warn("CANNOT RUN ON CLIENT! FIX")
		return
	end
	if player == nil then
		warn("Player is nil")
		return nil
	end
	if not player then 
		warn("Player not found")
		return nil
	end
	if not playerData[player] then
		warn("Player data not found for " .. player.Name)
		return nil
	end

	return playerData[player]
end

--[[
	Get a copy of the player data of a player
	@param player : Player
	@return playerData[player] : PlayerInfo
	@return nil if the player data is not found
]]
function PlayerDataManager:getReadOnly(player : Player)
	--Checks 
	if RunService:IsClient() then
		warn("CANNOT RUN ON CLIENT! FIX")
		return
	end
	if player == nil then
		warn("Player is nil")
		return nil
	end
	if not player then 
		warn("Player not found")
		return nil
	end
	if not playerData[player] then
		warn("Player data not found for " .. player.Name)
		return nil
	end
	
	return {
		SkillPointsRemaining = playerData[player].SkillPointsRemaining,
		Skills = table.clone(playerData[player].Skills),
		isParrying = playerData[player].isParrying,
		secondsBeingStunnedFor = playerData[player].secondsBeingStunnedFor,
		parried = playerData[player].parried,
		dodgeAmount = playerData[player].dodgeAmount,
		Moves = table.clone(playerData[player].Moves)
	}
end

--[[
	Increase the skill of a player // Updates client copy at end and decreases skill points by amount 
	@param player : Player // The Player who's skill will be increased
	@param skill : string // the skill to increase, check ServerStorage.Modules.PlayerInfo for options
	@param amountToIncreaseBy : number // The amount to increase the skill by
	@return 1 if successful
	@return -1 if unsuccessful
]]
function PlayerDataManager:increaseSkill(player : Player, skill : string, amountToIncreaseBy : number)
	--Checks
	local info = playerData[player]
	if RunService:IsClient() then
		warn("CANNOT RUN ON CLIENT! FIX")
		return
	end
	if not player then
		warn("Player not found")
		return -1
	end
	if not playerData[player] then
		warn("Player data not found for " .. player.Name)
		return -1
	end
	if not skill or not playerData[player].Skills[skill] then
		warn("Non-Existant Skill")
		return -1
	end
	if amountToIncreaseBy <= 0 then
		warn("Amount to increase by is less than or equal to 0")
		return - 1
	end
	if amountToIncreaseBy > playerData[player].SkillPointsRemaining then
		return -1
	end
	
	playerData[player].Skills[skill] += amountToIncreaseBy
	playerData[player].SkillPointsRemaining -= amountToIncreaseBy
	PlayerInfoEvent:FireClient(player, info:GetData())
	--print(playerData[player])
	return 1
end

function PlayerDataManager:UpdateClient(player : Player)
	if RunService:IsClient() then
		warn("CANNOT RUN ON CLIENT! FIX")
		return
	end
	if not player then return end
	PlayerInfoEvent:FireClient(player, playerData[player]:GetData())
end

--======================================================================--



















game.Workspace.Twelve.Touched:Connect(function(hit)
	if (hit.Parent:FindFirstChild("Humanoid")) then
		local char = hit.Parent
		print(playerData[game.Players:GetPlayerFromCharacter(char)]) 
	end
end)


return PlayerDataManager
