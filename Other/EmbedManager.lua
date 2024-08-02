local HttpService = game:GetService("HttpService")

local Embed = {}
Embed.__index = Embed
do
    function Embed.new(username, avatar_Url)
        local self = setmetatable({}, Embed)

        self.username = username or "" 
        self.avatar_url = avatar_Url or ""
        self.embeds = {}

        return self
    end

    function Embed:CreateEmbed(title, description, color)
        local embed = {
            title = title or "",
            description = description or "",
            type = "rich",
            color = (type(color) == "string" and color:match("^%x+$")) and tonumber(color, 16) or tonumber(0xFFFFFF),
            thumbnail = {},
            author = {},
            footer = {},
            fields = {}
        }
        table.insert(self.embeds, embed)

        return embed
    end

    do
        function Embed:SetThumbnail(embed, url)
            embed.thumbnail.url = url or ""
        end

        function Embed:SetAuthor(embed, name, icon_url)
            embed.author.name = name or ""
            embed.author.icon_url = icon_url or ""
        end

        function Embed:SetFooter(embed, text, icon_url)
            embed.footer.text = text or ""
            embed.footer.icon_url = icon_url or ""
        end

        function Embed:SetTimestamp(embed, timestamp)
            embed.timestamp = timestamp and DateTime.now():ToIsoDate() or nil
        end

        function Embed:AddField(embed, name, value, inline)
            local field = {
                name = name or "",
                value = value or "",
                inline = inline or true
            }
            table.insert(embed.fields, field)
        end
    end

    function Embed:SendEmbed(webhookUrl)
        local response = request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({
                username = self.username,
                avatar_url = self.avatar_url,
                embeds = self.embeds
            })
        })
        
        return response
    end
end

return Embed