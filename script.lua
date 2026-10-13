-- ============================================
-- CLOES MENU v14.0 | HACKER EDITION
-- By Cloes | Fixed by CoconutYZ
-- ============================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "CLOES MENU v14 | HACKER EDITION",
   LoadingTitle = "Cloes yükleniyor...",
   LoadingSubtitle = "By Cloes",
   ConfigurationSaving = {Enabled = true, FolderName = "CloesV14", FileName = "CloesHack"},
   KeySystem = false
})

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera
local lighting = game:GetService("Lighting")
local rs = game:GetService("ReplicatedStorage")
local vim = game:GetService("VirtualInputManager")
local plrs = game:GetService("Players")

player.CharacterAdded:Connect(function(c)
    char = c
    humanoid = c:WaitForChild("Humanoid")
    root = c:WaitForChild("HumanoidRootPart")
end)

-- ============================================
-- AKILLI EVENT BULUCU
-- ============================================
local function findRemoteEvent(...)
    local names = {...}
    local found = {}
    local searchTargets = {rs, workspace}
    for _, container in ipairs(searchTargets) do
        if container then
            for _, v in pairs(container:GetDescendants()) do
                if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                    local lower = v.Name:lower()
                    for _, n in ipairs(names) do
                        if lower:find(n:lower()) then
                            table.insert(found, v)
                            break
                        end
                    end
                end
            end
        end
    end
    return found
end

local function fireAll(events, ...)
    for _, e in ipairs(events) do
        pcall(function()
            if e:IsA("RemoteEvent") then
                e:FireServer(...)
            elseif e:IsA("RemoteFunction") then
                e:InvokeServer(...)
            end
        end)
    end
end

-- ============================================
-- AKILLI TELEPORT SİSTEMİ
-- ============================================
local TeleportUtil = {}

function TeleportUtil.getRoot()
    return root or (char and char:FindFirstChild("HumanoidRootPart"))
end

function TeleportUtil.findPartByName(keyword)
    keyword = keyword:lower():gsub("%s", "")
    local best, bestDist = nil, math.huge
    local r = TeleportUtil.getRoot()
    if not r then return nil end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v:FindFirstAncestorOfClass("Tool") then
            local n = v.Name:lower():gsub("%s", "")
            if n:find(keyword) then
                local d = (v.Position - r.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = v
                end
            end
        end
    end
    return best
end

function TeleportUtil.findModelByName(keyword)
    keyword = keyword:lower():gsub("%s", "")
    local best, bestDist = nil, math.huge
    local r = TeleportUtil.getRoot()
    if not r then return nil end
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") then
            local n = v.Name:lower():gsub("%s", "")
            if n:find(keyword) then
                local part = v:FindFirstChildWhichIsA("BasePart") or v.PrimaryPart
                if part then
                    local d = (part.Position - r.Position).Magnitude
                    if d < bestDist then
                        bestDist = d
                        best = part
                    end
                end
            end
        end
    end
    return best
end

function TeleportUtil.findInContainer(keyword)
    keyword = keyword:lower():gsub("%s", "")
    for _, container in pairs(workspace:GetChildren()) do
        if container:IsA("Folder") or container:IsA("Model") then
            local cn = container.Name:lower():gsub("%s", "")
            if cn:find(keyword) then
                local part = container:FindFirstChildWhichIsA("BasePart")
                if part then return part end
            end
        end
    end
    return nil
end

function TeleportUtil.teleportTo(keyword, yOffset)
    yOffset = yOffset or 5
    local r = TeleportUtil.getRoot()
    if not r then return false, nil end
    local part = TeleportUtil.findPartByName(keyword)
    if not part then part = TeleportUtil.findModelByName(keyword) end
    if not part then part = TeleportUtil.findInContainer(keyword) end
    if part then
        r.CFrame = CFrame.new(part.Position + Vector3.new(0, yOffset, 0))
        return true, part
    end
    return false, nil
end

function TeleportUtil.debugList()
    print("=== WORKSPACE İÇERİĞİ ===")
    for _, v in pairs(workspace:GetChildren()) do
        print(v.ClassName .. " | " .. v.Name)
    end
end

-- ============================================
-- STEALTH SEKMESİ
-- ============================================
local StealthTab = Window:CreateTab("🛡️ Stealth", 4483362458)
StealthTab:CreateSection("Ban Koruması")

StealthTab:CreateToggle({
   Name = "Anti-Cheat Bypass (Full)",
   CurrentValue = false,
   Flag = "StealthBypass",
   Callback = function(Value)
       if Value then
           local mt = getrawmetatable(game)
           local oldNamecall = mt.__namecall
           setreadonly(mt, false)
           mt.__namecall = newcclosure(function(self, ...)
               local method = getnamecallmethod()
               if method == "Kick" or method == "Ban" or method == "KickPlayer" then
                   return nil
               end
               return oldNamecall(self, ...)
           end)
           setreadonly(mt, true)
           Rayfield:Notify({Title="Stealth", Content="Bypass aktif.", Duration=3})
       end
   end,
})

StealthTab:CreateToggle({
   Name = "Speed Randomizer",
   CurrentValue = false,
   Flag = "StealthSpeed",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(2)
                   if humanoid and humanoid.WalkSpeed > 16 then
                       humanoid.WalkSpeed = humanoid.WalkSpeed + math.random(-3, 3)
                   end
               end
           end)
       end
   end,
})

