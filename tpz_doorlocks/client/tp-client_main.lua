
local PlayerData = { 
	Job       = nil, 
	Loaded    = false, 
	DoorsList = {}
}

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local IsAuthorized = function(doorID, owned)

	local data = PlayerData.DoorsList[doorID]

	if data.authorizedJobs and GetTableLength(data.authorizedJobs) > 0 then

		for _, job in pairs(data.authorizedJobs) do

			if job == PlayerData.Job then
				return true
			end

		end

		return false

	end

	return true
end

-----------------------------------------------------------
--[[ Base Events & Threads ]]--
-----------------------------------------------------------

-- Gets the player job when character is selected.
AddEventHandler("tpz_core:isPlayerReady", function()

	Wait(2000)

	local data = exports.tpz_core:getCoreAPI().getPlayerClientData()

	if data == nil then
		return
	end

	PlayerData.Job = data.job

	TriggerServerEvent("tpz_doorlocks:server:requestDoorlocks")
	
end)

-- Gets the player job when devmode set to true.
if Config.DevMode then
    Citizen.CreateThread(function ()

        Wait(2000)

        local data = exports.tpz_core:getCoreAPI().getPlayerClientData()

		if data == nil then
			return
		end

		PlayerData.Job = data.job

		TriggerServerEvent("tpz_doorlocks:server:requestDoorlocks")

    end)
end

RegisterNetEvent("tpz_core:getPlayerJob")
AddEventHandler("tpz_core:getPlayerJob", function(data)
	PlayerData.Job = data.job
end)

-----------------------------------------------------------
--[[ Events ]]--
-----------------------------------------------------------

RegisterNetEvent("tpz_doorlocks:client:loadDoorsList")
AddEventHandler("tpz_doorlocks:client:loadDoorsList", function(data)
	PlayerData.DoorsList = data
	PlayerData.Loaded    = true
end)


RegisterNetEvent("tpz_doorlocks:client:setState")
AddEventHandler("tpz_doorlocks:client:setState", function(doorId, state)
	PlayerData.DoorsList[doorId].locked = state
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

		for _, location in ipairs(PlayerData.DoorsList) do

			local dist = #(coords - location.doors[1].objCoords)

			for k, door in ipairs(location.doors) do

            if door ~= false and not door.object then

               local distance = #(coords - door.objCoords)

               if distance <= Config.RenderDoorStateDistance then
               
                  local shapeTest = StartShapeTestBox(door.objCoords, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, true, 16)
                  local rtnVal, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)

                  if DoesEntityExist(entityHit) then

                     local model = GetEntityModel(entityHit)

                     for _,v in pairs(DOOR_HASHES) do 

                        if model == v[2] then
                           local doorcoords = vector3(v[4],v[5], v[6])
                           local distance = #(doorcoords - door.objCoords)

                           if distance <= 1.2 then
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

		if not isDead and PlayerData.Loaded then

			for k, v in ipairs(PlayerData.DoorsList) do

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

						TriggerServerEvent('tpz_doorlocks:server:updateState', k, (not v.locked) )
						
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
