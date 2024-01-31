local TPZ    = {}

local TPZInv = exports.tpz_inventory:getInventoryAPI()

TriggerEvent("getTPZCore", function(cb) TPZ = cb end)

local ListedDoors = {}

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

-- @GetTableLength returns the length of a table.
local GetTableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-----------------------------------------------------------
--[[ Callback Events  ]]--
-----------------------------------------------------------

RegisterServerEvent('tpz_doorlocks:removeLockpickItem')
AddEventHandler('tpz_doorlocks:removeLockpickItem', function()
	local _source   = source

	TPZInv.removeItem(_source, Config.Lockpicking.Item, 1)
end)

-----------------------------------------------------------
--[[ Callbacks  ]]--
-----------------------------------------------------------

exports.tpz_core:rServerAPI().addNewCallBack("tpz_doorlocks:canStartLockpicking", function(source, cb, data)
	local _source   = source

	local lockpickData = Config.Lockpicking

	local requiredItem = TPZInv.getItemQuantity(_source, lockpickData.Item)

	if not requiredItem or requiredItem < lockpickData.Stages then
		SendNotification(_source, lockpickData.NotEnoughLockpicksNotify, "error")
		return cb(false)
	end

    local jobPlayerList = TPZ.GetJobPlayers(lockpickData.RequiredOnlineJob.Job)

	if jobPlayerList.count < lockpickData.RequiredOnlineJob.Minimum then
		SendNotification(_source, lockpickData.RequiredOnlineJob.NotEnoughNotify, "error")
		return cb(false)
	end

	-- By adding the door in the list, we prevent notification spamming.
	if ListedDoors[data.doorID] == nil then

		if lockpickData.RequiredOnlineJob.Notify then

			for _i, allowedPlayer in pairs (jobPlayerList.players) do
	
				local wNotifyData = lockpickData.NotifyMessage
				TriggerClientEvent("tpz_notify:sendNotification", allowedPlayer.source, wNotifyData.title,  wNotifyData.message, wNotifyData.icon, "error", wNotifyData.duration)
	
				TriggerClientEvent("tpz_doorlocks:createPropertyBlip", allowedPlayer.source, data.doorID, data.coords )
			end
	
		end
	
		ListedDoors[data.doorID] = {}
		ListedDoors[data.doorID].duration = lockpickData.Duration

	end

	return cb(true)

end)

-----------------------------------------------------------
--[[ Threads  ]]--
-----------------------------------------------------------

Citizen.CreateThread(function()
	while true do 
		Wait(60000)

		local length = GetTableLength(ListedDoors)

		if length > 0 then
		
			for _, data in pairs (ListedDoors) do

				data.duration = data.duration - 1

				if data.duration <= 0 then
					ListedDoors[_] = nil
					TriggerClientEvent("tpz_doorlocks:removePropertyBlip", -1, _ )
				end

			end

		end
	end

end)