StealthTab:CreateToggle({
   Name = "Anti-Void",
   CurrentValue = false,
   Flag = "AntiVoid",
   Callback = function(Value)
       if Value then
           RunService.Stepped:Connect(function()
               local r = TeleportUtil.getRoot()
               if r and r.Position.Y < -50 then
                   r.CFrame = CFrame.new(0, 50, 0)
               end
           end)
       end
   end,
})

StealthTab:CreateButton({
   Name = "Remove Kick/Ban Events",
   Callback = function()
       for _, v in pairs(rs:GetDescendants()) do
           if v:IsA("RemoteEvent") and (v.Name:lower():find("kick") or v.Name:lower():find("ban") or v.Name:lower():find("cheat")) then
               pcall(function() v:Destroy() end)
           end
       end
       Rayfield:Notify({Title="Stealth", Content="Kick eventleri temizlendi.", Duration=3})
   end,
})

StealthTab:CreateButton({
   Name = "Debug: Workspace Listele",
   Callback = function()
       TeleportUtil.debugList()
       Rayfield:Notify({Title="Debug", Content="Konsola bak (F9).", Duration=4})
   end,
})

-- ============================================
-- UNIVERSAL SEKMESİ
-- ============================================
local UniTab = Window:CreateTab("🌐 Universal", 4483362458)

UniTab:CreateSection("Fly (Özel Hız)")

local flySpeed = 50
local flying = false
local flyConnection = nil
local bodyGyro, bodyVel

UniTab:CreateInput({
   Name = "Fly Hızı (sayı yaz)",
   CurrentValue = "50",
   PlaceholderText = "Örn: 150",
   RemoveTextAfterFocusLost = false,
   Flag = "FlySpeedInput",
   Callback = function(Text)
       local n = tonumber(Text)
       if n then
           flySpeed = n
           Rayfield:Notify({Title="Fly", Content="Hız: "..n, Duration=3})
       else
           Rayfield:Notify({Title="Fly", Content="Sayı gir.", Duration=3})
       end
   end,
})

UniTab:CreateToggle({
   Name = "Fly (Mobile + PC)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
       flying = Value
       if Value then
           if not root then return end
           bodyGyro = Instance.new("BodyGyro", root)
           bodyGyro.P = 9e4
           bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
           bodyGyro.cframe = root.CFrame
           bodyVel = Instance.new("BodyVelocity", root)
           bodyVel.velocity = Vector3.new(0,0,0)
           bodyVel.maxForce = Vector3.new(9e9, 9e9, 9e9)

           local controlModule
           pcall(function()
               controlModule = require(player.PlayerScripts:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
           end)

           flyConnection = RunService.RenderStepped:Connect(function()
               if not flying or not root then return end
               local camCF = camera.CFrame
               local dir = Vector3.new(0,0,0)
               if UIS:IsKeyDown(Enum.KeyCode.W) then dir += camCF.LookVector end
               if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= camCF.LookVector end
               if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= camCF.RightVector end
               if UIS:IsKeyDown(Enum.KeyCode.D) then dir += camCF.RightVector end
               if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
               if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
               if controlModule then
                   local move = controlModule:GetMoveVector()
                   if move.Magnitude > 0 then
                       dir += camCF.LookVector * move.Z
                       dir += camCF.RightVector * move.X
                   end
               end
               if dir.Magnitude > 0 then
                   bodyVel.velocity = dir.Unit * flySpeed
               else
                   bodyVel.velocity = Vector3.new(0,0,0)
               end
               bodyGyro.cframe = camCF
           end)
       else
           if flyConnection then flyConnection:Disconnect() end
           if bodyGyro then bodyGyro:Destroy() end
           if bodyVel then bodyVel:Destroy() end
       end
   end,
})

UniTab:CreateSection("Movement")

UniTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 500},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "UniSpeed",
   Callback = function(Value) if humanoid then humanoid.WalkSpeed = Value end end,
})

UniTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   Suffix = "JP",
   CurrentValue = 50,
   Flag = "UniJump",
   Callback = function(Value) if humanoid then humanoid.UseJumpPower = true; humanoid.JumpPower = Value end end,
})

