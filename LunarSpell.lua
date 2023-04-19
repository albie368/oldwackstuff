--[[
    MIT License

    Copyright (c) albie368

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.
]]

-- | note: i don't guarentee that this script will remain up to date or functional

local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/albie368/venyxuireupload/main/source.lua"))()
local UIS = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VERSION = "1.0final"


local chatRemote = ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest
local mtMain = library.new(string.format("LunarSpell [%s]",VERSION))

if not game.GameId == 527730528 then
    mtMain:Notify("MTLauncher", "Cannot launch on this game")
end

local modList = {
    "", -- | I've completely lost the list, add to it if you need
}

local usedFunctions = {
    "getgenv",
}

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer




local trueEvents = game:GetService("InsertService").Events

if not getgenv().MTLaunchCheck then
    if getsenv then
        local twinScripts = {localPlayer.PlayerScripts.Twin1,localPlayer.PlayerScripts.Twin2}

        for _,v in pairs(twinScripts) do
            local scriptEnv = getsenv(v) 
            for i,v in pairs(scriptEnv) do
                scriptEnv[i] = nil 
            end
        end

        twinScripts[1]:Destroy()
        twinScripts[2]:Destroy()
        mtMain:Notify("LunarSpell","Bypassed AC [Method 1]")
    else
        trueEvents.ExploitLog:Destroy()
        mtMain:Notify("LunarSpell","Bypassed AC [Method 2]")
    end
end

getgenv().MTLaunchCheck = true

local preferences = {
    keybinds = {},
    generalSettings = {
        hideSpells = true,
    },
}


-- themes
local themes = {
    Background = Color3.fromRGB(35, 35, 35),
    Glow = Color3.fromRGB(7, 1, 1),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(25, 25, 25),
    DarkContrast = Color3.fromRGB(20,20,20),
    TextColor = Color3.fromRGB(255, 255, 255)
}


local function updateRemoteCounter(remoteName)
    local dataFolder = game:GetService("BadgeService"):FindFirstChild("data") 
    if not dataFolder then
        dataFolder = Instance.new("Folder")
        dataFolder.Name = "data"
        dataFolder.Parent = game:GetService("BadgeService")
    end

    local dataVal = dataFolder:FindFirstChild(remoteName)
    if not dataVal then
        dataVal = Instance.new("IntValue")
        dataVal.Name = remoteName
        dataVal.Value = 0
        dataVal.Parent = dataFolder
    end
    dataVal.Value = dataVal.Value + 1
    return dataVal.Value
end

local function calculateRemoteKey(remoteName)
    local result = updateRemoteCounter(remoteName)
    local distanceCalc = ((result + 0.5428) * 2) ^ (math.pi * 0.5)
    return distanceCalc
end

local function loadSpell(spellN)
    trueEvents.setSpellLoaded:FireServer({
        ["bool"] = true,
        distance = calculateRemoteKey("setSpellLoaded"),
        tool =  Players.LocalPlayer.Character.Wand ,
        spellName = spellN
    })
end

local function hiddenChat(message)
    Players:Chat(message)
end

local prioritySpell = false
local uniqueSpells = {
    "appa",
    "lumos",
    "nox",
    "ascendio",
    "protego totalum",
    "protego",
}

local function elderCast(spellName,optionalArg)
    if not optionalArg then
        trueEvents.uniqueSpell:FireServer({distance = calculateRemoteKey("uniqueSpell"), tool =  localPlayer.Character.Wand , spellName = spellName})
    else
        trueEvents.uniqueSpell:FireServer({distance = calculateRemoteKey("uniqueSpell"), tool =  localPlayer.Character:FindFirstChild("Wand") or localPlayer.Backpack.Wand , spellName = spellName , [optionalArg.name] = optionalArg.value})
    end
end




local function selfCast(spell)
    hiddenChat(spell)
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    trueEvents.spellHit:FireServer({
        actor = character,
        spellName = spell,
        hitCf = character.HumanoidRootPart.CFrame,
    })
end




local function playerCast(player,spell,directActor,loaded)
    local character = directActor or player.Character or player.CharacterAdded:Wait()
    if not loaded then
        hiddenChat(spell)
    end
    pcall(function()
        trueEvents.spellHit:FireServer({
            actor = character,
            spellName = spell,
            hitCf = character.HumanoidRootPart.CFrame,
        })
    end)
end




local HTTPService = game:GetService("HttpService")
--  | ui setup

