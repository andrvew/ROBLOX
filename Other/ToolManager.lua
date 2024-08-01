local Tool = {}
Tool.__index = Tool

do
    function Tool.new(player)
        assert(player and player:IsA("Player"), "A valid player instance is required.")
        local self = setmetatable({}, Tool)
    
        self.player = player
        self.currentTool = nil
        self.backpack = {}

        Tool:UpdateBackpackTools()
        Tool:Update()
        
        return self
    end

    function Tool:UpdateCharacterTool()
        if not self.player.character then return end

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

        if self.player:FindFirstChild("Backpack") then return end

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

    function Tool:Update()
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
    
        self.player.Backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then
                table.insert(self.backpack, child)
            end
        end)
        
        self.player.Backpack.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then
                for i, tool in ipairs(self.backpack) do
                    if tool == child then
                        table.remove(self.backpack, i)
                        break
                    end
                end
            end
        end)
    end
end

return Tool