game.ReplicatedStorage.SkillPoint.OnServerEvent:Connect(function(player, skill, amount)
	local playerDataManager = require(game.ServerScriptService.ServerModules.PlayerDataManager)
	local playerData = playerDataManager:getReadOnly(player)
	local movesetManager = require(game.ServerScriptService.ServerModules.MovesetManager)
	
	amount = tonumber(amount) or 1
	
	if playerData.SkillPointsRemaining > 0 and playerData.SkillPointsRemaining - tonumber(amount) >= 0 then
		playerDataManager:increaseSkill(player, skill, amount)
		local skillPointsLeft = playerDataManager:getReadOnly(player).SkillPointsRemaining --checks for new updated player info
		game.ReplicatedStorage.SkillPoint:FireClient(player, skill, skillPointsLeft)
		movesetManager:UpdatePlayerMoves(player)	
	else
		print("not enough SP to spend")
	end
end)
