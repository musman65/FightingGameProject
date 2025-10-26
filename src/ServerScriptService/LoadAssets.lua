local ContentProvider = game:GetService("ContentProvider")
local assetsToLoad = {}

local serverModules = game:GetService("ServerScriptService"):WaitForChild("ServerModules")

for i, v in serverModules:GetChildren() do
	require(v)
end

game.Players.PlayerAdded:Connect(function(player)
	local char = player.Character or player.CharacterAdded:Wait()
	local hum : Humanoid = char:WaitForChild("Humanoid")
	local animations = player.Backpack.CombatClient:FindFirstChild("Animations")
	local animator : Animator = char:FindFirstChild("Humanoid").Animator
	hum.UseJumpPower = true
	hum.MaxHealth = 400
	hum.Health = 400
	if animator then
		for i, v in animations:GetChildren() do
			local anim  = animator:LoadAnimation(v)
			anim:Play()
			if anim.Name == "Block" or anim.Name == "BlockBreak" then
				task.wait(0.2)
				anim:Stop()
			end
		end
	end
	--task.wait(1)
	--require(serverModules.PlayerDataManager):increaseSkill(player, "Sword", 1)
	
end)

