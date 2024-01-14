

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
		DoorsList[_]            = {}
		DoorsList[_]            = result
	end

end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStart', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	LoadExistingDoorlockLocations()

    exports["ghmattimysql"]:execute("SELECT * FROM doors", {}, function(result)

		local length = GetTableLength(result)

		if GetTableLength(result) <= 0 then
			LoadedDoorsList = true
			return
		end

		local count = length

        for index, res in pairs (result) do
			count = count + 1

			DoorsList[count] = {}

			DoorsList[count].index          = index
			DoorsList[count].authorizedJobs = { 'none' }
			DoorsList[count].doors          = json.decode(res.doors)
			DoorsList[count].textCoords     = DoorsList[count].doors[1].objCoords
			DoorsList[count].locked         = true
			DoorsList[count].distance       = 2.0

			local canBreakIn = false

			if res.canBreakIn == 1 then
				canBreakIn = true
			end

			DoorsList[count].canBreakIn     = canBreakIn
		end

		LoadedDoorsList = true
	end)

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


RegisterServerEvent("tpz_doorlocks:createNewDoorlock")
AddEventHandler("tpz_doorlocks:createNewDoorlock", function(doors, canBreakIn)

	local Parameters =  { 
		['doors']      = json.encode(doors),
		['canBreakIn'] = canBreakIn,
	}

	exports.ghmattimysql:execute("INSERT INTO `doors` ( `doors`, `canBreakIn` ) VALUES ( @doors, @canBreakIn )", Parameters )

end)

RegisterServerEvent('tpz_doorlocks:updateState')
AddEventHandler('tpz_doorlocks:updateState', function(doorID, state)

	if type(doorID) ~= 'number' then
		return
	end

	TriggerClientEvent('tpz_doorlocks:setState', -1, doorID, state)
end)

