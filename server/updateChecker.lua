local resourceName = GetCurrentResourceName()
local currentVersion = 'v1.0.0'
local githubApiUrl = 'https://api.github.com/repos/Puffin-Project/puffin-jobcenter/releases/latest'

local function checkVersion()
    PerformHttpRequest(githubApiUrl, function(err, response, headers)
        if err == 200 then
            local data = json.decode(response)
            if data and data.tag_name then
                local latestVersion = data.tag_name

                if latestVersion ~= currentVersion then
                    print('^3[' .. resourceName .. '] A new update is available!^0 ^3Current version: ^0' .. currentVersion .. ' ^2Latest version: ^0' .. latestVersion)
                else
                    print('^2[' .. resourceName .. '] You are running the latest version (' .. currentVersion .. ')^0')
                end
            else
                print('^1[' .. resourceName .. '] Failed to parse GitHub response^0')
            end
        else
            print('^1[' .. resourceName .. '] Could not connect to GitHub (HTTP ' .. err .. ')^0')
        end
    end, 'GET', '', { ['User-Agent'] = 'Mozilla/5.0' })
end

if Config.UpdateChecker then
    checkVersion()
end