local mainPage = mtMain:addPage("Main",7407579779)
local togglesPage = mtMain:addPage("Toggles",7410728176)
local keyPage = mtMain:addPage("Keybinds",7410727739)
--local settingsPage = mtMain:addPage("Settings",7410728176)


local keybindSettings = keyPage:addSection("Preferences")
local customSection = keyPage:addSection("Custom Spells")
local killSection = keyPage:addSection("Kill Spells")
local stunSection = keyPage:addSection("Stun Spells")
local utilitySection = keyPage:addSection("Utility Spells")
local damageSection = keyPage:addSection("Damage Spells")
local elderSection = keyPage:addSection("Elder Spells")
local miscSection = keyPage:addSection("Misc Spells")
local fullAutoSpells = togglesPage:addSection("Full Auto Spells")
local healCounterSection = togglesPage:addSection("Healing & Countereffects")
local funcSection = togglesPage:addSection("Toggles")
local generalSection = mainPage:addSection("General")
local clashSection = togglesPage:addSection("Clash")
local loopSection = mainPage:addSection("Loopkill")
local auraSection = togglesPage:addSection("Auras")
local bringSection = mainPage:addSection("Bring")
local frameSection = mainPage:addSection("Frame Player")




local playerMouse = localPlayer:GetMouse()
local spellHandler = {}
spellHandler.__index = spellHandler

function spellHandler.calcId()
    return tostring(localPlayer.Name..workspace.DistributedGameTime)
end

local function directHit(spell,argTable)
    argTable.distance = calculateRemoteKey("spellHit")
    argTable.id = nil
    trueEvents.spellHit:FireServer(argTable)
end

function spellHandler.Unload(spellName)
    trueEvents.setSpellLoaded:FireServer({tool = localPlayer.Character.Wand, bool = false, distance = calculateRemoteKey("setSpellLoaded"), spellName = spellName})
end

function spellHandler.Load(displaySpell, spellQueue,castLimit,customHit)
    local newCustom = setmetatable({},spellHandler)
    newCustom.spellQueue = spellQueue or displaySpell
    newCustom.castLimit = castLimit or false
    newCustom.displaySpell = displaySpell
    newCustom.customHandler = customHit or false
    local wandTool = localPlayer.Character:FindFirstChild("Wand") or localPlayer.Backpack:FindFirstChild("Wand")
    newCustom.toolArg = wandTool
    Players:Chat(displaySpell)
    trueEvents.setSpellLoaded:FireServer({tool = wandTool, bool = true, distance = calculateRemoteKey("setSpellLoaded"), spellName = displaySpell})
    return newCustom 
end


local function getWand()
    local wand = localPlayer.Character:FindFirstChild("Wand") or localPlayer.Character:FindFirstChild("Elder Wand")
    if wand then
        return wand
    else
        return false
    end
end

local wandAnims = {}
for i = 1,3 do
    table.insert(wandAnims,ReplicatedStorage.Animations["cast"..tostring(i)])
end

