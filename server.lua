RegisterNetEvent('ersi:server:getVehicleOwner', function(plate)
    local src = source

    plate = plate:match("^%s*(.-)%s*$")

    exports.oxmysql:single([[
        SELECT p.charinfo
        FROM player_vehicles v
        JOIN players p ON p.citizenid = v.citizenid
        WHERE v.plate = ?
    ]], { plate }, function(result)

        if result and result.charinfo then
            local charinfo = json.decode(result.charinfo)

            TriggerClientEvent('chat:addMessage', src, {
                color = { 0, 150, 255 },
                multiline = true,
                args = {
                    'DISPATCH',
                    ('Owner: %s %s | Plate: %s')
                        :format(charinfo.firstname, charinfo.lastname, plate)
                }
            })
        else
            TriggerClientEvent('chat:addMessage', src, {
                color = { 255, 0, 0 },
                args = {
                    'DISPATCH',
                    ('No owner found for plate: %s'):format(plate)
                }
            })
        end
    end)
end)