UniTab:CreateSection("Visual")

local uniESPTable = {}

local function createESP(plr, color)
    if plr == player or not plr.Character then return end
    if uniESPTable[plr] then return end
    local h = Instance.new("Highlight")
    h.Name = "CloesESP"
    h.Parent = plr.Character
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.FillColor = color or Color3.fromRGB(255,0,0)
    h.OutlineColor = Color3.fromRGB(255,255,255)
    h.FillTransparency = 0.5
    uniESPTable[plr] = h
end

local function removeESP(plr)
    if uniESPTable[plr] then
        pcall(function() uniESPTable[plr]:Destroy() end)
        uniESPTable[plr] = nil
    end
end

UniTab:CreateToggle({
   Name = "ESP (Tüm Oyuncular)",
   CurrentValue = false,
   Flag = "UniESP",
   Callback = function(Value)
       if Value then
           for _, v in pairs(plrs:GetPlayers()) do
               createESP(v)
               v.CharacterAdded:Connect(function()
                   task.wait(0.5)
                   createESP(v)
               end)
           end
           plrs.PlayerAdded:Connect(function(v)
               v.CharacterAdded:Connect(function()
                   task.wait(0.5)
                   createESP(v)
               end)
           end)
       else
           for _, v in pairs(plrs:GetPlayers()) do
               removeESP(v)
           end
       end
   end,
})

UniTab:CreateToggle({
   Name = "Fullbright",
   CurrentValue = false,
   Flag = "UniBright",
   Callback = function(Value)
       if Value then
           lighting.Ambient = Color3.fromRGB(255,255,255)
           lighting.Brightness = 2
           lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
       else
           lighting.Ambient = Color3.fromRGB(0,0,0)
           lighting.Brightness = 1
           lighting.OutdoorAmbient = Color3.fromRGB(0,0,0)
       end
   end,
})

UniTab:CreateToggle({
   Name = "Anti-AFK",
   CurrentValue = false,
   Flag = "UniAFK",
   Callback = function(Value)
       if Value then
           plrs.LocalPlayer.Idled:Connect(function()
               vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
               task.wait(0.1)
               vim:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
           end)
       end
   end,
})
-- ============================================
-- MM2 SEKMESİ
-- ============================================
local MM2Tab = Window:CreateTab("🔪 MM2", 4483362458)

MM2Tab:CreateSection("Gun / Sheriff")

MM2Tab:CreateToggle({
   Name = "Gun ESP (Sarı)",
   CurrentValue = false,
   Flag = "GunESP",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.3)
                   for _, v in pairs(plrs:GetPlayers()) do
                       if v ~= player and v.Character then
                           local hasGun = false
                           if v.Character:FindFirstChild("Gun") or v.Character:FindFirstChild("Revolver") then hasGun = true end
                           if v.Backpack and (v.Backpack:FindFirstChild("Gun") or v.Backpack:FindFirstChild("Revolver")) then hasGun = true end
                           local existing = v.Character:FindFirstChild("CloesGunESP")
                           if hasGun and not existing then
                               local h = Instance.new("Highlight")
                               h.Name = "CloesGunESP"
                               h.Parent = v.Character
                               h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                               h.FillColor = Color3.fromRGB(255, 230, 0)
                               h.OutlineColor = Color3.fromRGB(255, 255, 0)
                           elseif not hasGun and existing then
                               existing:Destroy()
                           end
                       end
                   end
               end
           end)
       end
   end,
})

MM2Tab:CreateToggle({
   Name = "Auto Pickup Gun",
   CurrentValue = false,
   Flag = "AutoGun",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.2)
                   for _, v in pairs(workspace:GetDescendants()) do
                       if v:IsA("BasePart") or v:IsA("MeshPart") then
                           local n = v.Name:lower()
                           if n:find("gun") or n:find("revolver") then
                               if not v:FindFirstAncestorOfClass("Tool") then
                                   local r = TeleportUtil.getRoot()
                                   if r and (v.Position - r.Position).Magnitude < 300 then
                                       r.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                                       task.wait(0.15)
                                   end
                               end
                           end
                       end
                   end
                   for _, t in pairs(workspace:GetChildren()) do
                       if t:IsA("Tool") and (t.Name:lower():find("gun") or t.Name:lower():find("revolver")) then
                           if t:FindFirstChild("Handle") then
                               local r = TeleportUtil.getRoot()
                               if r then
                                   r.CFrame = t.Handle.CFrame + Vector3.new(0, 2, 0)
                                   task.wait(0.1)
                                   pcall(function() t.Parent = player.Backpack end)
                               end
                           end
                       end
                   end
               end
           end)
       end
   end,
})

MM2Tab:CreateSection("General")

