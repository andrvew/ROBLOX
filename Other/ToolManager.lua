local Tool = {}
Tool.__index = Tool

function Tool.new(player)
    assert(player and player:IsA("Player"), "A valid player instance is required.")

    local self = setmetatable({}, Tool)
    
    self.player = player
    self.currentTool = nil
    self.backpack = {}

    self:UpdateBackpackTools()
    self:ListenToEvents()
    
    return self
end

function Tool:UpdateCharacterTool()
    if not self.player.Character then return nil end

    for _, item in pairs(self.player.Character:GetChildren()) do
        if item:IsA("Tool") then
            self.currentTool = item
            return item
        end
    end

    self.currentTool = nil

    return nil
end

function Tool:UpdateBackpackTools()
    self.backpack = {}

    if not self.player:FindFirstChild("Backpack") then return end

    for _, item in pairs(self.player.Backpack:GetChildren()) do
        if item:IsA("Tool") then
            table.insert(self.backpack, item)
        end
    end
end

do
    function Tool:GetCharacterTool()
        return self:UpdateCharacterTool()
    end
    
    function Tool:GetBackpackTools()
        self:UpdateBackpackTools()
    
        return self.backpack
    end
end

function Tool:ListenToEvents()
    local function onCharacterAdded(character)
        character.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                self.currentTool = child
            end
        end)
        
        character.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                self.currentTool = nil
            end
        end)
    end

    if self.player.Character then
        onCharacterAdded(self.player.Character)
    end

    self.player.CharacterAdded:Connect(onCharacterAdded)

    self.player.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            child.ChildAdded:Connect(function(grandChild)
                if grandChild:IsA("Tool") then
                    table.insert(self.backpack, grandChild)
                end
            end)

            child.ChildRemoved:Connect(function(grandChild)
                if grandChild:IsA("Tool") then
                    for i, tool in ipairs(self.backpack) do
                        if tool == grandChild then
                            table.remove(self.backpack, i)
                            break
                        end
                    end
                end
            end)
        end
    end)
end

return Tool