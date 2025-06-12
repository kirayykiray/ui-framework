--// Credits for the original UI effects system: kirayykiray
--// Modifications (timing, logging) by AI Assistant.
local Affects = {}

--// Start timing the module load
local startTime = os.clock()

--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")

--// Tween Infos
local InfoQuick = TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local InfoHover = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

--// --- SPARKLE CONFIGURATION ---
local SPARKLE_ENABLED = true
local SPARKLE_TAG = "Sparkles"
local SPARKLE_COUNT = 20
local SPARKLE_SIZE = UDim2.fromOffset(12, 12)
local SPARKLE_DURATION = 1.5
local SPARKLE_SPREAD_RADIUS = 120
local SPARKLE_COLOR = Color3.new(1, 1, 1)
--// -----------------------------

--// --- CONFETTI CONFIGURATION ---
local CONFETTI_ENABLED = true
local CONFETTI_TAG = "Confetti"
local CONFETTI_COUNT = 30
local CONFETTI_SIZE = UDim2.fromOffset(8, 15)
local CONFETTI_DURATION = 1.6
local CONFETTI_SPREAD_RADIUS = 160
local CONFETTI_COLORS = { Color3.fromRGB(232, 72, 85), Color3.fromRGB(45, 156, 219), Color3.fromRGB(39, 174, 96), Color3.fromRGB(242, 201, 76), Color3.fromRGB(255, 121, 232), Color3.fromRGB(155, 89, 182) }
--// ------------------------------

--// --- EXPLOSION CONFIGURATION ---
local EXPLOSION_ENABLED = true
local EXPLOSION_TAG = "Explosion"
local EXPLOSION_PARTICLE_COUNT = 25
local EXPLOSION_DURATION = 0.8
local EXPLOSION_SPREAD_RADIUS = 200
local EXPLOSION_COLORS = { Color3.fromRGB(255, 120, 0), Color3.fromRGB(255, 190, 0), Color3.fromRGB(115, 115, 115), Color3.fromRGB(50, 50, 50) }
--// -------------------------------

--// --- SHATTER CONFIGURATION ---
local SHATTER_ENABLED = true
local SHATTER_TAG = "Shatter"
local SHATTER_COUNT = 25
local SHATTER_SIZE_RANGE = Vector2.new(8, 20)
local SHATTER_DURATION = 1.2
local SHATTER_SPREAD_RADIUS = 180
local SHATTER_ROTATION_SPEED = 720
local SHATTER_COLORS = { Color3.fromRGB(137, 207, 240), Color3.fromRGB(255, 255, 255), Color3.fromRGB(173, 216, 230) }
--// ------------------------------

--// --- GLITCH CONFIGURATION ---
local GLITCH_ENABLED = true
local GLITCH_TAG = "Glitch"
local GLITCH_BLOCK_COUNT = 15
local GLITCH_SHAKE_INTENSITY = 4
local GLITCH_COLORS = { Color3.fromRGB(255, 0, 0), Color3.fromRGB(0, 255, 255), Color3.fromRGB(0, 255, 0), Color3.fromRGB(0, 0, 0) }
--// ----------------------------



