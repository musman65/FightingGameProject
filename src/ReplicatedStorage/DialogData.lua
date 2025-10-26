--Module Script
local module = {}
module.skip = false

local merchantDialog = {
	"What can I help you with today?",
	"Ok",
	"Im the store merchant, I sell various items and power-ups that help you fight."
}

local merchantButtons1 = {
	"I want to see your shop",
	"Who are you?"
}

local merchantButtons2 = {
	"I want to see your shop..."
}

function module.typeWriter(string : string, label)
	local originalSound = label.Parent.TextSound
	for i = 1, #string do
		if module.skip then
			label.Text = string
			return
		end
		local sound = originalSound:Clone()
		sound.Parent = label
		sound:Play()
		game.Debris:AddItem(sound, 0.9)
		label.Text = string.sub(string, 1, i)
		task.wait(0.025)
	end
end

function module.getMerchantDialog()
	return merchantDialog
end

function module.getMerchantButtons(set)
	if set == 1 then
		return merchantButtons1
	elseif set == 2 then
		return merchantButtons2
	end
end

return module
