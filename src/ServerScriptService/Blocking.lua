--Modules
local GIM = require(game.ReplicatedStorage.Modules.GlobalInfo)
local DictionaryHandler = require(game.ServerScriptService.Library.DictionaryHandler)

--Instances
local blocking = game.ReplicatedStorage.Blocking

--Finals
local parryWindow = GIM.getParryWindow()

--Variables
local isParrying = false

blocking.OnServerEvent:Connect(function(player, holdingDownF : boolean)
	local playerDataManager = require(game.ServerScriptService.ServerModules.PlayerDataManager)
	--local LI : ModuleScript = require(player.Backpack.LocalInfo)
	local char = player.Character
	local hum : Humanoid = char:WaitForChild("Humanoid")
	local animator : Animator = hum:WaitForChild("Animator")
	local animations = player.Backpack.CombatClient.Animations
	local anim : AnimationTrack = animator:LoadAnimation(animations.Block)
	anim.Priority = Enum.AnimationPriority.Action
	
	if holdingDownF then
		if not DictionaryHandler.findPlayer(hum, "Stunned") and not DictionaryHandler.findPlayer(hum, "Busy") and not DictionaryHandler.findPlayer(hum, "Blocking") then
			DictionaryHandler.addTo(hum, "Blocking")
			anim:Play()
			task.spawn(function()
				playerDataManager:getOriginalPlayerDataTable(player).isParrying = true
				playerDataManager:UpdateClient(player)
				--LI.isParrying = true
				task.wait(parryWindow)
				--LI.isParrying = false
				playerDataManager:getOriginalPlayerDataTable(player).isParrying = false
				playerDataManager:UpdateClient(player)
			end)
			hum.WalkSpeed = 3
			hum.JumpPower = 25
		else
			blocking:FireClient(player)
		end
	else
		DictionaryHandler.removeFrom(hum, "Blocking")
		for i, v in animator:GetPlayingAnimationTracks() do 
			if v.Name == "Block" then
				v:Stop()
			end
		end
		hum.WalkSpeed = 16
		hum.JumpPower = 50
	end
end)

game.ReplicatedStorage.BlockCheck.OnServerEvent:Connect(function(player)
	local hum = player.Character:FindFirstChild("Humanoid")
	game.ReplicatedStorage.BlockCheck:FireClient(player, DictionaryHandler.findPlayer(hum, "Blocking"))
end)
