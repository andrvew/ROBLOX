-- // Vars
local HttpService = game:GetService("HttpService")

-- // Embed Class
local Embed = {}
Embed.__index = Embed
do
    -- // Constructor
    function Embed.new(username, avatar_Url)
        -- // Initialise class
        local self = setmetatable({}, Embed)

        -- // Initialise vars
        self.username = username or "" 
        self.avatar_url = avatar_Url or ""
        self.embeds = {}

        -- // Return class
        return self
    end

    -- // Create embed
    function Embed:CreateEmbed(title, description, color)
        local embed = {
            title = title or "",
            description = description or "",
            type = "rich",
            color = color or tonumber(0xFFFFFF),
            thumbnail = {},
            author = {},
            footer = {},
            fields = {}
        }
        table.insert(self.embeds, embed)

        -- // Return embed
        return embed
    end

    -- // Config Embed
    do
        -- // Set the thumbnail of the embed
        function Embed:SetThumbnail(embed, url)
            embed.thumbnail.url = url or ""
        end

        -- // Set the author of the embed
        function Embed:SetAuthor(embed, name, icon_url)
            embed.author.name = name or ""
            embed.author.icon_url = icon_url or ""
        end

        -- // Set the footer of the embed
        function Embed:SetFooter(embed, text, icon_url)
            embed.footer.text = text or ""
            embed.footer.icon_url = icon_url or ""
        end

        -- // Set the timestamp of the embed
        function Embed:SetTimestamp(embed, timestamp)
            embed.timestamp = timestamp and DateTime.now():ToIsoDate() or nil
        end

        -- // Add a field to the embed
        function Embed:AddField(embed, name, value, inline)
            local field = {
                name = name or "",
                value = value or "",
                inline = inline or true
            }
            table.insert(embed.fields, field)
        end
    end

    -- // Send the embed
    function Embed:SendEmbed(webhookUrl)
        local response = request({
            Url = webhookUrl,
            Method = "POST",
            Headers = {["content-type"] = "application/json"},
            Body = HttpService:JSONEncode({
                username = self.username,
                avatar_url = self.avatar_url,
                embeds = self.embeds
            })
        })
        
        -- // Return response
        return response
    end
end

-- // Return
return Embed