--Modules
local GIM = require(game.ReplicatedStorage.Modules.GlobalInfo)

--Services
local UIS = game:GetService("UserInputService")

--Instances
local blocking = game.ReplicatedStorage.Blocking
local blockCheck = game.ReplicatedStorage.BlockCheck
local player = game.Players.LocalPlayer
local char = player.Character
local hum = char:WaitForChild("Humanoid")
local animator : Animator = hum:WaitForChild("Animator")

--Finals
local cd = GIM.getBlockingCooldown()
local blockBreakStun = GIM.getStunDurationBlockBreak()

--Variables
local debounce = false

UIS.InputBegan:Connect(function(input, IS)
	if IS then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		if debounce == false then
			debounce = true
			blocking:FireServer(true)
		end
	end
end)

UIS.InputEnded:Connect(function(input, IS)
	if IS then return end
	
	if input.KeyCode == Enum.KeyCode.F then
		blockCheck:FireServer()
		blockCheck.OnClientEvent:Connect(function(blockingBoolean)
			if blockingBoolean then
				blocking:FireServer(false)
				task.wait(cd)
				debounce = false
			end
		end)
	end
end)



blocking.OnClientEvent:Connect(function(blockBreak)
	if blockBreak then
		task.wait(blockBreakStun)
		debounce = false
	else
		debounce = true
		task.wait(cd)
		debounce = false
	end
end)
