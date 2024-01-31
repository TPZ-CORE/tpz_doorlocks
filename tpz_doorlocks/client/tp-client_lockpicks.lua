
local LockpickedDoors = {}

-----------------------------------------------------------
--[[ Functions ]]--
-----------------------------------------------------------

IsAuthorizedToLockpick = function(doorID)
	local data = ClientData.DoorsList[doorID]

	if not data.locked or data.owned == 0 or not data.canBreakIn then
		return false
	end

	return true
end

-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    
	local length = GetTableLength(LockpickedDoors)

	if length > 0 then

		for i, v in pairs(LockpickedDoors) do
		
			if v.blip then
				RemoveBlip(v.blip)
			end
	
		end

	end

end)
-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

RegisterNetEvent("tpz_doorlocks:createPropertyBlip")
AddEventHandler("tpz_doorlocks:createPropertyBlip", function(doorID, coords)

	if LockpickedDoors[doorID] then
		return
	end

	local blip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coords.x, coords.y, coords.z, 40.0)

	Citizen.InvokeNative(0x9CB1A1623062F402, blip, Locales['PROPERTY_ROBBERY_BLIP_TITLE'])
	Citizen.InvokeNative(0x662D364ABF16DE2F, blip, 0x3F90ADF0)

	LockpickedDoors[doorID] = {}
	LockpickedDoors[doorID].blip = blip
end)

RegisterNetEvent("tpz_doorlocks:removePropertyBlip")
AddEventHandler("tpz_doorlocks:removePropertyBlip", function(doorID)

	if LockpickedDoors[doorID] == nil then
		return
	end
	RemoveBlip(LockpickedDoors[doorID].blip)

	LockpickedDoors[doorID] = nil

end)


--[[-------------------------------------------------------
 Threads
]]---------------------------------------------------------

-- The following thread is used for lockpicking, to perform animations when isLockpicking active.
Citizen.CreateThread(function()

	while true do
		Citizen.Wait(1000)

		if ClientData.IsLockpicking then

			local playerPed = PlayerPedId()

			if not IsEntityPlayingAnim(playerPed, "script_proc@rustling@olar@player_picklock", "base", 3) then

				local waiting = 0

				RequestAnimDict("script_proc@rustling@olar@player_picklock")

				while not HasAnimDictLoaded("script_proc@rustling@olar@player_picklock") do
					waiting = waiting + 100
					Citizen.Wait(10)
					if waiting > 5000 then
						break
					end
				end

				Wait(100)
				TaskPlayAnim(playerPed, 'script_proc@rustling@olar@player_picklock', 'base', 8.0, 8.0, 120000, 31, 0, true, 0, false, 0, false)
			end 
		end

	end

end)