--[[
    [RELEASE] Dahood Aimbot Arg Finder

    Please Read:

    - Do not claim you made this code.

    Instructions:
        1. When you execute the script, look for the output that starts with "UpdateMousePos". Do not use outputs that do not end with "Pos".
        2. When you identify the correct output, simply replace the arg with the outpout that was printed.
        3. You must repeat this process every time there is an update.
]]

for _, instance in ipairs(game:GetDescendants()) do
    if instance:IsA("LocalScript") then
        for line in tostring(getscriptbytecode(instance)):gmatch("%w+") do
            if line:match("UpdateMousePos") then
                print(line)
            end
        end
    end
end