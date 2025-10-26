--Module Script
local module = {}

--Skill Tree move requirements
local dodgeBar = {100, "Speed"}


-- M1 info
local damageM1 = 10
local cooldownInBetweenM1 = 0.5
local punchCooldownIfPunchWasNotThrown = 0.1
local cooldownAfterComboEnd = 0.75
local timeNeededToResetM1Combo = 1
local hitboxDurationM1 = 0.25
local stunDurationM1 = 0.75

-- Heavy punch info
local heavyPunchCooldown = 2.5
local stunDurationBlockBreak = 3
local damageHeavyPunch = 15
local heavyPunchBlockBreak = true
local heavyPunchDashDuration = 0.15
local heavyPunchDashStrength = 100
local heavyPunchDashDirection = "i"
local heavyPunchDashChecker = "111"
local heavyPunchDelayToDash = 0.27

-- Blocking info
local blockingCooldown = 0.05
local parryWindow
local parryStun
if game:GetService("RunService"):IsStudio() then
	parryWindow = 2
	parryStun = 10
else
	parryWindow = 0.1
	parryStun = 1
end

--Cero info
local ceroCooldown = 2.5
local ceroSize = 200
local ceroDuration = 0.95
local ceroExpandDuration = 0.25
local ceroFadeAwayDuration = 0.175


-- Dashing info
local dashCooldown = 1
local dashDuration = 0.35
local dashStrength = 100

-- M1 Getters
function module.getDamageM1()
	return damageM1
end

function module.getCooldownInBetweenM1()
	return cooldownInBetweenM1
end

function module.getPunchCooldownIfPunchWasNotThrown()
	return punchCooldownIfPunchWasNotThrown
end

function module.getCooldownAfterComboEnd()
	return cooldownAfterComboEnd
end

function module.getTimeNeededToResetM1Combo()
	return timeNeededToResetM1Combo
end

function module.getHitboxDurationM1()
	return hitboxDurationM1
end

function module.getStunDurationM1()
	return stunDurationM1
end

-- Heavy Punch Getters
function module.getHeavyPunchCooldown()
	return heavyPunchCooldown
end

function module.getStunDurationBlockBreak()
	return stunDurationBlockBreak
end

function module.getDamageHeavyPunch()
	return damageHeavyPunch
end

function module.getHeavyPunchBlockBreak()
	return heavyPunchBlockBreak
end

function module.getHeavyPunchDashDuration()
	return heavyPunchDashDuration
end

function module.getHeavyPunchDashStrength()
	return heavyPunchDashStrength
end

function module.getHeavyPunchDashDirection()
	return heavyPunchDashDirection
end

function module.getHeavyPunchDashChecker()
	return heavyPunchDashChecker
end

function module.getHeavyPunchDelayToDash()
	return heavyPunchDelayToDash
end

-- Blocking Getters
function module.getBlockingCooldown()
	return blockingCooldown
end

function module.getParryWindow()
	return parryWindow
end

function module.getParryStun()
	return parryStun
end

-- Dashing Getters
function module.getDashCooldown()
	return dashCooldown
end

function module.getDashDuration()
	return dashDuration
end

function module.getDashStrength()
	return dashStrength
end

--Cero Getters

function module.getCeroCooldown()
	return ceroCooldown
end

function module.getCeroDuration()
	return ceroDuration
end

function module.getCeroExpandDuration()
	return ceroExpandDuration
end

function module.getCeroFadeAwayDuration()
	return ceroFadeAwayDuration
end

function module.getCeroSize()
	return ceroSize
end

-- Skill Tree Getters

function module.getDodgeBar()
	return dodgeBar
end

return module
