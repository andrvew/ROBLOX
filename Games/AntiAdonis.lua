-- not made by me
for i, v in next, getgc(true) do
    if type(v) == 'table' then
        if type(rawget(v, 'indexInstance')) == 'table' and v.indexInstance[1] == 'kick' then
            v.indexInstance[2] = function()
                return coroutine.yield()
            end
        end
    end
end