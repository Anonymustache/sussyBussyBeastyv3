-- variables

local defaultsizes = {
	['Punch'] = Vector3.new(1.1,2,1.1),
	['Haymaker'] = Vector3.new(1.1,2,1.1),
	['Uppercut'] = Vector3.new(1.1,2,1.1),
	['Kick'] = Vector3.new(1.1,2.4,1.1),
}
local editedsizes = {
	['Punch'] = Vector3.new(1.2,2.1,1.2),
	['Haymaker'] = Vector3.new(1.2,2.1,1.2),
	['Uppercut'] = Vector3.new(1.2,2.1,1.2),
	['Kick'] = Vector3.new(1.2,2.5,1.2),
}
local tools = {}
local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hbetoggled = true
local visualizertoggled = false

-- ui

local function soundG(val)
	local soundx = Instance.new('Sound',plr.PlayerGui)
	soundx.SoundId = 'rbxassetid://2865227039'
	repeat
		wait()
	until soundx.Loaded
	soundx:Play()
	if val then
		Instance.new('PitchShiftSoundEffect',soundx)
	end
	game:GetService('Debris'):AddItem(soundx,soundx.TimeLength)
end
local ScreenGui = Instance.new("ScreenGui",game.CoreGui)
local Frame = Instance.new("Frame",ScreenGui)
local UIGridLayout = Instance.new("UIGridLayout",Frame)
local HBE = Instance.new("TextLabel",Frame)
local Visualizer = Instance.new("TextLabel",Frame)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 0,0.767, 0)
Frame.Size = UDim2.new(0.162, 0,0.233, 0)
Frame.BackgroundTransparency = 1
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.new(1, 0, .1, 0)
UIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
HBE.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HBE.BackgroundTransparency = 1.000
HBE.Size = UDim2.new(0, 200, 0, 50)
HBE.Font = Enum.Font.Ubuntu
HBE.Text = "[Z] HBE"
HBE.TextColor3 = Color3.fromRGB(0, 255, 0)
HBE.TextScaled = true
HBE.TextSize = 14.000
HBE.TextWrapped = true
HBE.TextXAlignment = Enum.TextXAlignment.Left
HBE.TextStrokeTransparency = 0
Visualizer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Visualizer.BackgroundTransparency = 1.000
Visualizer.Size = UDim2.new(0, 200, 0, 50)
Visualizer.Font = Enum.Font.Ubuntu
Visualizer.Text = "[N] HBEVisualizer"
Visualizer.TextColor3 = Color3.fromRGB(255, 0, 0)
Visualizer.TextScaled = true
Visualizer.TextSize = 14.000
Visualizer.TextWrapped = true
Visualizer.TextXAlignment = Enum.TextXAlignment.Left
Visualizer.TextStrokeTransparency = 0
game:GetService('UserInputService').InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Z then
		hbetoggled = not hbetoggled
		HBE.TextColor3 = hbetoggled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		for i,tool in next, tools do
			if tool:FindFirstChild("Part") then
				tool.Part.Size = hbetoggled and editedsizes[tool:GetAttribute('name')] or defaultsizes[tool:GetAttribute('name')]
			end
		end
		soundG(hbetoggled)
	elseif input.KeyCode == Enum.KeyCode.N then
		visualizertoggled = not visualizertoggled
		Visualizer.TextColor3 = visualizertoggled and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,0,0)
		for i,tool in next, tools do
			if tool:FindFirstChild("Part") then
				tool.Part.Transparency = visualizertoggled and .5 or 1
			end
		end
		soundG(visualizertoggled)
	end
end)


-- main

function modifyhitbox()
	tools = {}
	for i,_ in next, defaultsizes do
		coroutine.wrap(function()
			local tool = plr.Backpack:WaitForChild(i,math.huge)
			table.insert(tools,tool)
			tool:SetAttribute('name',i)
			tool.Equipped:Connect(function()
				repeat
					wait()
				until tool:FindFirstChild("Part")
				tool.Part.Size = hbetoggled and editedsizes[i] or defaultsizes[i]
				tool.Part.Transparency = visualizertoggled and .5 or 1
			end)
		end)()
	end
	for i,s in next, tools do
		print(i,s,type(s),typeof(s))
	end
end

plr.CharacterAdded:Connect(function(c)
	char = c
	modifyhitbox()
end)

modifyhitbox()
