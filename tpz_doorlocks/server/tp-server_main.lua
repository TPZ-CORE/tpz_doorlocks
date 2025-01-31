

local DoorsList = {}
local LoadedDoorsList = false

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

-- @GetTableLength returns the length of a table.
local GetTableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

local LoadExistingDoorlockLocations = function ()

	for _, result in ipairs(Config.DoorsList) do
		DoorsList[_] = {}
		DoorsList[_] = result
	end

	LoadedDoorsList = true
end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	LoadExistingDoorlockLocations()

end)


AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DoorsList = nil
end)

-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_doorlocks:server:requestDoorlocks")
AddEventHandler("tpz_doorlocks:server:requestDoorlocks", function()
	local _source = source

	while not LoadedDoorsList do
		Wait(1000)
	end

	if GetTableLength(DoorsList) <= 0 then
		return
	end

	TriggerClientEvent("tpz_doorlocks:client:loadDoorsList", _source, DoorsList)
end)

RegisterServerEvent('tpz_doorlocks:server:updateState')
AddEventHandler('tpz_doorlocks:server:updateState', function(doorID, state)

	if type(doorID) ~= 'number' then
		return
	end

	TriggerClientEvent('tpz_doorlocks:client:setState', -1, doorID, state)
end)
