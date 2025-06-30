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
local ESP_Section_Overwrite = ESPTab:CreateSection("Overwrite",false)

local ESPEnabled = false
local ESPColor = "Health"
local ESPDistance = 500
local ESPStaticColor = Color3.new(1,1,1)
local ESPFillTransparency = .9
local ESPOutlineTransparency = .2
local ESPOverwritePlayers = {}
local ESPOverwriteColor = Color3.new(1,1,1)
local ESPHighlightFriends = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ESPObjects = {}

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
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local HRP = Player.Character.HumanoidRootPart
            local Distance = (HRP.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude

            if Distance <= ESPDistance then
                CreateESP(Player.Character)

                local Highlight = ESPObjects[Player.Character]
                if Highlight then
                    local Color
                    if HighlightFriends and LocalPlayer:IsFriendsWith(Player.UserId) then
                        Color = ESPOverwriteColor
                    elseif ESPColor == "Health" and Player.Character:FindFirstChild("Humanoid") then
                        local Health = Player.Character.Humanoid.Health / Player.Character.Humanoid.MaxHealth
                        Color = Color3.fromRGB(255 * (1 - Health), 255 * Health, 0)
                    elseif ESPColor == "Distance" then
                        local Ratio = math.clamp(Distance / ESPDistance, 0, 1)
                        Color = Color3.fromRGB(255 * (1 - Ratio), 0, 255 * Ratio)
                    elseif ESPColor == "Team Color" and Player.Team then
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

local Toggle = ESPTab:CreateToggle({
   Name = "Toggle ESP",
   CurrentValue = false,
   Flag = "ESP_Toggle",
   Callback = function(Value)
       ESPEnabled = Value
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
        ESPColor = Option
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



RunService.RenderStepped:Connect(function()
    if ESPEnabled then
        UpdateESP()
    else
        ClearAllESP()
    end
end)

ArrayField:LoadConfiguration()
