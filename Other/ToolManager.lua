local Tool = {}
Tool.__index = Tool

function Tool.new(player)
    assert(player and player:IsA("Player"), "A valid player instance is required.")

    local self = setmetatable({}, Tool)

    self.player = player
    self.currentTool = nil
    self.currentBackpack = nil

    return self
end

do
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
        if not self.player:FindFirstChild("Backpack") then return end

        for _, item in pairs(self.player.Backpack:GetChildren()) do
            if item:IsA("Tool") then
                self.currentBackpack = item
                return item
            end
        end

        self.currentBackpack = nil

        return nil
    end

    function Tool:GetCharacterTool()
        return self:UpdateCharacterTool()
    end

    function Tool:GetBackpackTools()
        return self:UpdateBackpackTools()
    end
end


return Tool