local debounceT = false
local function playAnim()
    if not debounceT then
        debounceT = true
        local animObj = wandAnims[math.random(#wandAnims)]
        local animTrack = localPlayer.Character.Humanoid:LoadAnimation(animObj)
        animTrack:Play(0.1, 1, 3)
        animTrack.Stopped:Wait()
        debounceT = false
    end
end

function spellHandler:Cast(preLoaded,wandless)
    local firstPos,secondPos = ((wandless and localPlayer.Backpack:FindFirstChild("Wand")) and localPlayer.Character.RightHand.CFrame.Position) or self.toolArg.Handle.CFrame * CFrame.new(self.toolArg.Handle.Tip.Position).Position,playerMouse.Hit.Position
    local sId = spellHandler.calcId()
    --trueEvents.setSpellLoaded:FireServer({tool = self.toolArg, bool = false, distance = calculateRemoteKey("setSpellLoaded"), spellName = self.displaySpell})
    if not preLoaded then
        hiddenChat(self.displaySpell)
    end
    
    if wandless and localPlayer.Backpack:FindFirstChild("Wand") then
        task.spawn(playAnim)
    end
    
    trueEvents.spellFired:FireServer({
        tool = self.toolArg,
        a = firstPos,
        b = secondPos,
        spellName = self.displaySpell,
        id = sId,
        distance = calculateRemoteKey("spellFired")
    })

    trueEvents.fireSpellLocal:Fire({
        a = firstPos,
        b = secondPos,
        spellName = self.displaySpell,
        caster = localPlayer,
        id = sId
    })

    

    
    if self.customHandler then
        spellHandler.idTable[sId] = self.spellQueue
    end
    
end

function spellHandler.LoadCustom(spellName)
    local newCustom = setmetatable({},spellHandler)
    newCustom.spellIden = spellName
    hiddenChat(spellName)
    return newCustom
end

function spellHandler:CustomCast(positionTable)
    local spellId = spellHandler.calcId()

    trueEvents.spellFired:FireServer({
        tool = getWand(),
        a = positionTable[1],
        b = positionTable[2],
        spellName = self.spellIden,
        id = spellId,
        distance = calculateRemoteKey("spellFired")
    })

    trueEvents.fireSpellLocal:Fire({
        a = positionTable[1],
        b = positionTable[2],
        spellName = self.spellIden,
        caster = localPlayer,
        id = spellId,
    })


end









local funcTable = {
    ["autoHeal"] = {},
    ["permSpell"] = {},
    ["permFlight"] = {},
    ["autoClash"] = {},
    ["loopKill"] = {playerList = {}},
    ["loopBlock"] = {},
    ["autoSpells"] = {performLoop = false,intervalTime = 0.05},
    ["antiElder"] = {},
    ["framePlayer"] = {playerList = {}},
    ["antiStatus"] = {},
    ["wandlessMagic"] = {},
    ["wandIgnore"] = {},
    ["smokeParticles"] = {}

}

local auraTable = {
    healAura = {}
}





auraTable.__index = auraTable
funcTable.__index = funcTable

local function verifyWand(character)
    local wand = character:FindFirstChild("Wand")
    if wand then
        return not wand.Handle:FindFirstChild("Mesh")
    end
end

local keyPhrase = "magictrainingisthebest123"
local exemptList = {}



local spellList = {
    customSpells = {
        "Meteorus",
        "Fixa",
        "Soul Decimatus"
    },
    stunSpells = {
        "Duro",
        "Ebublio",
        "Glacius",
        "Impedimenta",
        "Incarcerous",
        "Levicorpus",
        "Locomotor Wibbly",
        "Petrificus Totalus",
        "Stupefy",
        "Tarantallegra",
    },
    damageSpells = {
        "Alarte Ascendare",
        "Baubillious",
        "Bombarda",
        "Confringo",
        "Crucio",
        "Depulso",
        "Everte Statum",
        "Expulso",
        "Incendio",
        "Flare",
        "Reducto",
        "Tonitro",
        "Verdimillious"
    },  
    utilitySpells = {
        "Appa",
        "Ascendio",
        "Episkey",
        "Finite Incantatem",
        "Relashio",
        "Rennervate",
        "Vulnera Sanentur"
    },
    miscHeal = {
        "Morsmordre",
        "Carpe Retractum",
        "Confundo",
        "Expelliarmus",
        "Flipendo",
        "Rictusempra",
        "Obliviate",
        "Obscuro",
        "Protego Totalum",
    },
    elderSpells = {
        "Protego Diabolica",
        "Infernum",
        "Pruina Tempestatis",
    },
    killSpells = {
        "Avada Kedavra",
        "Defodio",
        "Deletrius",
        "Sectumsempra",
    }
}

-- | functions




local function chatTrue(message)
    ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(string.lower(message),"All")
    hiddenChat(message)

end
local oldSendChatMethod
local sendChatMethod = hiddenChat

local previousKey = ""

local preLoaded = true
local function spamSpell()
    while true do
        local spellLoad
        pcall(function()
            
            spellLoad = spellHandler.Load(funcTable.autoSpells.Selected or "deletrius")
            
            hiddenChat(funcTable.autoSpells.Selected)
        end)
        while true do
            pcall(function()
                spellLoad:Cast(true,funcTable.wandlessMagic.Enabled)
                
            end)
            wait(funcTable.autoSpells.intervalTime)
            if not funcTable.autoSpells.performLoop then
                break
            end
            
        end
        coroutine.yield()
    end
end



local spamTask
local uisConnT
local objPlayerList = {}
function auraTable.healAura:SetEnabled(value)
    self.Enabled = true
end

function auraTable.healAura:PerformAction(player)
    playerCast(playerCast,"vulnera sanentur")
end



function auraTable:InitAuras()
    auraTable.loopObj = function()
        while auraTable.healAura.Enabled do
            
            for i,v in pairs(objPlayerList) do
                local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
                local targetChar = v.Character
                if targetChar and targetChar.Humanoid.Health < 100 then
                    local success,distance = pcall(function()
                        return (character:GetPrimaryPartCFrame().Position - targetChar.HumanoidRootPart).Magnitude
                    end)
                    if success and distance < 20 then
                        
                            pcall(function()
                                auraTable.healAura:PerformAction(v)
                            end)
                    end
                end
            end
            wait(0.5)
        end
    end
end

function funcTable.autoSpells.Fire(spellName)
    if not table.find(uniqueSpells,spellName) then
        funcTable.autoSpells.Selected = spellName:lower()
    else
        if spellName == "appa" then
            elderCast(spellName,{name = "mousePos", value = playerMouse.Hit.Position})
        else
            elderCast(spellName)
        end
    end
end

function funcTable.antiElder:SetEnabled(value)
    self.Enabled = value
end

function funcTable.antiElder:Init()
    self.Enabled = false
    local spellFolder = workspace.spellEffects
    spellFolder.ChildAdded:Connect(function(newChild)
        if newChild.Name == "stormModel" and self.Enabled then
            local centerPosition = newChild:WaitForChild("Center").Position
            local closestPlayer = {Player = nil, Distance = 100}
            for _,v in pairs(Players:GetPlayers()) do
                local character = v.Character
                if character and v ~= localPlayer then
                    local success,distance = pcall(function()
                        return (character:GetPrimaryPartCFrame().Position - centerPosition).Magnitude
                    end)
                        if success and distance < closestPlayer.Distance then
                        closestPlayer.Distance = distance
                        closestPlayer.Player = v
                    end
                end
            end
            if closestPlayer.Player then
                prioritySpell = true
                for i = 1,5 do
                    playerCast(closestPlayer.Player,"impedimenta")
                    wait()
                end
                prioritySpell = false
            end
        end
    end)
end

funcTable.antiElder:Init()

function funcTable.smokeParticles:SetEnabled(value)
    self.Enabled = value
end

function funcTable.wandlessMagic:SetEnabled(value)
    self.Enabled = value
end

function funcTable.autoSpells:SetEnabled(value)
    self.Enabled = value
    if not spamTask then
        spamTask = coroutine.create(spamSpell)
    end
    if self.Enabled and not uisConnT then
        oldSendChatMethod = sendChatMethod
        sendChatMethod = funcTable.autoSpells.Fire
        uisConnT = {}
        uisConnT.Began = UIS.InputBegan:Connect(function(input, gameProc)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProc then
                funcTable.autoSpells.performLoop = true
                
                coroutine.resume(spamTask)
            end
        end)
        uisConnT.Ended = UIS.InputEnded:Connect(function(input, gameProc)
            if input.UserInputType == Enum.UserInputType.MouseButton1 and not gameProc then
                funcTable.autoSpells.performLoop = false
            end
        end)
    else
        sendChatMethod = oldSendChatMethod
        for i,v in pairs(uisConnT) do
            v:Disconnect()
        end
        uisConnT = nil
    end
end

function funcTable.autoClash:LegitMode(value)
    self.Legit = value
end

local function protegoClean(humPos)
    for i,v in pairs(workspace:GetChildren()) do
        if v.Name == "protegoShield" then
            local magCalc = (humPos - v.Position).Magnitude
            if magCalc < 50 then
                spawn(function() v:Destroy() end)
            end
        end
    end
end


local function lBlock()
    while true do 
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local humanoidRoot = character:FindFirstChild("HumanoidRootPart")
        local humanoidObj = character:FindFirstChild("Humanoid")
        if humanoidRoot and humanoidObj and funcTable.loopBlock.Enabled then
            if humanoidObj.Health > 0 then
                local humFrame = humanoidRoot.CFrame

                pcall(function()
                    for i = 0,360,90 do
                        trueEvents.protego:FireServer({distance = calculateRemoteKey("protego"),rootPos = humanoidRoot.Position,dir = (humFrame * CFrame.Angles(0,math.rad(i),0).LookVector)})
                        workspace.ChildAdded:Wait()
                        task.wait(0.15)
                    end
                end)
                
            end
        end
        if not funcTable.loopBlock.Enabled then
            coroutine.yield()
        end
        wait()
    end
end

local blockTask
local workspaceAdded

function funcTable.loopBlock:Init()
    workspaceAdded = workspace.ChildAdded:Connect(function(childAdded)
        if childAdded.Name == "protegoShield" then
            spawn(function()
                childAdded:Destroy()
            end)
        end
    end)
end

function funcTable.loopBlock:SetEnabled(value)
    self.Enabled = value
    if value and blockTask then
        coroutine.resume(blockTask)
    end
    if not blockTask and value then
        blockTask = coroutine.create(lBlock)
        coroutine.resume(blockTask)
    end
    
end


function funcTable.loopKill:Start(player)
    if not self.playerList[player] then
        local killConnection = player.CharacterAdded:Connect(function()  

            playerCast(player,"deletrius")
            task.wait(0.1)
            playerCast(player,"deletrius")
        end)
        playerCast(player,"deletrius")
        self.playerList[player] = killConnection
    end
end

function funcTable.loopKill:Stop(player)
    local killConnection = self.playerList[player]
    if killConnection then
        killConnection:Disconnect()
        self.playerList[player] = nil
        return true
    end
    return false
end

function funcTable.autoClash:Init()
    local function autoClash(character)
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.ChildAdded:Connect(function(child)
            if child.Name == "isClashing" then
                if self.Enabled then
                    mtMain:Notify("LunarSpell","Clash Auto-Win Engaged")
                    while humanoid.isClashing do
                        trueEvents.advanceClash:FireServer({distance = calculateRemoteKey("advanceClash")})
                        if self.Legit then 
                            task.wait(0.6)
                        else
                            task.wait()
                        end
                    end
                end
            end
        end)
    end
    autoClash(localPlayer.Character or localPlayer.CharacterAdded:Wait())
    localPlayer.CharacterAdded:Connect(autoClash)



end





function funcTable.autoClash:SetEnabled(value)
    self.Enabled = value
end

function funcTable.permFlight:Execute()
    if self.FlightObj then
        return 
    else
        for _,v in pairs(Players:GetPlayers()) do
            local pFlight = v.Backpack:FindFirstChild("Flight")
            if pFlight then
                self.FlightObj = pFlight:Clone()
                self.FlightObj:Clone().Parent = localPlayer.Backpack
                break
            end
        end
        localPlayer.CharacterAdded:Connect(function()
            self.FlightObj:Clone().Parent = localPlayer.Backpack
        end)
    end
end



function funcTable.autoHeal:SetEnabled(value)
    self.Enabled = value
end

function funcTable.autoHeal:SetCounterEnabled(value)
    self.CounterEnabled = value
end

local currentAttempt = {}

local function activateParticles(val)
--task.wait()
    if val then
        trueEvents.toggleFlight:FireServer({
            bool = true,
            flightType = "Deatheater",
            distance = calculateRemoteKey("toggleFlight")
        })
    else
        trueEvents.toggleFlight:FireServer({
            bool = false,
            flightType = "Deatheater",
            distance = calculateRemoteKey("toggleFlight")
        })
    end
end

function funcTable.autoHeal:Init()
    local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
    local hDeb = false
    self.Enabled = false

    local function humanoidCheckCon(char)

        
        char:WaitForChild("Humanoid").HealthChanged:Connect(function(health)
            if health < char.Humanoid.MaxHealth and health > 0 and not hDeb and self.Enabled then
                while char.Humanoid.Health < char.Humanoid.MaxHealth and not prioritySpell  do
                    hDeb = true
                    if not prioritySpell then
                        pcall(function() selfCast("episkey")  end)
                    else
                        break
                    end
                    if char.Humanoid.Health == 0 then
                        break
                    end
                    task.wait()
                end
                hDeb = false
            end
            wait()
        end)
    
        char.Humanoid.StateChanged:Connect(function(oldState,newState)
            if newState == Enum.HumanoidStateType.PlatformStanding and self.Enabled and not prioritySpell and not char.HumanoidRootPart:FindFirstChild("flightVelocity") then
                selfCast("rennervate")
                while true do
                    wait()
                    if char.Humanoid:GetState() == Enum.HumanoidStateType.PlatformStanding then
                        selfCast("rennervate")
                        wait(0.05)
                        selfCast("liberacorpus")
                        wait(0.05)
                        selfCast("diffindo")
                    else
                        break
                    end
                end
            end
        end)
    end
    
    humanoidCheckCon(character)
    
    localPlayer.CharacterAdded:Connect(function(pChar)
        humanoidCheckCon(pChar)
        pChar.DescendantAdded:Connect(function(childAdded)
            if self.CounterEnabled then
                if childAdded.Name == "bubbleAttachment" then
                    selfCast("diffindo")
                    task.wait(0.1)
                    selfCast("diffindo")
                elseif childAdded.Name == "frozenData" then
                    selfCast("diffindo")
                    childAdded:Destroy()

                end
            end
        end)
        pChar.HumanoidRootPart.ChildAdded:Connect(function(childAdded)
            if childAdded.Name == "flingVelocity" or childAdded.Name == "flingRotation" then
                childAdded:Destroy()
            end
        end)

        if funcTable.smokeParticles.Enabled then
            activateParticles(true)
            task.wait()
            elderCast("appa",{name = "mousePos", value = pChar.HumanoidRootPart.Position})
        end
        
    end)
    
end

function funcTable.framePlayer:Start(Player)
    
    if not self.playerList[Player] then
        self.playerList[Player] = true
        coroutine.wrap(function()
            while self.playerList[Player] do
                hiddenChat("deletrius")
                for _,v in pairs(Players:GetPlayers()) do
                    
                    if v.Character and Player.Character and Player ~= v then
                    
                        local targetPart = v.Character:FindFirstChild("HumanoidRootPart")
                        local framePart = Player.Character:FindFirstChild("HumanoidRootPart")
                        if targetPart and framePart then
                            
                            if (framePart.Position - targetPart.Position).Magnitude < 20 then
                            
                                playerCast(v,"deletrius",nil,true)
                                task.wait(0.25)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)()
    end
end

function funcTable.framePlayer:Stop(Player)
    self.playerList[Player] = nil
end

function funcTable.wandIgnore:IgnoreWalls(value)
    self.IgnoreWall = value
end

function funcTable.wandIgnore:IgnoreTerrain(value)
    self.IgnoreT = value
end
--local oldCall

    --[[  oldCall = hookmetamethod(game,"__namecall",function(selfArg,...)
        local callMethod = (getnamecallmethod() == "FindPartOnRayWithIgnoreList")
        local scriptArgs = {...}
        if not checkcaller() and selfArg == workspace and callMethod and (funcTable.wandIgnore.IgnoreWall or funcTable.wandIgnore.IgnoreT) then
            if getcallingscript().Name == "spellRendering" then
                print('whylag')
                local returnedList 
                
                if funcTable.wandIgnore.IgnoreWall then
                    returnedList = objPlayerList
                end
                if not funcTable.wandIgnore.IgnoreT then
                    table.insert(returnedList,workspace.Terrain)
                end

                return  workspace:FindPartOnRayWithWhitelist(scriptArgs[1], returnedList, scriptArgs[4])
            end
        end
        return oldCall(selfArg,...)
    end)-]]
    
local typeTable = {
    ["stunSpells"] = stunSection,
    ["killSpells"] = killSection,
    ["utilitySpells"] = utilitySection,
    ["elderSpells"] = elderSection,
    ["damageSpells"] = damageSection,
    ["miscHeal"] = miscSection,
    ["customSpells"] = customSection,
}







local stringPlayerList = {}
for _,v in pairs(Players:GetPlayers()) do
    if v ~= localPlayer then
        table.insert(stringPlayerList,v.Name)
        table.insert(objPlayerList,v)
    end
end

local customSpellDebounce = false
local customSpells = {
    ["Meteorus"] = function()
        pcall(function()
        if not customSpellDebounce then
            customSpellDebounce = true
            local hailSpell = spellHandler.LoadCustom("confringo")
            for _ = 1,30 do
                local finalPosition = playerMouse.Hit * Vector3.new(math.random(-10,15),5,math.random(-10,10))
                if (finalPosition - localPlayer.Character.HumanoidRootPart.Position).Magnitude < 76 then
                    hailSpell:CustomCast({finalPosition + Vector3.new(math.random(-10,10),50,math.random(-10,10)),finalPosition})
                    wait(0.05)
                end
            end
            spellHandler.Unload("confringo")
            customSpellDebounce = false
        end
    end)
    customSpellDebounce = false
    end,
    ["Fixa"] = function()
        local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
        local targetList = {}
        for _,v in pairs(Players:GetPlayers()) do
            local targetChar = v.Character
            if targetChar then
                if v:DistanceFromCharacter(character.HumanoidRootPart.Position) < 30 and v ~= localPlayer then
                    table.insert(targetList,v)
                end
            end
        end
        
        local healSpell = spellHandler.LoadCustom("Episkey")

        local targSpellList = {
            "vulnera sanentur",
            "finite incantatem",
            "diffindo",
            "rennervate",
        }
        for _,spell in ipairs(targSpellList) do
            hiddenChat(spell)
            for _,target in pairs(targetList) do
                playerCast(target,spell,nil,true)

                --healSpell:CustomCast({character.Head.Position,target.Character.HumanoidRootPart.Position})
                task.wait(0.25)
            end
        end   
    end,


    
    ["Soul Decimatus"] = function()
        
        -- # SPELL DESIGN
        if not customSpellDebounce then
            pcall(function()
            customSpellDebounce = true
            local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
            local mouseTarget = playerMouse.Target.Parent:FindFirstChild("Humanoid")
            if mouseTarget then
                local targetPlayer = Players:GetPlayerFromCharacter(mouseTarget.Parent)
                
                    playerCast(targetPlayer,"alarte ascendare")
                    wait(0.8)
                    for i = 1,8 do
                        playerCast(targetPlayer,"duro")
                        wait()
                    end
                    local soulRender = spellHandler.LoadCustom("sectumsempra")
                    wait(0.8)
                    pcall(function()
                    for i = 1,20 do
                        soulRender:CustomCast({character.RightHand.Position,targetPlayer.Character.HumanoidRootPart.Position})
                        soulRender:CustomCast({character.LeftHand.Position,targetPlayer.Character.HumanoidRootPart.Position})
                        wait(0.05)
                    end
                
                end)
            end
            customSpellDebounce = false
    end)
    customSpellDebounce = false
    end
    end,

}





local dropdownData = {
    loopKill = "",
    framedPlayer = "",
}


local currentKeybinds



if readfile then
    local jsonKeybind = isfile("MTKeybinds.json")
    currentKeybinds = jsonKeybind and HTTPService:JSONDecode(readfile("MTKeybinds.json")) or writefile("MTKeybinds.json",HTTPService:JSONEncode({})) and {}
    if not currentKeybinds then
        currentKeybinds = {}
    end
else
    currentKeybinds = {}
end

local function saveBinds()
    if writefile then
        writefile("MTKeybinds.json",HTTPService:JSONEncode(currentKeybinds))
    else
        mtMain:Notify("MTMain", "Your exploit is not compatible with writefile")
    end
end

for typeName,spellDir in pairs(spellList) do
    
    local currentObj = typeTable[typeName]
    
    if typeName == "elderSpells" then
        for _,spellName in pairs(spellDir) do
            local keybindInd = currentKeybinds[spellName]
            local existingBind = nil
            if keybindInd then
                existingBind = Enum.KeyCode[keybindInd]
            end
            currentObj:addKeybind(spellName,existingBind,function()
                sendChatMethod(spellName)
                elderCast(string.lower(spellName))  
            end,
            function(key)
                currentKeybinds[spellName] = key and key.KeyCode.Name or nil 
                saveBinds()
            end)
        end
    elseif typeName == "customSpells" then
        for _,spellName in pairs(spellDir) do
            local keybindInd = currentKeybinds[spellName]
            local existingBind = nil
            if keybindInd then
                existingBind = Enum.KeyCode[keybindInd]
            end
            currentObj:addKeybind(spellName,existingBind,customSpells[spellName],
            function(key)
                currentKeybinds[spellName] = key and key.KeyCode.Name or nil 
                saveBinds()
            end)
        end
    else
        for _,spellName in pairs(spellDir) do
            local keybindInd = currentKeybinds[spellName]
            local existingBind = nil
            if keybindInd then
                existingBind = Enum.KeyCode[keybindInd]
            end
            currentObj:addKeybind(spellName,existingBind,function()
                sendChatMethod(spellName:lower())
            end,
            function(key)
                currentKeybinds[spellName] = key and key.KeyCode.Name or nil 
                saveBinds()
            end)
        end
    end 
end

-- | buttons and toggles
funcTable.autoHeal:Init()
funcTable.autoClash:Init()
funcTable.loopBlock:Init()
auraTable:InitAuras()

keybindSettings:addToggle("Hide Spells",true, function(value)
    preferences.generalSettings.hideSpells = value
    if value then
        sendChatMethod = hiddenChat
    else
        sendChatMethod =  chatTrue
    end
end)







healCounterSection:addToggle("Auto-Heal",false,function(value)
    funcTable.autoHeal:SetEnabled(value)
end)

healCounterSection:addToggle("Auto-Diffindo",false,function(value)
    funcTable.autoHeal:SetCounterEnabled(value)
end)

funcSection:addToggle("Smoke Particles",false,function(value)
    funcTable.smokeParticles:SetEnabled(value)
    if value then
        activateParticles(true)
        elderCast("appa",{name = "mousePos", value = localPlayer.Character.HumanoidRootPart.Position})
    else
        activateParticles(false)
    end
end)

funcSection:addToggle("Loop Block",false,function(value)
    funcTable.loopBlock:SetEnabled(value)
end)

funcSection:addToggle("Anti Elder Spells",false,function(value)
    funcTable.antiElder:SetEnabled(value)
end)

fullAutoSpells:addSlider("Full Auto Delay",1,1,50,function(value)
    funcTable.autoSpells.intervalTime = (value/10)/2
end)

fullAutoSpells:addToggle("Full Auto Spells",false,function(value)
    funcTable.autoSpells:SetEnabled(value)
end) 



fullAutoSpells:addToggle("Wandless Magic (Auto Only)",false,function(value)
    funcTable.wandlessMagic:SetEnabled(value)
end)

generalSection:addButton("Give Flight",function()
    funcTable.permFlight:Execute()
end)

generalSection:addButton("deleted",function()
    mtMain:Notify("no","no")
end)


clashSection:addToggle("Auto-Clash",false,function(value)
    funcTable.autoClash:SetEnabled(value)
end)

clashSection:addToggle("Legit Mode", false, function(value)
    funcTable.autoClash:LegitMode(value)
end)


local bringObj = bringSection:addDropdown("Players",stringPlayerList,function(value)
    dropdownData.bringValue = value
end)

bringSection:addButton("Attempt Bring",function()
    local attemptNum = 0
    hiddenChat("carpe retractum")
    local playerTarget = Players:FindFirstChild(dropdownData.bringValue)
    while true do 
        if attemptNum > 200 or not Players:FindFirstChild(dropdownData.bringValue) then
            break
        elseif attemptNum % 25 then
            hiddenChat("carpe retractum")
        end
        wait(0.1)
        playerCast(playerTarget,"carpe retractum",nil,true)
        attemptNum = attemptNum + 1
        if (localPlayer.Character.HumanoidRootPart.Position - playerTarget.Character.HumanoidRootPart.Position).Magnitude < 80 then
            break
        end
    end
end)

local killObj = loopSection:addDropdown("Players",stringPlayerList,function(value)
    dropdownData.loopKill = value
end)

local frameObj = frameSection:addDropdown("Players",stringPlayerList,function(value)
    dropdownData.framedPlayer = value
end)

frameSection:addButton("Begin Frame",function()
    funcTable.framePlayer:Start(Players:FindFirstChild(dropdownData.framedPlayer))
end)

frameSection:addButton("End Frame",function()
    funcTable.framePlayer:Stop(Players:FindFirstChild(dropdownData.framedPlayer))
end)

loopSection:addButton("Begin Loopkill",function()
    funcTable.loopKill:Start(Players:FindFirstChild(dropdownData.loopKill))
end)

auraSection:addToggle("Heal Aura (BROKEN)",false,function(value)
    auraTable.healAura:SetEnabled(value)
    auraTable.loopObj()
end)

loopSection:addButton("End Loopkill",function()
    funcTable.loopKill:Stop(Players:FindFirstChild(dropdownData.loopKill))
end)

for theme, color in pairs(themes) do 
    mtMain:setTheme(theme, color)
end



Players.PlayerAdded:Connect(function(player)
    table.insert(stringPlayerList,player.Name)
    table.insert(objPlayerList,player)
    if table.find(modList,player.Name) then
        mtMain:Notify("Mod joined game: "..player.Name)
    end
-- loopSection:updateDropdown(killObj,"Players",stringPlayerList)
end)



Players.PlayerRemoving:Connect(function(player)
    table.remove(stringPlayerList,table.find(stringPlayerList,player.Name))
    table.remove(objPlayerList,table.find(objPlayerList,player))
    local killResult = funcTable.loopKill:Stop(player)
    local frameResult = funcTable.framePlayer:Stop(player)
    if killResult then
        mtMain:Notify("MTMain",string.format("Loopkill stopped for %s (player left server)",player.Name))
    end
end)

mtMain:SelectPage(mtMain.pages[1],true)
mtMain:Notify("LunarSpell","Loaded version: ["..VERSION.. "]")
task.wait(1)
mtMain:Notify("LunarSpell","Thanks for supporting my project")
