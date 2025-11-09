local module = {}

function module.thrustForward(char, dashDuration : number, dashStrength : number, direction : String, checker : string, delayToDash : number)
	local block = if string.sub(checker, 1, 1) == "1" then true else false
	local stun = if string.sub(checker, 2, 2) == "1" then true else false
	local busy = if string.sub(checker, 3, 3) == "1" then true else false
	
	
	game.ReplicatedStorage.AllCheck:FireServer(block, stun, busy)
	game.ReplicatedStorage.AllCheck.OnClientEvent:Connect(function(checkStatus)
	
		if checkStatus then
			if delayToDash == nil then
				delayToDash = 0
			end

			if dashDuration == 0 or dashDuration == nil then
				dashDuration = 0.35
			end

			if dashStrength == 0 or dashStrength == nil then
				dashStrength = 100
			end

			local hum : Humanoid = char:FindFirstChild("Humanoid")
			local hrp = char:FindFirstChild("HumanoidRootPart")

			local bv = Instance.new("BodyVelocity")
			bv.MaxForce = Vector3.new(100000000, 0, 100000000)
			bv.Parent = hrp

			local dashDuration = dashDuration
			local rate = 0.01

			local dashStrength  = dashStrength
			local minimumDashStrength = dashStrength * 0.15
			local amountOfIterations = dashDuration / rate
			local removalOfStrengthPerIteration = dashStrength / amountOfIterations
			local humDirection
			
			if direction == "i" then
				humDirection = hrp.CFrame.LookVector
			elseif direction == "-i" then
				humDirection = hrp.CFrame.LookVector * -1
			elseif direction == "-j" then
				humDirection = hrp.CFrame.RightVector * -1
			elseif direction == "j" then
				humDirection = hrp.CFrame.RightVector
			elseif direction == "MoveDirection" then
				if hum.MoveDirection == Vector3.new(0, 0, 0) then
					humDirection = hrp.CFrame.LookVector
				else
					humDirection = hum.MoveDirection
				end
			else
				humDirection = hrp.CFrame.LookVector
			end
			
			local part1 = Instance.new("Part")
			part1.Name = "DashPart"
			local weld = Instance.new("WeldConstraint")
			local relativeDir = hrp.CFrame:VectorToObjectSpace(humDirection)

			part1.CFrame = CFrame.new(hrp.Position + humDirection, humDirection)
			weld.Part1 = part1
			weld.Part0 = hrp
			weld.Parent = char
			part1.Parent = char
			part1.Transparency = 1
			part1.Anchored = false
			part1.CanCollide = false
			part1.Size = Vector3.new(2.5, .5 , .5)

			task.wait(delayToDash)

			for i = 0, dashDuration, rate do
				local parts = game.Workspace:GetPartsInPart(part1)

				for _, v in pairs(parts) do
					if not v:IsDescendantOf(char) and not v:IsDescendantOf(game.Workspace.HitboxClones) then
						print(v)
						bv:Destroy()
						part1:Destroy()
						break
					end
				end

				bv.Velocity = humDirection * dashStrength
				if dashStrength > minimumDashStrength then
					dashStrength -= removalOfStrengthPerIteration

					if dashStrength < minimumDashStrength then
						dashStrength = minimumDashStrength
					end
				end

				task.wait(rate)
			end
			if part1 then
				part1:Destroy()
			end
			weld:Destroy()
			bv:Destroy()
		else
			print("Player did not pass the check status // DashModule")
		end
	end)
end

return module
