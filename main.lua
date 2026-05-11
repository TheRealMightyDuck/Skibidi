local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local UnitsFolder = workspace:WaitForChild("Troops")

-- 📦 GUI
local gui = Instance.new("ScreenGui")
gui.Name = "UnitTrackerGui"
gui.ResetOnSpawn = false
gui.Parent = Player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 420)
frame.Position = UDim2.new(0, 10, 0.25, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🧠 Unit Tracker"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Parent = frame

-- 📜 SCROLLING FRAME
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 6
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.Parent = frame

local list = Instance.new("UIListLayout")
list.Padding = UDim.new(0, 5)
list.Parent = scroll

-- 🧠 DATA
local entries = {}

-- ⏱️ GLOBAL CLOCK (STARTS WHEN SCRIPT RUNS)
local StartTime = os.clock()

-- ⏱️ FORMAT TIME
local function formatTime(seconds)
	if seconds < 60 then
		return math.floor(seconds) .. "s"
	elseif seconds < 3600 then
		return math.floor(seconds / 60) .. "m"
	else
		return math.floor(seconds / 3600) .. "h"
	end
end

-- 📊 LEVEL
local function getLevel(unit)
	local lvl = unit:FindFirstChild("TroopLevel")
	if lvl and lvl:IsA("IntValue") then
		return lvl.Value
	end
	return 0
end

-- 📍 POSITION
local function getPos(unit)
	local hrp = unit:FindFirstChild("HumanoidRootPart")
	if hrp then
		local p = hrp.Position
		return math.floor(p.X), math.floor(p.Y), math.floor(p.Z)
	end
	return 0, 0, 0
end

-- 🧠 CREATE ENTRY (SNAPSHOT TIME HERE)
local function createEntry(unit)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -10, 0, 80)
	label.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	label.BorderSizePixel = 0
	label.TextColor3 = Color3.fromRGB(255, 255, 255)
	label.TextWrapped = true
	label.TextScaled = true
	label.Parent = scroll

	entries[unit] = label

	-- ⏱️ SNAPSHOT TIME (FREEZES FOR THIS UNIT)
	local spawnTime = os.clock() - StartTime

	local x, y, z = getPos(unit)

	label.Text =
		"🧱 " .. unit.Name ..
		"\n⭐ Level: " .. getLevel(unit) ..
		"\n📍 X:" .. x .. " Y:" .. y .. " Z:" .. z ..
		"\n⏱️ Placed At: " .. formatTime(spawnTime)
end

-- ❌ REMOVE
local function removeEntry(unit)
	if entries[unit] then
		entries[unit]:Destroy()
		entries[unit] = nil
	end
end

-- ➕ EXISTING
for _, unit in ipairs(UnitsFolder:GetChildren()) do
	createEntry(unit)
end

-- ➕ NEW
UnitsFolder.ChildAdded:Connect(function(unit)
	task.wait(0.1)
	createEntry(unit)
end)

-- ❌ REMOVED
UnitsFolder.ChildRemoved:Connect(function(unit)
	removeEntry(unit)
end)