MM2Tab:CreateButton({
   Name = "Coin Farm",
   Callback = function()
       task.spawn(function()
           while true do
               task.wait(0.8)
               for _, v in pairs(workspace:GetDescendants()) do
                   if v:IsA("BasePart") then
                       local n = v.Name:lower()
                       if n:find("coin") or n:find("cash") then
                           local r = TeleportUtil.getRoot()
                           if r and (v.Position - r.Position).Magnitude < 200 then
                               r.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                               task.wait(0.4)
                           end
                       end
                   end
               end
           end
       end)
   end,
})

MM2Tab:CreateToggle({
   Name = "Auto Shout Murder",
   CurrentValue = false,
   Flag = "AutoShout",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(3)
                   local murderName = "None"
                   for _, v in pairs(plrs:GetPlayers()) do
                       if v ~= player and v.Character then
                           local hasKnife = v.Character:FindFirstChild("Knife") or (v.Backpack and v.Backpack:FindFirstChild("Knife"))
                           if hasKnife then murderName = v.Name end
                       end
                   end
                   local chatEvent = rs:FindFirstChild("DefaultChatSystemChatEvents")
                   if chatEvent and chatEvent:FindFirstChild("SayMessageRequest") then
                       chatEvent.SayMessageRequest:FireServer("Murder: "..murderName, "All")
                   end
               end
           end)
       end
   end,
})

MM2Tab:CreateToggle({
   Name = "Wall Shots (Sheriff)",
   CurrentValue = false,
   Flag = "WallShots",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.15)
                   local hasGun = char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
                   if hasGun then
                       local target = nil
                       for _, v in pairs(plrs:GetPlayers()) do
                           if v ~= player and v.Character then
                               local hasKnife = v.Character:FindFirstChild("Knife") or (v.Backpack and v.Backpack:FindFirstChild("Knife"))
                               if hasKnife and v.Character:FindFirstChild("Head") then
                                   target = v.Character.Head
                                   break
                               end
                           end
                       end
                       if target then
                           camera.CFrame = CFrame.new(camera.CFrame.Position, target.Position)
                           local tool = char:FindFirstChildOfClass("Tool")
                           if tool then pcall(function() tool:Activate() end) end
                       end
                   end
               end
           end)
       end
   end,
})

MM2Tab:CreateSection("Teleport")

MM2Tab:CreateButton({
   Name = "Current Map (Akıllı)",
   Callback = function()
       local ok = TeleportUtil.teleportTo("teleport")
       if not ok then ok = TeleportUtil.teleportTo("map") end
       if not ok then ok = TeleportUtil.teleportTo("island") end
       if not ok then ok = TeleportUtil.teleportTo("round") end
       if ok then
           Rayfield:Notify({Title="Teleport", Content="Maça ışınlandın.", Duration=3})
       else
           Rayfield:Notify({Title="Teleport", Content="Harita bulunamadı, debug yap.", Duration=3})
       end
   end,
})

MM2Tab:CreateButton({
   Name = "Lobby (Akıllı)",
   Callback = function()
       local ok = TeleportUtil.teleportTo("lobby")
       if not ok then ok = TeleportUtil.teleportTo("spawn") end
       if not ok then
           for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("SpawnLocation") then
                   local r = TeleportUtil.getRoot()
                   if r then
                       r.CFrame = v.CFrame + Vector3.new(0, 5, 0)
                       ok = true
                       break
                   end
               end
           end
       end
       if ok then
           Rayfield:Notify({Title="Teleport", Content="Lobby'e ışınlandın.", Duration=3})
       else
           Rayfield:Notify({Title="Teleport", Content="Lobby bulunamadı.", Duration=3})
       end
   end,
})

MM2Tab:CreateButton({
   Name = "Gun'a Işınlan",
   Callback = function()
       local ok = TeleportUtil.teleportTo("gun", 3)
       if not ok then ok = TeleportUtil.teleportTo("revolver", 3) end
       if ok then
           Rayfield:Notify({Title="Teleport", Content="Gun'a ışınlandın.", Duration=3})
       else
           Rayfield:Notify({Title="Teleport", Content="Gun bulunamadı.", Duration=3})
       end
   end,
})

MM2Tab:CreateButton({
   Name = "Knife'a Işınlan",
   Callback = function()
       local ok = TeleportUtil.teleportTo("knife", 3)
       if ok then
           Rayfield:Notify({Title="Teleport", Content="Knife'a ışınlandın.", Duration=3})
       else
           Rayfield:Notify({Title="Teleport", Content="Knife bulunamadı.", Duration=3})
       end
   end,
})

-- ============================================
-- ARSENAL SEKMESİ
-- ============================================
local ArsenalTab = Window:CreateTab("🔫 Arsenal", 4483362458)

