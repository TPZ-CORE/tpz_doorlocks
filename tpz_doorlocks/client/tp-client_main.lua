
local ClientData = { CharIdentifier = 0, Job = nil, Loaded = false, DoorsList = {} }

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local IsAuthorized = function(doorID, owned)

	local data = ClientData.DoorsList[doorID]

	if owned == 0 then
		for _, job in pairs(data.authorizedJobs) do
			if job == ClientData.Job then
				return true
			end
		end

	else

		local found  = false

		if data.charidentifier == ClientData.CharIdentifier then
			return true
		end

		local length = GetTableLength(data.keyholders)

		if length > 0 then
	 
		   for _, keyholder in pairs (data.keyholders) do
			  
			  if _ == tostring(ClientData.CharIdentifier) then
				 found = true
			  end
		   end
	 
		end
	 
		return found

	end

	return false
end

-----------------------------------------------------------
--[[ Base Events & Threads ]]--
-----------------------------------------------------------

-- Gets the player job when character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()

    TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)
		ClientData.CharIdentifier = data.charIdentifier
        ClientData.Job = data.job

		TriggerServerEvent("tpz_doorlocks:requestDoorlocks")
    end)

end)

-- Gets the player job when devmode set to true.
if Config.DevMode then
    Citizen.CreateThread(function ()

        Wait(2000)

        TriggerEvent("tpz_core:ExecuteServerCallBack", "tpz_core:getPlayerData", function(data)

			if data == nil then
				return
			end
			ClientData.CharIdentifier = data.charIdentifier
            ClientData.Job = data.job

			TriggerServerEvent("tpz_doorlocks:requestDoorlocks")
        end)

    end)
end


-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

RegisterNetEvent("tpz_doorlocks:loadDoorsList")
AddEventHandler("tpz_doorlocks:loadDoorsList", function(data)
	ClientData.DoorsList = data

	ClientData.Loaded = true
end)


RegisterNetEvent("tpz_doorlocks:setState")
AddEventHandler("tpz_doorlocks:setState", function(doorId, state)
	ClientData.DoorsList[doorId].locked = state
end)


-- Register new doorlock based on its parameters.
RegisterNetEvent("tpz_doorlocks:registerNewDoorlock")
AddEventHandler('tpz_doorlocks:registerNewDoorlock', function(doorID, doors, canBreakIn, keyholders, owned, charidentifier)

	ClientData.DoorsList[doorID]                = {}

	ClientData.DoorsList[doorID].index          = doorID
	
	ClientData.DoorsList[doorID].authorizedJobs = { 'none' }
	ClientData.DoorsList[doorID].doors          = doors
	ClientData.DoorsList[doorID].textCoords     = doors[1].textCoords
	ClientData.DoorsList[doorID].locked         = true

	ClientData.DoorsList[doorID].distance       = 2.0

	ClientData.DoorsList[doorID].canBreakIn     = canBreakIn

	ClientData.DoorsList[doorID].keyholders     = keyholders

	ClientData.DoorsList[doorID].owned          = owned

	ClientData.DoorsList[doorID].charidentifier = charidentifier
end)

RegisterNetEvent("tpz_doorlocks:update")
AddEventHandler("tpz_doorlocks:update", function(locationId, type, data)

	for _, door in pairs (ClientData.DoorsList) do

		if door.locationId == locationId then

			if type == 'TRANSFERRED' then
		
				ClientData.DoorsList[_].charidentifier = data[1]

			elseif type == 'REGISTER_KEYHOLDER' then

				ClientData.DoorsList[_].keyholders[data[1]]           = {}
				ClientData.DoorsList[_].keyholders[data[1]].username  = data[2]

			elseif type == 'UNREGISTER_KEYHOLDER' then

				ClientData.DoorsList[_].keyholders[data[1]] = nil

			end

		end

	end

end)

--[[-------------------------------------------------------
 Threads
]]---------------------------------------------------------


-- Get objects every second, instead of every frame by checking DOOR_HASHES file for getting the correct
-- object and its hashes.
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)

		for _, location in ipairs(ClientData.DoorsList) do

			local dist = #(coords - location.doors[1].objCoords)

			if dist <= Config.RenderDoorStateDistance then

				for k, door in ipairs(location.doors) do

					if door ~= false and not door.object and type(door) == 'table' then
	
						local shapeTest = StartShapeTestBox(door.objCoords, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, true, 16)
						local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
	
						if DoesEntityExist(entityHit) then
	
							local model = GetEntityModel(entityHit)
	
							for _,v in pairs(DOOR_HASHES) do 
	
								if model == v[2] then
									local doorcoords = vector3(v[4],v[5], v[6])
									local a,b,c = table.unpack(doorcoords)
									local d,f,g = table.unpack(door.objCoords)
									local distance = GetDistanceBetweenCoords(a, b, c, d, f, g, false)
									if distance <= 1 then
										door.object = v[1]

									end
								end
	
							end
	
						end
	
					end
				end
				
			end

		end
	end
end)

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords    = GetEntityCoords(playerPed)
        local isDead    = IsEntityDead(playerPed)

		local sleep     = true

		if not isDead and ClientData.Loaded then

			for k, v in ipairs(ClientData.DoorsList) do

				local distance = #(coords - v.doors[1].objCoords)
	
				local maxDistance, displayText = 1.25, Locales['UNLOCKED']
	
				if v.distance then
					maxDistance = v.distance
				end
	
				if distance < Config.RenderDoorStateDistance then
	
					for _, door in ipairs(v.doors) do

						if door ~= false and door.object and type(door) == 'table' then

							if v.locked then

								if DoorSystemGetOpenRatio(door.object) ~= 0.0 then
									DoorSystemSetOpenRatio(door.object, 0.0, true)
	
									local object = Citizen.InvokeNative(0xF7424890E4A094C0, door.object, 0)
									SetEntityRotation(object, 0.0, 0.0, door.objYaw, 2, true)
								
								end
								if DoorSystemGetDoorState(door.object) ~= 3 then
									Citizen.CreateThread(function()
										Citizen.InvokeNative(0xD99229FE93B46286,door.object,1,1,0,0,0,0)
									end)
									
									local object = Citizen.InvokeNative(0xF7424890E4A094C0, door.object, 0)
									
									Citizen.InvokeNative(0x6BAB9442830C7F53, door.object, 3)
									SetEntityRotation(object, 0.0, 0.0, door.objYaw, 2, true)
									
								end
							else
	
								if DoorSystemGetDoorState(door.object) ~= 0 then
									Citizen.CreateThread(function()
										Citizen.InvokeNative(0xD99229FE93B46286,door.object,1,1,0,0,0,0)
									end)
									Citizen.InvokeNative(0x6BAB9442830C7F53,door.object, 0)
									
								end
							end

						end

					end

				end
	
				if distance < maxDistance then
					sleep = false

					if v.locked then
						displayText = Locales['LOCKED']
					end
	
					DrawText3D(v.textCoords.x, v.textCoords.y, v.textCoords.z, displayText)
	
					if IsControlJustReleased(1, Config.DoorKey) and IsAuthorized(k, v.owned) then

						local entity = Citizen.InvokeNative(0xF7424890E4A094C0, v.doors[1].object, 0)

						PerformKeyAnimation(entity)

						print(k)
						TriggerServerEvent('tpz_doorlocks:updateState', k, (not v.locked) )
						
						Wait(500)
					end
					
			
				end
	
			end

		end

		if sleep then
			Citizen.Wait(1000)
		end
	end
end)
