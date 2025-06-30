if workspace:GetAttribute("DefinitelyHubLoaded") == true then return end
workspace:SetAttribute("DefinitelyHubLoaded",true)

local ArrayField = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua'))()

local Window = ArrayField:CreateWindow({
   Name = "Definitely Hub",
   LoadingTitle = "Definitely Hub",
   LoadingSubtitle = "by DefinitelyNiggerProductions",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DefinitelyNotAnESPSettings", -- Create a custom folder for your hub/game
      FileName = "SettingsAhh"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },
   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key", -- It is recommended to use something unique as other scripts using ArrayField may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like ArrayField to get the key from
      Actions = {
            [1] = {
                Text = 'Click here to copy the key link <--',
                OnPress = function()
                    print('Pressed')
                end,
                }
            },
      Key = {"Hello"}
   }
})

local ESPTab = Window:CreateTab("ESP", 4483362458)
local ESP_Section_Settings = ESPTab:CreateSection("Settings",false)
local ESP_Section_Info = ESPTab:CreateSection("Info",false)
local ESP_Section_Overwrite = ESPTab:CreateSection("Overwrite",false)

local ESPEnabled = false
local ESPDotEnabled = false

local ESPDotTransparency = .5

local ESPType = "Health"
local ESPDistance = 500
local ESPStaticColor = Color3.new(1,1,1)
local ESPFillTransparency = .9
local ESPOutlineTransparency = .2
local ESPOverwritePlayers = {}
local ESPOverwriteColor = Color3.new(1,1,1)
local ESPHighlightFriends = false

local ESPNametagEnabled = false
local ESPUsername = false
local ESPEquipped = false
local ESPBackpack = false
local ESPHealth = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPObjects = {}
local ESPDotObjects = {}
local ESPInfoObjects = {}

function CreateDot(Character)
		local Dot = Instance.new("BillboardGui")
		local Frame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		
		--Properties:
		
		Dot.Name = "Dot"
		Dot.Parent = Character.HumanoidRootPart
		Dot.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		Dot.Active = true
		Dot.AlwaysOnTop = true
		Dot.LightInfluence = 1.000
		Dot.Size = UDim2.new(1, 10, 1, 10)
		
		Frame.Parent = Dot
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BackgroundTransparency = 0.550
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(1, 0, 1, 0)
		
		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Frame

		return Dot
end

function RemoveDot(Character)
	if ESPDotObjects[Character] then
		ESPDotObjects[Character]:Destroy()
		ESPDotObjects[Character] = nil
	end
end

function ClearAllDots()
	for Character, Dot in pairs(ESPDotObjects) do
		if Dot then Dot:Destroy() end
	end
	ESPDotObjects = {}
end

function CreateInfo(Character)
	if ESPInfoObjects[Character] then return end

	local Player = Players:GetPlayerFromCharacter(Character)
	if not Player then return end

	local Info = Instance.new("BillboardGui")
	Info.Name = "ESPInfo"
	Info.Adornee = Character:FindFirstChild("HumanoidRootPart")
	Info.Parent = Character
	Info.AlwaysOnTop = true
	Info.Size = UDim2.new(1, 120, 1, 80)
	Info.StudsOffsetWorldSpace = Vector3.new(0, -3, 0)

	local Frame = Instance.new("Frame")
	Frame.Parent = Info
	Frame.Size = UDim2.new(1, 0, 1, 0)
	Frame.BackgroundTransparency = 1

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.Parent = Frame
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

	local function CreateLabel(Name)
			local Label = Instance.new("TextLabel")
			Label.Name = Name
			Label.TextTransparency = .4
			Label.Size = UDim2.new(1, 0, .1, 0)
			Label.BackgroundTransparency = 1
			Label.Font = Enum.Font.GothamBold
			Label.TextColor3 = Color3.new(1, 1, 1)
			Label.TextScaled = true
			Label.TextStrokeTransparency = 0.6
			Label.TextWrapped = true
			Label.Parent = Frame
			return Label
	end

	local Username = CreateLabel("Username")
	local Health = CreateLabel("Health")
	local Equipped = CreateLabel("Equipped")
	local Backpack = CreateLabel("Backpack")

	ESPInfoObjects[Character] = {
		GUI = Info,
		Username = Username,
		Health = Health,
		Equipped = Equipped,
		Backpack = Backpack,
		Player = Player,
	}