local arsenalAimbot = false
ArsenalTab:CreateSection("Aimbot")

ArsenalTab:CreateToggle({
   Name = "Silent Aimbot (Head)",
   CurrentValue = false,
   Flag = "ArsenalAimbot",
   Callback = function(Value) arsenalAimbot = Value end,
})

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)
mt.__index = newcclosure(function(self, key)
    if arsenalAimbot and key == "Hit" and self == player:GetMouse() then
        local closest, dist = nil, math.huge
        for _, v in pairs(plrs:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("Head") then
                local d = (v.Character.Head.Position - camera.CFrame.Position).Magnitude
                if d < dist then dist = d; closest = v.Character.Head end
            end
        end
        if closest then return CFrame.new(closest.Position) end
    end
    return oldIndex(self, key)
end)
setreadonly(mt, true)

ArsenalTab:CreateSection("Visual")

ArsenalTab:CreateToggle({
   Name = "ESP",
   CurrentValue = false,
   Flag = "ArsenalESP",
   Callback = function(Value)
       if Value then
           for _, v in pairs(plrs:GetPlayers()) do
               if v ~= player and v.Character then
                   local h = Instance.new("Highlight")
                   h.Parent = v.Character
                   h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                   h.FillColor = Color3.fromRGB(255,0,0)
                   h.OutlineColor = Color3.fromRGB(255,255,255)
               end
           end
       else
           for _, v in pairs(plrs:GetPlayers()) do
               if v.Character and v.Character:FindFirstChildOfClass("Highlight") then
                   v.Character:FindFirstChildOfClass("Highlight"):Destroy()
               end
           end
       end
   end,
})

ArsenalTab:CreateSection("Combat")

ArsenalTab:CreateToggle({
   Name = "Rapid Fire",
   CurrentValue = false,
   Flag = "ArsenalRapid",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.03)
                   local tool = char:FindFirstChildOfClass("Tool")
                   if tool then pcall(function() tool:Activate() end) end
               end
           end)
       end
   end,
})

ArsenalTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "ArsenalSpeed",
   Callback = function(Value) if humanoid then humanoid.WalkSpeed = Value end end,
})

-- ============================================
-- DA HOOD SEKMESİ
-- ============================================
local DaHoodTab = Window:CreateTab("🏙️ Da Hood", 4483362458)

DaHoodTab:CreateSection("Movement")

DaHoodTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "DaHoodSpeed",
   Callback = function(Value) if humanoid then humanoid.WalkSpeed = Value end end,
})

DaHoodTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "DaHoodJump",
   Callback = function(Value)
       if Value then
           UIS.JumpRequest:Connect(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
       end
   end,
})

local noclipOn = false
DaHoodTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Flag = "DaHoodNoclip",
   Callback = function(Value)
       noclipOn = Value
       if Value then
           RunService.Stepped:Connect(function()
               if not noclipOn then return end
               if char then
                   for _, v in pairs(char:GetDescendants()) do
                       if v:IsA("BasePart") then v.CanCollide = false end
                   end
               end
           end)
       end
   end,
})

DaHoodTab:CreateSection("Combat")

DaHoodTab:CreateToggle({
   Name = "Kill Aura",
   CurrentValue = false,
   Flag = "DaHoodAura",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.2)
                   for _, v in pairs(plrs:GetPlayers()) do
                       if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                           local r = TeleportUtil.getRoot()
                           if r then
                               local dist = (v.Character.HumanoidRootPart.Position - r.Position).Magnitude
                               if dist < 20 then
                                   local tool = char:FindFirstChildOfClass("Tool")
                                   if tool then pcall(function() tool:Activate() end) end
                               end
                           end
                       end
                   end
               end
           end)
       end
   end,
})

DaHoodTab:CreateSection("Teleport")

DaHoodTab:CreateButton({
   Name = "Bank'a Işınlan",
   Callback = function()
       local ok = TeleportUtil.teleportTo("bank", 5)
       if ok then
           Rayfield:Notify({Title="Teleport", Content="Bank'a ışınlandın.", Duration=3})
       else
           Rayfield:Notify({Title="Teleport", Content="Bank bulunamadı.", Duration=3})
       end
   end,
})

DaHoodTab:CreateButton({
   Name = "Spawn'a Işınlan",
   Callback = function()
       local ok = TeleportUtil.teleportTo("spawn", 5)
       if not ok then
           for _, v in pairs(workspace:GetDescendants()) do
               if v:IsA("SpawnLocation") then
                   local r = TeleportUtil.getRoot()
                   if r then
                       r.CFrame = v.CFrame + Vector3.new(0, 5, 0)
                       ok = true
                       break
                   end
               end
           end
       end
       if ok then
           Rayfield:Notify({Title="Teleport", Content="Spawn'a ışınlandın.", Duration=3})
       else
           Rayfield:Notify({Title="Teleport", Content="Spawn bulunamadı.", Duration=3})
       end
   end,
})
-- ============================================
-- BLOX FRUITS SEKMESİ
-- ============================================
local BloxTab = Window:CreateTab("🍇 Blox Fruits", 4483362458)

