

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
		DoorsList[_]                = {}
		DoorsList[_]                = result

		DoorsList[_].locationId     = 'none'
		DoorsList[_].owned          = 0
		DoorsList[_].charidentifier = 0

		DoorsList[_].keyholders     = {}
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

RegisterServerEvent("tpz_doorlocks:requestDoorlocks")
AddEventHandler("tpz_doorlocks:requestDoorlocks", function()
	local _source = source

	while not LoadedDoorsList do
		Wait(1000)
	end

	if GetTableLength(DoorsList) <= 0 then
		return
	end

	TriggerClientEvent("tpz_doorlocks:loadDoorsList", _source, DoorsList)
end)


-- @locationId : Where or what property (name of property) the new door will be registered to.
RegisterServerEvent("tpz_doorlocks:registerNewDoorlock")
AddEventHandler("tpz_doorlocks:registerNewDoorlock", function(locationId, doors, canBreakIn, keyholders, charidentifier)

	while not LoadedDoorsList do
		Wait(1000)
	end

	local length = GetTableLength(DoorsList)
	local doorId = length + 1

	DoorsList[doorId]                = {}

	DoorsList[doorId].index          = doorId
	
	DoorsList[doorId].authorizedJobs = { 'none' }
	DoorsList[doorId].doors          = doors
	DoorsList[doorId].textCoords     = doors[1].textCoords
	DoorsList[doorId].locked         = true

	DoorsList[doorId].distance       = 2.0

	DoorsList[doorId].canBreakIn     = canBreakIn
	DoorsList[doorId].locationId     = locationId

	DoorsList[doorId].keyholders     = keyholders

	DoorsList[doorId].owned          = 1
	DoorsList[doorId].charidentifier = charidentifier

	TriggerClientEvent("tpz_doorlocks:registerNewDoorlock", -1, doorId, doors, canBreakIn, keyholders, 1, charidentifier)
	
end)


RegisterServerEvent("tpz_doorlocks:updateDoorlockInformation")
AddEventHandler("tpz_doorlocks:updateDoorlockInformation", function(locationId, type, data )

	for _, door in pairs (DoorsList) do

		if door.locationId == locationId then

			if type == 'TRANSFERRED' then
		
				DoorsList[_].charidentifier = data[1]

		        elseif type == 'RESET' then

				DoorsList[_].charidentifier = 0

				DoorsList[_].keyholders     = nil
				DoorsList[_].keyholders     = {}

			elseif type == 'REGISTER_KEYHOLDER' then

				DoorsList[_].keyholders[data[1]]           = {}
				DoorsList[_].keyholders[data[1]].username  = data[2]

			elseif type == 'UNREGISTER_KEYHOLDER' then

				DoorsList[_].keyholders[data[1]] = nil

			end

		end

	end

	-- We update and do client triggers outside from looping to avoid multiple calls.
	if type == 'TRANSFERRED' then

		TriggerClientEvent("tpz_doorlocks:update", -1, locationId, type, { data[1] } )

	elseif type == 'RESET' then

		TriggerClientEvent("tpz_doorlocks:update", -1, locationId, type )

	elseif type == 'REGISTER_KEYHOLDER' then

		TriggerClientEvent("tpz_doorlocks:update", -1, locationId, type, { data[1], data[2] } )

	elseif type == 'UNREGISTER_KEYHOLDER' then
		
		TriggerClientEvent("tpz_doorlocks:update", -1, locationId, type, { data[1] } )

	end

end)

RegisterServerEvent('tpz_doorlocks:updateState')
AddEventHandler('tpz_doorlocks:updateState', function(doorID, state)

	if type(doorID) ~= 'number' then
		return
	end

	TriggerClientEvent('tpz_doorlocks:setState', -1, doorID, state)
end)

