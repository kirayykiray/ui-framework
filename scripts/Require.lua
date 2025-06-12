local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ButtonAnimation = require(ReplicatedStorage.ButtonAnimation)

for _, button in script.Parent:GetDescendants() do
	if button:IsA("GuiButton") then
		ButtonAnimation.Animate(button)
	end
end