BloxTab:CreateSection("Ada Seçimi")

local bloxIslands = {
    "Starter Island", "Marine Fortress", "Middle Town", "Jungle",
    "Pirate Village", "Desert", "Frozen Village", "Colosseum",
    "Prison", "Magma Village", "Underwater City", "Fountain City",
    "Skylands", "Upper Skylands", "Cursed Ship", "Ice Castle",
    "Forgotten Island", "Mansion", "Haunted Castle", "Hydra Island",
    "Great Tree", "Castle on the Sea", "Floating Turtle", "Kingdom of Rose"
}

local selectedIsland = "Starter Island"
local bloxFarmOn = false

BloxTab:CreateDropdown({
   Name = "Ada Seç ▼",
   Options = bloxIslands,
   CurrentOption = {"Starter Island"},
   MultipleOptions = false,
   Flag = "BloxIsland",
   Callback = function(Option)
       if type(Option) == "table" then
           selectedIsland = Option[1]
       else
           selectedIsland = Option
       end
       Rayfield:Notify({Title="Ada", Content=selectedIsland.." seçildi", Duration=3})
   end,
})

BloxTab:CreateToggle({
   Name = "Auto Farm (Seçili Ada)",
   CurrentValue = false,
   Flag = "BloxFarm",
   Callback = function(Value)
       bloxFarmOn = Value
       if Value then
           task.spawn(function()
               while bloxFarmOn do
                   task.wait(0.4)
                   local r = TeleportUtil.getRoot()
                   if r then
                       for _, v in pairs(workspace:GetDescendants()) do
                           if v:IsA("Model") and v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                               if v.Name ~= player.Name and v.Name ~= char.Name then
                                   local isMob = true
                                   pcall(function()
                                       if plrs:GetPlayerFromCharacter(v) then isMob = false end
                                   end)
                                   if isMob and (v.HumanoidRootPart.Position - r.Position).Magnitude < 500 then
                                       r.CFrame = v.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                                       task.wait(0.05)
                                       local tool = char:FindFirstChildOfClass("Tool")
                                       if tool then pcall(function() tool:Activate() end) end
                                   end
                               end
                           end
                       end
                   end
               end
           end)
       end
   end,
})

BloxTab:CreateButton({
   Name = "Seçili Adaya Işınlan",
   Callback = function()
       local ok = TeleportUtil.teleportTo(selectedIsland, 10)
       if not ok then
           for _, v in pairs(workspace:GetChildren()) do
               if v.Name:lower():gsub("%s",""):find(selectedIsland:lower():gsub("%s","")) then
                   local part = v:FindFirstChildWhichIsA("BasePart") or (v:IsA("Model") and v.PrimaryPart)
                   if part then
                       local r = TeleportUtil.getRoot()
                       if r then
                           r.CFrame = part.CFrame + Vector3.new(0, 10, 0)
                           ok = true
                           break
                       end
                   end
               end
           end
       end
       if ok then
           Rayfield:Notify({Title="Ada", Content=selectedIsland.."'a ışınlandın.", Duration=3})
       else
           Rayfield:Notify({Title="Ada", Content="Ada bulunamadı, Debug butonunu kullan.", Duration=4})
       end
   end,
})

BloxTab:CreateSection("Movement")

BloxTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "BloxSpeed",
   Callback = function(Value) if humanoid then humanoid.WalkSpeed = Value end end,
})

-- ============================================
-- PET SIM 99 SEKMESİ
-- ============================================
local PetTab = Window:CreateTab("🐾 Pet Sim 99", 4483362458)

PetTab:CreateSection("Ada Seçimi")

local petIslands = {
    "Spawn", "Grasslands", "Desert", "Volcano",
    "Winter", "Fantasy", "Rainbow", "Tech World",
    "Cat World", "Dog World", "Pixel World", "Heaven",
    "Hell", "Candy Land", "Cyber City", "Pirate Cove"
}

local selectedPetIsland = "Spawn"
local petFarmOn = false

PetTab:CreateDropdown({
   Name = "Ada Seç ▼",
   Options = petIslands,
   CurrentOption = {"Spawn"},
   MultipleOptions = false,
   Flag = "PetIsland",
   Callback = function(Option)
       if type(Option) == "table" then
           selectedPetIsland = Option[1]
       else
           selectedPetIsland = Option
       end
       Rayfield:Notify({Title="Pet Ada", Content=selectedPetIsland.." seçildi", Duration=3})
   end,
})

