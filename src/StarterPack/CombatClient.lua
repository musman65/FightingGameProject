--Modules
local GIM = require(game.ReplicatedStorage.Modules.GlobalInfo) --Global Info module
local dashModule = require(script.Parent.Dash)

--Services
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

--Instances
local plr = game.Players.LocalPlayer
local hum = plr.Character:WaitForChild("Humanoid")
local char = plr.Character
local animator : Animator = hum:WaitForChild("Animator")

--Finals
local punchCooldown = GIM.getCooldownInBetweenM1()
local punchCooldown2 = GIM.getPunchCooldownIfPunchWasNotThrown()
local cooldownAfterComboEnd = GIM.getCooldownAfterComboEnd()
local timeNeededToResetCombo = GIM.getTimeNeededToResetM1Combo()
local heavyPunchCooldown = GIM.getHeavyPunchCooldown()
local heavyPunchDashDuration = GIM.getHeavyPunchDashDuration()
local heavyPunchDashStrength = GIM.getHeavyPunchDashStrength()
local heavyPunchDashDirection = GIM.getHeavyPunchDashDirection()
local heavyPunchDashChecker = GIM.getHeavyPunchDashChecker()
local heavyPunchDelayToDash = GIM.getHeavyPunchDelayToDash()
local ceroCooldown = GIM.getCeroCooldown()
local ceroDuration = GIM.getCeroDuration()
local ceroExpandDuration = GIM.getCeroExpandDuration()
local ceroFadeAwayDuration = GIM.getCeroFadeAwayDuration()
local ceroSize = GIM.getCeroSize()

local dodgeBarRequirments = GIM.getDodgeBar()

--Variables
local ceroDebounce = false
local debounce = false
local lastPunchTime = 0
local currentPunchTime = 0
local comSeq = ""
local db2 = false
local heavyPunchDebounce = false
local devSpecDebounce = false
local barrageDebounce = false

UIS.InputBegan:Connect(function(input, IS)
	if IS == true then return end
	
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local target = plr:GetMouse().Target
		if target and (target.Parent:FindFirstChildOfClass("ClickDetector") or target.Parent.Parent:FindFirstChildOfClass("ClickDetector")) then
			return
		end
		
		if string.len(comSeq) == 3 then
			if db2 == false then
				db2 = true
				task.wait(cooldownAfterComboEnd)
				comSeq = "L"
				db2 = false
			end
		else
			if debounce == false then
				debounce = true
				currentPunchTime = tick()
				
				local passTime = currentPunchTime - lastPunchTime
				if passTime < timeNeededToResetCombo then
					comSeq = comSeq.."L"
					
					if string.len(comSeq) > 3 then
						comSeq = "L"
					end
				else
					comSeq = "L"
				end
				
				game.ReplicatedStorage.CombatHit:FireServer(comSeq)
			end
		end
	end
	
	if input.KeyCode == Enum.KeyCode.T then
		
	end
	
	if input.KeyCode == Enum.KeyCode.G then
		if plr.UserId == 105858383 then
			if devSpecDebounce == false then
				devSpecDebounce = true
				game.ReplicatedStorage.SuperPunch:FireServer()
				task.wait(1)
				devSpecDebounce = false
			end
		end
	end
	
	if input.KeyCode == Enum.KeyCode.E then
		if ceroDebounce == false then
			ceroDebounce = true
			game.ReplicatedStorage.Cero:FireServer()
			task.wait(ceroCooldown)
			ceroDebounce = false
		end
	end
	
	if input.KeyCode == Enum.KeyCode.R then
		if heavyPunchDebounce == false then
			heavyPunchDebounce = true
			dashModule.thrustForward(char, heavyPunchDashDuration, heavyPunchDashStrength, heavyPunchDashDirection, heavyPunchDashChecker, heavyPunchDelayToDash, 0.27)
			game.ReplicatedStorage.HeavyPunch:FireServer()
			task.wait(heavyPunchCooldown)
			heavyPunchDebounce = false
		end
	end
	
end)

game.ReplicatedStorage.CombatHit.OnClientEvent:Connect(function(canPunch)
	if canPunch then
		lastPunchTime = currentPunchTime
		task.wait(punchCooldown)
		debounce = false
	else
		task.wait(punchCooldown2)
		debounce = false
	end
end)

game.ReplicatedStorage.Cero.OnClientEvent:Connect(function(char, position : CFrame)
	local hrp : Part = char:FindFirstChild("HumanoidRootPart")
	local hum = char:FindFirstChild("Humanoid")
	local folder = game.ReplicatedStorage.Assets.Cero
	local sounds = game.ReplicatedStorage.Sounds

	local info = TweenInfo.new(ceroExpandDuration)

	local ceroClone = {}

	for i, v in folder:GetChildren() do
		local cero = v:Clone()
		cero.Name = "CERO"
		cero.Parent = game.Workspace
		cero.CFrame = position
		cero.Anchored = true
		cero.CanCollide = false
		table.insert(ceroClone, cero)
	end

	local travelDistance = ceroSize

	for i, v in ipairs(ceroClone) do
		local tween1 = TweenService:Create(v, info, {Size = v.Size + Vector3.new(travelDistance, 0, 0)})
		local tween2 = TweenService:Create(v, info, {Position = v.Position + v.CFrame.RightVector * (travelDistance / 2)})
		tween1:Play()
		tween2:Play()
	end
	sounds.Cero:Play()
	task.wait(ceroDuration)
	sounds.Cero:Stop()
	for i, v in ipairs(ceroClone) do
		local tween1 = TweenService:Create(v, TweenInfo.new(ceroFadeAwayDuration), {Size = Vector3.new(travelDistance, 0, 0)})
		tween1:Play()
		task.spawn(function()
			task.wait(ceroFadeAwayDuration)
			v:Destroy()
		end)
	end
end)
