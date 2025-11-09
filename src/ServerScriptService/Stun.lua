local Stun = {}
local DictionaryHandler = require(script.Parent.Library:WaitForChild("DictionaryHandler"))
local plrsHit = {}
local plrsSTUNNED = {
	--player = {true}
	
}

function Stun.stunPlayer(Char : Model, amountOfSecondsToStun : number, addStunEffect : boolean, blockBroken : boolean, parryStun : boolean)
	if parryStun == nil then
		parryStun = false
	end
	
	if addStunEffect == nil then
		addStunEffect = true
	end
	
	if blockBroken == nil  then
		blockBroken = false
	end
	if game:GetService("RunService"):IsClient() then print("client") end
	local playerDataManager = require(game.ServerScriptService.ServerModules.PlayerDataManager)
	local enemyHumanoid : Humanoid = Char:FindFirstChild("Humanoid")
	local enemyPlayer = game.Players:GetPlayerFromCharacter(Char)
	local playerData_RO = playerDataManager:getReadOnly(enemyPlayer)
	
	if enemyHumanoid then
		if plrsSTUNNED[enemyPlayer] == nil then
			plrsSTUNNED[enemyPlayer] = false
		end
		
		if plrsHit[enemyHumanoid] then
			if plrsHit[enemyHumanoid] < amountOfSecondsToStun then
				plrsHit[enemyHumanoid] = amountOfSecondsToStun * 10
			else
				return
			end
		else
			plrsHit[enemyHumanoid] = amountOfSecondsToStun * 10
		end
		
		if plrsSTUNNED[enemyPlayer] == true then
			if plrsHit[enemyHumanoid] < amountOfSecondsToStun * 10 then
				plrsHit[enemyHumanoid] = amountOfSecondsToStun * 10
			end
			return
		end
		
		plrsSTUNNED[enemyPlayer] = true
		
		if addStunEffect then
			DictionaryHandler.addTo(enemyHumanoid, "Stunned")
		end
		enemyHumanoid.WalkSpeed = 3
		enemyHumanoid.JumpPower = 0
		if blockBroken then
			local animator : Animator = enemyHumanoid:FindFirstChild("Animator")
			if not enemyPlayer then --It might be a dummy or an NPC
				local animation = Instance.new("Animation")
				animation.AnimationId = "rbxassetid://140322288579048" --BLOCK_BREAK
				local anim = animator:LoadAnimation(animation)
				anim:Play()
				task.spawn(function()
					task.wait(amountOfSecondsToStun)
					anim:Stop()
				end)
			else
				if animator then
					local anim = enemyPlayer.Backpack.CombatClient.Animations.BlockBreak
					local animation = animator:LoadAnimation(anim)
					animation:Play()
					task.spawn(function()
						task.wait(amountOfSecondsToStun)
						animation:Stop()
					end)
				end
			end
		end
		
		while task.wait(0.1) do
			if plrsSTUNNED[enemyPlayer] == false then
				break
			end
			if playerDataManager:getParried(enemyPlayer) and not parryStun then
				break
			end
			
			if plrsHit[enemyHumanoid] > 0 then
				plrsHit[enemyHumanoid] -= 1
			else
				plrsHit[enemyHumanoid] = nil
				if addStunEffect then
					DictionaryHandler.removeFrom(enemyHumanoid, "Stunned")
				end
				enemyHumanoid.WalkSpeed = 16
				enemyHumanoid.JumpPower = 50
				break
			end
		end
		
		--clean up
		plrsSTUNNED[enemyPlayer] = false
		plrsHit[enemyHumanoid] = nil
		if addStunEffect then
			DictionaryHandler.removeFrom(enemyHumanoid, "Stunned")
		end
		enemyHumanoid.WalkSpeed = 16
		enemyHumanoid.JumpPower = 50

	end
end


return Stun