PetTab:CreateToggle({
   Name = "Auto Farm (Seçili Ada)",
   CurrentValue = false,
   Flag = "PetFarm",
   Callback = function(Value)
       petFarmOn = Value
       if Value then
           task.spawn(function()
               while petFarmOn do
                   task.wait(0.3)
                   local r = TeleportUtil.getRoot()
                   if r then
                       for _, v in pairs(workspace:GetDescendants()) do
                           if v:IsA("BasePart") then
                               local n = v.Name:lower()
                               if n:find("coin") or n:find("breakable") or n:find("chest") or n:find("diamond") then
                                   local dist = (v.Position - r.Position).Magnitude
                                   if dist < 500 then
                                       r.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                                       task.wait(0.05)
                                   end
                               end
                           end
                       end
                   end
               end
           end)
       end
   end,
})

PetTab:CreateButton({
   Name = "Seçili Adaya Işınlan",
   Callback = function()
       local ok = TeleportUtil.teleportTo(selectedPetIsland, 10)
       if not ok then
           for _, v in pairs(workspace:GetChildren()) do
               if v.Name:lower():gsub("%s",""):find(selectedPetIsland:lower():gsub("%s","")) then
                   local part = v:FindFirstChildWhichIsA("BasePart")
                   if part then
                       local r = TeleportUtil.getRoot()
                       if r then
                           r.CFrame = part.CFrame + Vector3.new(0, 10, 0)
                           ok = true
                           break
                       end
                   end
               end
           end
       end
       if ok then
           Rayfield:Notify({Title="Pet Ada", Content=selectedPetIsland.."'a ışınlandın.", Duration=3})
       else
           Rayfield:Notify({Title="Pet Ada", Content="Ada bulunamadı, Debug kullan.", Duration=4})
       end
   end,
})

PetTab:CreateButton({
   Name = "Auto Hatch Eggs (Tümü)",
   Callback = function()
       task.spawn(function()
           local r = TeleportUtil.getRoot()
           if r then
               for _, v in pairs(workspace:GetDescendants()) do
                   if v:IsA("BasePart") and v.Name:lower():find("egg") then
                       r.CFrame = v.CFrame + Vector3.new(0, 3, 0)
                       task.wait(0.3)
                   end
               end
           end
       end)
   end,
})

-- ============================================
-- MUSCLE LEGENDS SEKMESİ
-- ============================================
local MLTab = Window:CreateTab("💪 Muscle Legends", 4483362458)

local mlEvents = {
    dambil = findRemoteEvent("dambil", "dumbbell"),
    sinav = findRemoteEvent("sinav", "pushup", "push"),
    mekik = findRemoteEvent("mekik", "situp", "sit"),
    rebirth = findRemoteEvent("rebirth", "rebi"),
    punch = findRemoteEvent("punch", "hit", "attack"),
    equip = findRemoteEvent("equip"),
    sell = findRemoteEvent("sell"),
}

MLTab:CreateSection("Auto Train (Ayrı Ayrı)")

MLTab:CreateToggle({
   Name = "Auto Dambil",
   CurrentValue = false,
   Flag = "AutoDambil",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.8)
                   if #mlEvents.dambil > 0 then
                       fireAll(mlEvents.dambil, true)
                   else
                       pcall(function() rs.Events.Dambil:FireServer(true) end)
                   end
               end
           end)
       end
   end,
})

MLTab:CreateToggle({
   Name = "Auto Sinav (Pushup)",
   CurrentValue = false,
   Flag = "AutoSinav",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.8)
                   if #mlEvents.sinav > 0 then
                       fireAll(mlEvents.sinav, true)
                   else
                       pcall(function() rs.Events.Sinav:FireServer(true) end)
                   end
               end
           end)
       end
   end,
})

MLTab:CreateToggle({
   Name = "Auto Mekik (Situp)",
   CurrentValue = false,
   Flag = "AutoMekik",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.8)
                   if #mlEvents.mekik > 0 then
                       fireAll(mlEvents.mekik, true)
                   else
                       pcall(function() rs.Events.Mekik:FireServer(true) end)
                   end
               end
           end)
       end
   end,
})

MLTab:CreateToggle({
   Name = "Auto Train All (Hepsi Birden)",
   CurrentValue = false,
   Flag = "AutoTrainAll",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.6)
                   if #mlEvents.dambil > 0 then fireAll(mlEvents.dambil, true) else pcall(function() rs.Events.Dambil:FireServer(true) end) end
                   task.wait(0.2)
                   if #mlEvents.sinav > 0 then fireAll(mlEvents.sinav, true) else pcall(function() rs.Events.Sinav:FireServer(true) end) end
                   task.wait(0.2)
                   if #mlEvents.mekik > 0 then fireAll(mlEvents.mekik, true) else pcall(function() rs.Events.Mekik:FireServer(true) end) end
               end
           end)
       end
   end,
})

