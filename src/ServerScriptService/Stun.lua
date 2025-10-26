--Module Script
local Stun = {}
local DictionaryHandler = require(script.Parent.Library:WaitForChild("DictionaryHandler"))

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
	local plrsHit = {}
	local LIM = require(game.Players:GetPlayerFromCharacter(Char).Backpack.LocalInfo)
	local enemyHumanoid : Humanoid = Char:FindFirstChild("Humanoid")
	local enemyPlayer = game.Players:GetPlayerFromCharacter(Char)
	
	if enemyHumanoid then
		if LIM.secondsBeingStunnedFor < amountOfSecondsToStun then
			plrsHit[enemyHumanoid] = amountOfSecondsToStun * 10
		else
			plrsHit[enemyHumanoid] = LIM.secondsBeingStunnedFor * 10
		end
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
			if LIM.parried and not parryStun then
				break
			end
			
			if plrsHit[enemyHumanoid] > 0 then
				plrsHit[enemyHumanoid] -= 1
				LIM.secondsBeingStunnedFor = plrsHit[enemyHumanoid] / 10
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
	end
end


return Stun