end


function CreateESP(Character)
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
    local Player = Players:GetPlayerFromCharacter(Character)
    if not Player or Player == LocalPlayer then return end

    if ESPObjects[Character] then return end

    local Highlight = Instance.new("Highlight")
    Highlight.Adornee = Character
    Highlight.Parent = Character
    Highlight.Name = "ESPHighlight"
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.FillTransparency = ESPFillTransparency
    Highlight.OutlineTransparency = ESPOutlineTransparency

    ESPObjects[Character] = Highlight
end

function UpdateESP()
    local InRange = 0
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = Player.Character.HumanoidRootPart
            local Distance = (HRP.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

            if Distance <= ESPDistance then
                InRange += 1
                CreateESP(Player.Character)

                local Highlight = ESPObjects[Player.Character]
                if Highlight then
                    local Color
                    if HighlightFriends and LocalPlayer:IsFriendsWith(Player.UserId) then
                        Color = ESPOverwriteColor
                    elseif ESPType == "Health" and Player.Character:FindFirstChild("Humanoid") then
                        local Health = Player.Character.Humanoid.Health / Player.Character.Humanoid.MaxHealth
                        Color = Color3.fromRGB(255 * (1 - Health), 255 * Health, 0)
                    elseif ESPType == "Distance" then
                        local Ratio = math.clamp(Distance / ESPDistance, 0, 1)
                        Color = Color3.fromRGB(255 * (1 - Ratio), 0, 255 * Ratio)
                    elseif ESPType == "Team Color" and Player.Team then
                        Color = Player.TeamColor.Color
										elseif ESPType == "Team Color" and Player.Team then
                        Color = Player.TeamColor.Color
                    else
                        Color = ESPStaticColor
                    end

                    Highlight.FillColor = Color
                    Highlight.OutlineColor = Color
                    Highlight.FillTransparency = ESPFillTransparency
                    Highlight.OutlineTransparency = ESPOutlineTransparency
                end
            else
                RemoveESP(Player.Character)
            end
        end
    end
    PlayersRange:Set("Players in Range: "..tostring(InRange))
end

function AddOrUpdateDot(Character, Player)
	if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
	if Player == LocalPlayer then return end

	local Dot = ESPDotObjects[Character]
	if not Dot then
		Dot = CreateDot(Character)
		Dot.Parent = Character.HumanoidRootPart
		ESPDotObjects[Character] = Dot
	end

	local Distance = (Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
	if Distance > ESPDistance then
		Dot.Enabled = false
		return
	else
		Dot.Enabled = true
	end

	local Color
	if ESPHighlightFriends and LocalPlayer:IsFriendsWith(Player.UserId) then
		Color = ESPOverwriteColor
	elseif ESPType == "Health" and Character:FindFirstChild("Humanoid") then
		local Humanoid = Character.Humanoid
		local HealthRatio = Humanoid.Health / Humanoid.MaxHealth
		Color = Color3.fromRGB(255 * (1 - HealthRatio), 255 * HealthRatio, 0)
	elseif ESPType == "Distance" then
		local Ratio = math.clamp(Distance / ESPDistance, 0, 1)
		Color = Color3.fromRGB(255 * (1 - Ratio), 0, 255 * Ratio)
	elseif ESPType == "Team Color" and Player.Team then
		Color = Player.TeamColor.Color
	else
		Color = ESPStaticColor
	end

	Dot.Frame.BackgroundColor3 = Color
	Dot.Frame.BackgroundTransparency = ESPDotTransparency
end

function UpdateInfo(Character)
	local InfoObj = ESPInfoObjects[Character]
	if not InfoObj then return end

	local Player = InfoObj.Player
	local Character = Player.Character
	if not Character or not Character:FindFirstChild("Humanoid") then return end

	local Humanoid = Character.Humanoid

	if ESPUsername then
		InfoObj.Username.Text = Player.Name
		InfoObj.Username.Visible = true
	else
		InfoObj.Username.Visible = false
	end

	if ESPHealth then
		InfoObj.Health.Text = "Health: " .. math.floor(Humanoid.Health)
		InfoObj.Health.Visible = true
	else
		InfoObj.Health.Visible = false
	end

	if ESPEquipped then
		local tool = Character:FindFirstChildOfClass("Tool")
		local equippedName = tool and tool.Name or "None"
		InfoObj.Equipped.Text = "Equipped: " .. equippedName
		InfoObj.Equipped.Visible = true
	else
		InfoObj.Equipped.Visible = false
	end

	if ESPBackpack then
		local items = {}
		for _, item in ipairs(Player.Backpack:GetChildren()) do
			if item:IsA("Tool") then
				table.insert(items, item.Name)
			end
		end
		InfoObj.Backpack.Text = "Backpack: " .. (next(items) and table.concat(items, ", ") or "Empty")
		InfoObj.Backpack.Visible = true
	else
		InfoObj.Backpack.Visible = false
	end
end

function RemoveESP(Character)
    if ESPObjects[Character] then
        ESPObjects[Character]:Destroy()
        ESPObjects[Character] = nil
    end
end

function ClearAllESP()
    for Character, ESP in pairs(ESPObjects) do
        if ESP then ESP:Destroy() end
    end
    ESPObjects = {}
end

function RemoveInfo(Character)
	if ESPInfoObjects[Character] then
		ESPInfoObjects[Character].GUI:Destroy()
		ESPInfoObjects[Character] = nil
	end
end

function ClearAllInfo()
	for char, data in pairs(ESPInfoObjects) do
		if data.GUI then data.GUI:Destroy() end
	end
	ESPInfoObjects = {}
end

local Toggle = ESPTab:CreateToggle({
   Name = "Toggle ESP",
   CurrentValue = false,
   Flag = "ESP_Toggle",
   Callback = function(Value)
       ESPEnabled = Value
   end;
   SectionParent = ESP_Section_Settings;
})

local ToggleDot = ESPTab:CreateToggle({
   Name = "Toggle Dot",
   CurrentValue = false,
   Flag = "ESP_Toggle_Dot",
   Callback = function(Value)
       ESPDotEnabled = Value
   end;
   SectionParent = ESP_Section_Settings;
})

local ESP_Color = ESPTab:CreateDropdown({
   Name = "ESP Color",
   Options = {"Health","Distance","Team Color","Static"},
   CurrentOption = "Health" or {"Distance","Team Color","Static"},
   MultiSelection = false,
   Flag = "ESP_Color",
   Callback = function(Option)
        ESPType = Option
        if Option == "Static" then
            ESP_StaticColor:Visible(true)
        else
            ESP_StaticColor:Visible(false)
        end
        
   end;
   SectionParent = ESP_Section_Settings;
})

ESP_StaticColor = ESPTab:CreateColorPicker({
   Name = "Static Color",
   Color = Color3.fromRGB(1,1,1),
   Flag = "ESPStaticColor",
   Callback = function(Value)
      ESPStaticColor = Value
   end;
   SectionParent = ESP_Section_Settings;
})
ESP_StaticColor:Visible(false)

local ESP_Distance = ESPTab:CreateSlider({
   Name = "Distance",
   Range = {0, 5000},
   Increment = 10,
   Suffix = "Studs",
   CurrentValue = 500,
   Flag = "ESPDistance",
   Callback = function(Value)
        ESPDistance = Value
   end;
   SectionParent = ESP_Section_Settings;
})

PlayersRange = ESPTab:CreateLabel("Players in Range: nil")

local ESP_FillTransparency = ESPTab:CreateSlider({
   Name = "Fill Transparency",
   Range = {0, 1},
   Increment = .05,
   Suffix = "",
   CurrentValue = .9,
   Flag = "ESPFillTransparency",
   Callback = function(Value)
      ESPFillTransparency = Value
   end;
   SectionParent = ESP_Section_Settings;
})

local ESP_OutlineTransparency = ESPTab:CreateSlider({
   Name = "Outline Transparency",
   Range = {0, 1},
   Increment = .05,
   Suffix = "",
   CurrentValue = .2,
   Flag = "ESPOutlineTransparency",
   Callback = function(Value)
      ESPOutlineTransparency = Value
   end;
   SectionParent = ESP_Section_Settings;
})

local ESP_OutlineTransparency = ESPTab:CreateSlider({
   Name = "Dot Transparency",
   Range = {0, 1},
   Increment = .05,
   Suffix = "",
   CurrentValue = .5,
   Flag = "ESPDotTransparency",
   Callback = function(Value)
      ESPDotTransparency = Value
   end;
   SectionParent = ESP_Section_Settings;
})


local ESP_HighlightFriends = ESPTab:CreateToggle({
    Name = "Highlight Friends",
    CurrentValue = false,
    Flag = "ESP_HighlightFriends",
    Callback = function(Value)
        ESPHighlightFriends = Value
    end,
    SectionParent = ESP_Section_Overwrite
})

local ESP_OverwriteColor = ESPTab:CreateColorPicker({
   Name = "Overwrite Color",
   Color = Color3.fromRGB(1,1,1),
   Flag = "ESPOverwriteColor",
   Callback = function(Value)
      ESPOverwriteColor = Value
        if ESPEnabled then
            UpdateESP()
        end
   end;
   SectionParent = ESP_Section_Overwrite;
})

local ESP_Info = ESPTab:CreateToggle({
    Name = "Toggle Info",
    CurrentValue = false,
    Flag = "ESP_Info",
    Callback = function(Value)
        ESPNametagEnabled = Value
    end,
    SectionParent = ESP_Section_Info
})

local ESP_Info_Username = ESPTab:CreateToggle({
    Name = "Show Username",
    CurrentValue = false,
    Flag = "ESP_Info_Username",
    Callback = function(Value)
        ESPUsername = Value
    end,
    SectionParent = ESP_Section_Info
})

local ESP_Info_Health = ESPTab:CreateToggle({
    Name = "Show Health",
    CurrentValue = false,
    Flag = "ESP_Info_Health",
    Callback = function(Value)
        ESPHealth = Value
    end,
    SectionParent = ESP_Section_Info
})

local ESP_Info_Equipped = ESPTab:CreateToggle({
    Name = "Show Equipped",
    CurrentValue = false,
    Flag = "ESP_Info_Equipped",
    Callback = function(Value)
        ESPEquipped = Value
    end,
    SectionParent = ESP_Section_Info
})

local ESP_Info_Backpack = ESPTab:CreateToggle({
    Name = "Show Backpack",
    CurrentValue = false,
    Flag = "ESP_Info_Backpack",
    Callback = function(Value)
        ESPBackpack = Value
    end,
    SectionParent = ESP_Section_Info
})

RunService.RenderStepped:Connect(function()
	if ESPEnabled then
		UpdateESP()
	else
		ClearAllESP()
	end

	if ESPDotEnabled then
		for _, Player in ipairs(Players:GetPlayers()) do
			if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
				AddOrUpdateDot(Player.Character, Player)
			end
		end
	else
		ClearAllDots()
	end

	if ESPNametagEnabled then
		for _, Player in ipairs(Players:GetPlayers()) do
			if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
				CreateInfo(Player.Character)
				UpdateInfo(Player.Character)
			end
		end
	else
		ClearAllInfo()
	end
end)

ArrayField:LoadConfiguration()