MLTab:CreateSection("Auto Rebirth")

MLTab:CreateToggle({
   Name = "Auto Rebirth",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(3)
                   if #mlEvents.rebirth > 0 then
                       fireAll(mlEvents.rebirth)
                   else
                       pcall(function() rs.Events.Rebirth:FireServer() end)
                   end
               end
           end)
       end
   end,
})

MLTab:CreateSection("Combat")

MLTab:CreateToggle({
   Name = "Auto Punch",
   CurrentValue = false,
   Flag = "AutoPunch",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.1)
                   if #mlEvents.punch > 0 then fireAll(mlEvents.punch) end
                   local tool = char:FindFirstChildOfClass("Tool")
                   if tool then pcall(function() tool:Activate() end) end
               end
           end)
       end
   end,
})

MLTab:CreateToggle({
   Name = "Kill Aura (Yakın Oyunculara)",
   CurrentValue = false,
   Flag = "MLKillAura",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(0.15)
                   local r = TeleportUtil.getRoot()
                   if r then
                       for _, v in pairs(plrs:GetPlayers()) do
                           if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                               local dist = (v.Character.HumanoidRootPart.Position - r.Position).Magnitude
                               if dist < 15 then
                                   if #mlEvents.punch > 0 then fireAll(mlEvents.punch) end
                                   local tool = char:FindFirstChildOfClass("Tool")
                                   if tool then pcall(function() tool:Activate() end) end
                               end
                           end
                       end
                   end
               end
           end)
       end
   end,
})

MLTab:CreateSection("Movement")

MLTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 300},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "MLSpeed",
   Callback = function(Value) if humanoid then humanoid.WalkSpeed = Value end end,
})

MLTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 1,
   Suffix = "JP",
   CurrentValue = 50,
   Flag = "MLJump",
   Callback = function(Value) if humanoid then humanoid.UseJumpPower = true; humanoid.JumpPower = Value end end,
})

MLTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "MLInfJump",
   Callback = function(Value)
       if Value then
           UIS.JumpRequest:Connect(function() humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end)
       end
   end,
})

MLTab:CreateSection("Utility")

MLTab:CreateToggle({
   Name = "Auto Sell (Pets)",
   CurrentValue = false,
   Flag = "AutoSell",
   Callback = function(Value)
       if Value then
           task.spawn(function()
               while Value do
                   task.wait(5)
                   if #mlEvents.sell > 0 then fireAll(mlEvents.sell) end
               end
           end)
       end
   end,
})

MLTab:CreateButton({
   Name = "Event'leri Debug Et",
   Callback = function()
       print("=== MUSCLE LEGENDS EVENT DEBUG ===")
       print("Dambil:", #mlEvents.dambil)
       for _, e in ipairs(mlEvents.dambil) do print("  ->", e:GetFullName()) end
       print("Sinav:", #mlEvents.sinav)
       for _, e in ipairs(mlEvents.sinav) do print("  ->", e:GetFullName()) end
       print("Mekik:", #mlEvents.mekik)
       for _, e in ipairs(mlEvents.mekik) do print("  ->", e:GetFullName()) end
       print("Rebirth:", #mlEvents.rebirth)
       for _, e in ipairs(mlEvents.rebirth) do print("  ->", e:GetFullName()) end
       print("Punch:", #mlEvents.punch)
       for _, e in ipairs(mlEvents.punch) do print("  ->", e:GetFullName()) end
       Rayfield:Notify({Title="Debug", Content="Konsola bak (F9).", Duration=4})
   end,
})

-- ============================================
-- ABOUT
-- ============================================
local AboutTab = Window:CreateTab("ℹ️ About", 4483362458)

AboutTab:CreateParagraph({
   Title = "CLOES MENU v14.0 | HACKER EDITION",
   Content = [[
By Cloes

DÜZELTİLDİ:
• findRemoteEvent ve fireAll eklendi
• TeleportUtil.getRoot() ile root güncel kalıyor
• Tüm teleportlar çalışır durumda
• Muscle Legends ayrı ayrı: Dambil, Sinav, Mekik, Rebirth, Punch
• Kill Aura, Auto Sell, WalkSpeed, JumpPower eklendi
   ]]
})

Rayfield:Notify({
   Title = "CLOES MENU v14",
   Content = "HACKER EDITION yüklendi. Hatalar düzeltildi.",
   Duration = 6,
   Image = 4483362458,
})

print("=== CLOES MENU v14.0 HACKER EDITION ===")
print("By Cloes")