function Affects.Animate(button: GuiButton)
	--// Initial Setup
	button.AutoButtonColor = false -- ADDED: This disables the default engine hover/press effects, fixing the gray stroke issue.

	local OriginalSize = button.Size
	local OriginalPosition = button.Position
	local screenGui = button:FindFirstAncestorOfClass("ScreenGui")

	if not screenGui then
		warn("Affects.Animate: Button is not a descendant of a ScreenGui.", button)
		return
	end

	local isMouseCurrentlyOver = false

	local function scaleSize(size: UDim2, scaleFactor: number)
		return UDim2.new(size.X.Scale * scaleFactor, size.X.Offset * scaleFactor, size.Y.Scale * scaleFactor, size.Y.Offset * scaleFactor)
	end

	local HoverSize = scaleSize(OriginalSize, 1.05)
	local PressSize = scaleSize(OriginalSize, 0.95)

	local function TweenTo(size)
		TweenService:Create(button, InfoQuick, {Size = size}):Play()
	end

	--// --- Effect Creation Functions ---

	local function createSparkleEffect(origin: Vector2) for i=1,SPARKLE_COUNT do task.spawn(function() local p=Instance.new("Frame");p.AnchorPoint=Vector2.new(0.5,0.5);p.BackgroundColor3=SPARKLE_COLOR;p.BorderSizePixel=0;p.Size=SPARKLE_SIZE;p.Position=UDim2.fromOffset(origin.X,origin.Y);p.ZIndex=button.ZIndex+5;p.Parent=screenGui;local c=Instance.new("UICorner",p);c.CornerRadius=UDim.new(1,0);local a,d=math.random()*2*math.pi,math.random()*SPARKLE_SPREAD_RADIUS;local eP=UDim2.fromOffset(origin.X+(math.cos(a)*d),origin.Y+(math.sin(a)*d));local t=TweenService:Create(p,TweenInfo.new(SPARKLE_DURATION,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=eP,Size=UDim2.fromOffset(0,0),BackgroundTransparency=1,Rotation=math.random(-180,180)});t:Play();t.Completed:Wait();p:Destroy() end) end end
	local function createConfettiEffect(origin: Vector2) for i=1,CONFETTI_COUNT do task.spawn(function() local p=Instance.new("Frame");p.AnchorPoint=Vector2.new(0.5,0.5);p.BackgroundColor3=CONFETTI_COLORS[math.random(#CONFETTI_COLORS)];p.BorderSizePixel=0;p.Size=CONFETTI_SIZE;p.Position=UDim2.fromOffset(origin.X,origin.Y);p.ZIndex=button.ZIndex+5;p.Parent=screenGui;local a,d=math.random()*2*math.pi,math.random()*CONFETTI_SPREAD_RADIUS;local eP=UDim2.fromOffset(origin.X+(math.cos(a)*d),origin.Y+(math.sin(a)*d));local t=TweenService:Create(p,TweenInfo.new(CONFETTI_DURATION,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=eP,Size=UDim2.fromOffset(0,0),BackgroundTransparency=1,Rotation=math.random(-400,400)});t:Play();t.Completed:Wait();p:Destroy() end) end end
	local function createExplosionEffect(origin:Vector2) for i=1,EXPLOSION_PARTICLE_COUNT do task.spawn(function() local p=Instance.new("Frame");p.AnchorPoint=Vector2.new(0.5,0.5);p.BackgroundColor3=EXPLOSION_COLORS[math.random(#EXPLOSION_COLORS)];p.BorderSizePixel=0;p.Size=UDim2.fromOffset(math.random(15,30),math.random(15,30));p.Position=UDim2.fromOffset(origin.X,origin.Y);p.ZIndex=button.ZIndex+5;p.Parent=screenGui;local c=Instance.new("UICorner",p);c.CornerRadius=UDim.new(1,0);local a,d=math.random()*2*math.pi,math.random()*EXPLOSION_SPREAD_RADIUS;local eP=UDim2.fromOffset(origin.X+(math.cos(a)*d),origin.Y+(math.sin(a)*d));local t=TweenService:Create(p,TweenInfo.new(EXPLOSION_DURATION,Enum.EasingStyle.Cubic,Enum.EasingDirection.Out),{Position=eP,Size=UDim2.fromOffset(0,0),BackgroundTransparency=1,Rotation=math.random(-270,270)});t:Play();t.Completed:Wait();p:Destroy() end) end task.spawn(function() local s=Instance.new("Frame");s.AnchorPoint=Vector2.new(0.5,0.5);s.BackgroundTransparency=1;s.Size=UDim2.fromOffset(0,0);s.Position=UDim2.fromOffset(origin.X,origin.Y);s.ZIndex=button.ZIndex+4;s.Parent=screenGui;local c=Instance.new("UICorner",s);c.CornerRadius=UDim.new(1,0);local k=Instance.new("UIStroke",s);k.Color=Color3.new(1,1,1);k.Thickness=6;local t=TweenService:Create(s,TweenInfo.new(0.4,Enum.EasingStyle.Linear),{Size=UDim2.fromOffset(EXPLOSION_SPREAD_RADIUS*1.5,EXPLOSION_SPREAD_RADIUS*1.5),BackgroundTransparency=1});local st=TweenService:Create(k,TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Transparency=1,Thickness=0});t:Play();st:Play();t.Completed:Wait();s:Destroy() end) task.spawn(function() local f=Instance.new("Frame");f.AnchorPoint=Vector2.new(0.5,0.5);f.BackgroundColor3=Color3.new(1,1,1);f.BorderSizePixel=0;f.Size=UDim2.fromOffset(EXPLOSION_SPREAD_RADIUS,EXPLOSION_SPREAD_RADIUS);f.Position=UDim2.fromOffset(origin.X,origin.Y);f.ZIndex=button.ZIndex+6;f.Parent=screenGui;local c=Instance.new("UICorner",f);c.CornerRadius=UDim.new(1,0);local t=TweenService:Create(f,TweenInfo.new(0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{BackgroundTransparency=1});t:Play();t.Completed:Wait();f:Destroy() end) end
	local function createShatterEffect(origin: Vector2) for i=1,SHATTER_COUNT do task.spawn(function() local sS=math.random(SHATTER_SIZE_RANGE.X,SHATTER_SIZE_RANGE.Y);local p=Instance.new("Frame");p.AnchorPoint=Vector2.new(0.5,0.5);p.BackgroundColor3=SHATTER_COLORS[math.random(#SHATTER_COLORS)];p.BorderSizePixel=0;p.Size=UDim2.fromOffset(sS,sS);p.Position=UDim2.fromOffset(origin.X,origin.Y);p.ZIndex=button.ZIndex+5;p.Parent=screenGui;local c=Instance.new("UICorner",p);c.CornerRadius=UDim.new(0,4);local a,d=math.random()*2*math.pi,math.random()*SHATTER_SPREAD_RADIUS;local eP=UDim2.fromOffset(origin.X+(math.cos(a)*d),origin.Y+(math.sin(a)*d));local fR=p.Rotation+(math.sign(math.random(-1,1))*SHATTER_ROTATION_SPEED*SHATTER_DURATION);local t=TweenService:Create(p,TweenInfo.new(SHATTER_DURATION,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=eP,BackgroundTransparency=1,Rotation=fR});t:Play();t.Completed:Wait();p:Destroy() end) end end
	local function createGlitchEffect(origin:Vector2) for i=1,GLITCH_BLOCK_COUNT do task.spawn(function() local a,d=math.random()*2*math.pi,math.random()*40;local pos=UDim2.fromOffset(origin.X+(math.cos(a)*d),origin.Y+(math.sin(a)*d));local p=Instance.new("Frame");p.AnchorPoint=Vector2.new(0.5,0.5);p.BackgroundColor3=GLITCH_COLORS[math.random(#GLITCH_COLORS)];p.BorderSizePixel=0;p.Size=UDim2.fromOffset(math.random(5,15),math.random(10,20));p.Position=pos;p.ZIndex=button.ZIndex+5;p.Parent=screenGui;task.wait(math.random()*0.15);p:Destroy() end) end task.spawn(function() local sTI=TweenInfo.new(0.05,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut);for i=1,3 do local sX=OriginalPosition.X.Offset+math.random(-GLITCH_SHAKE_INTENSITY,GLITCH_SHAKE_INTENSITY);local sY=OriginalPosition.Y.Offset+math.random(-GLITCH_SHAKE_INTENSITY,GLITCH_SHAKE_INTENSITY);local nP=UDim2.new(OriginalPosition.X.Scale,sX,OriginalPosition.Y.Scale,sY);TweenService:Create(button,sTI,{Position=nP}):Play();task.wait(0.05) end;TweenService:Create(button,sTI,{Position=OriginalPosition}):Play() end) end

	--// Event Connections
	local enterConnection = button.MouseEnter:Connect(function() 
		isMouseCurrentlyOver = true
		TweenTo(HoverSize)
	end)

	local leaveConnection = button.MouseLeave:Connect(function() 
		isMouseCurrentlyOver = false
		TweenTo(OriginalSize) 
	end)

	local downConnection = button.MouseButton1Down:Connect(function()
		TweenTo(PressSize)

		local guiInset = GuiService:GetGuiInset()
		local correctedMousePos = UserInputService:GetMouseLocation() - guiInset

		if SPARKLE_ENABLED and CollectionService:HasTag(button, SPARKLE_TAG) then createSparkleEffect(correctedMousePos) end
		if CONFETTI_ENABLED and CollectionService:HasTag(button, CONFETTI_TAG) then createConfettiEffect(correctedMousePos) end
		if EXPLOSION_ENABLED and CollectionService:HasTag(button, EXPLOSION_TAG) then createExplosionEffect(correctedMousePos) end
		if SHATTER_ENABLED and CollectionService:HasTag(button, SHATTER_TAG) then createShatterEffect(correctedMousePos) end
		if GLITCH_ENABLED and CollectionService:HasTag(button, GLITCH_TAG) then createGlitchEffect(correctedMousePos) end
	end)

	local upConnection = button.MouseButton1Up:Connect(function() if isMouseCurrentlyOver then TweenTo(HoverSize) end end)

	--// Cleanup
	button.Destroying:Once(function()
		enterConnection:Disconnect(); leaveConnection:Disconnect(); downConnection:Disconnect(); upConnection:Disconnect()
	end)
end

--// Wait for the next frame
task.wait() 

--// Check Loading Time
local loadTimeMs = (os.clock() - startTime) * 1000
print(string.format("✅ | UI Framework loaded in %.0fms", loadTimeMs))

return Affects
