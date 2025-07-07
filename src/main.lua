---

## 🧩 `src/main.lua`

```lua
-- Improved Blox Fruits Remote GUI

local Orion = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local player = game.Players.LocalPlayer
local ws, rs = workspace, game.ReplicatedStorage

-- Performance optimization
for _, v in pairs(game:GetDescendants()) do
    if v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1 end
end

-- GUI
local window = Orion:MakeWindow({
  Name = "Blox Fruits GUI", IntroText = "Enhanced Remote Features",
  Theme = {Main = Color3.fromRGB(80,50,120), Accent = Color3.fromRGB(200,0,0)}
})

-- Internal states
local flags = {
  fruitESP = false,
  autoMelee = false,
  autoFruitMastery = false,
  autoGodhuman = false,
  autoSuperhuman = false,
  moneyFarm = false
}

-- 🥭 Fruit section
local fruitTab = window:MakeTab({Name="Fruits", Icon="", PremiumOnly=false})

fruitTab:AddToggle({
  Name = "ESP Fruits",
  Default = false,
  Callback = function(v)
    flags.fruitESP = v
    if v then
      spawn(function()
        while flags.fruitESP do
          for _, f in pairs(ws:GetDescendants()) do
            if f.Name:find("Fruit") and f:IsA("BasePart") then
              if not f:FindFirstChild("ESP") then
                local billboard = Instance.new("BillboardGui", f)
                billboard.Name = "ESP"
                billboard.Size = UDim2.new(0,100,0,50)
                billboard.Adornee = f
                local text = Instance.new("TextLabel", billboard)
                text.BackgroundTransparency = 1
                text.Text = f.Name
                text.TextColor3 = Color3.new(1,0,0)
              end
            end
          end
          task.wait(1)
        end
      end)
    else
      -- remove ESP
      for _, f in pairs(ws:GetDescendants()) do
        if f.Name:find("Fruit") and f:IsA("BasePart") then
          local e = f:FindFirstChild("ESP")
          if e then e:Destroy() end
        end
      end
    end
  end
})

fruitTab:AddButton({
  Name = "Teleport to Nearest Fruit",
  Callback = function()
    local nearest, dist = nil, math.huge
    for _, f in pairs(ws:GetDescendants()) do
      if f.Name:find("Fruit") and f:IsA("BasePart") then
        local d = (player.Character.HumanoidRootPart.Position - f.Position).Magnitude
        if d < dist then nearest, dist = f, d end
      end
    end
    if nearest then
      player.Character.HumanoidRootPart.CFrame = nearest.CFrame + Vector3.new(0,3,0)
    end
  end
})

-- 🧱 Farms section
local farmTab = window:MakeTab({Name="Farms", Icon="", PremiumOnly=false})

farmTab:AddToggle({
  Name = "Auto Melee Mastery",
  Default = false,
  Callback = function(v)
    flags.autoMelee = v
    spawn(function()
      while flags.autoMelee do
        local tool = player.Backpack:FindFirstChild("Combat") or player.Character:FindFirstChild("Combat")
        if tool then
          for _, npc in pairs(ws.Enemies:GetChildren()) do
            if npc:FindFirstChild("HumanoidRootPart") and npc.Humanoid.Health > 0 then
              player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0,10,0)
              rs.Remotes.Combat:FireServer(npc)
              task.wait(0.3)
            end
          end
        end
        task.wait(1)
      end
    end)
  end
})

farmTab:AddToggle({
  Name = "Auto Fruit Mastery",
  Default = false,
  Callback = function(v)
    flags.autoFruitMastery = v
    spawn(function()
      while flags.autoFruitMastery do
        rs.Remotes.SoulFruit:InvokeServer("Mastery")
        task.wait(1)
      end
    end)
  end
})

farmTab:AddToggle({
  Name = "Auto Godhuman Mastery",
  Default = false,
  Callback = function(v)
    flags.autoGodhuman = v
    spawn(function()
      while flags.autoGodhuman do
        rs.Remotes.FightingStyle:InvokeServer("Godhuman")
        task.wait(1)
      end
    end)
  end
})

farmTab:AddToggle({
  Name = "Auto Superhuman Mastery",
  Default = false,
  Callback = function(v)
    flags.autoSuperhuman = v
    spawn(function()
      while flags.autoSuperhuman do
        rs.Remotes.FightingStyle:InvokeServer("Superhuman")
        task.wait(1)
      end
    end)
  end
})

-- 💰 Money farm
farmTab:AddToggle({
  Name = "Money Farm",
  Default = false,
  Callback = function(v)
    flags.moneyFarm = v
    spawn(function()
      while flags.moneyFarm do
        for _, npc in pairs(ws.Enemies:GetChildren()) do
          if npc.Humanoid.Health > 0 then
            player.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0,10,0)
            rs.Remotes.Combat:FireServer(npc)
            task.wait(0.3)
          end
        end
        task.wait(5)
      end
    end)
  end
})

-- 🧭 Teleport section
local otherTab = window:MakeTab({Name="Teleports", Icon="", PremiumOnly=false})

otherTab:AddDropdown({
  Name = "Teleport to Island",
  Default = "Jungle",
  Options = {"Starter Island","Jungle","Pirate Village","Desert","Frozen Village","Marine Fortress","Sky Island","Colosseum","Magma Village","Underwater City","Fountain City","The Cafe","Haunted Castle","Hydra Island"},
  Callback = function(sel)
    local pts = {
      ["Starter Island"]=Vector3.new(100,10,-100),
      ["Jungle"]=Vector3.new(-1195,50,390),
      ["Pirate Village"]=Vector3.new(-1122,10,3400),
      ["Desert"]=Vector3.new(1150,10,4500),
      ["Frozen Village"]=Vector3.new(1200,10,-3000),
      ["Marine Fortress"]=Vector3.new(-4600,10,4400),
      ["Sky Island"]=Vector3.new(-800,500,1000),
      ["Colosseum"]=Vector3.new(-2500,10,-2000),
      ["Magma Village"]=Vector3.new(-6000,10,6000),
      ["Underwater City"]=Vector3.new(4000,-300,-2500),
      ["Fountain City"]=Vector3.new(5500,10,500),
      ["The Cafe"]=Vector3.new(-3850,10,160),
      ["Haunted Castle"]=Vector3.new(-9500,10,6200),
      ["Hydra Island"]=Vector3.new(5800,10,-12000)
    }
    local p = pts[sel]
    if p then player.Character.HumanoidRootPart.CFrame = CFrame.new(p) end
  end
})

-- Initialize
Orion:Init()
