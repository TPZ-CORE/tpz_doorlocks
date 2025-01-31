
--[[-------------------------------------------------------
 Handlers
]]---------------------------------------------------------

-- @GetTableLength returns the length of a table.
GetTableLength = function(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


LoadModel = function(model)

    local hash = joaat(model)

    RequestModel(hash)

    while not HasModelLoaded(hash) do RequestModel(hash)
        Wait(0)
    end
end

RequestAnimation = function(anim)
	if not DoesAnimDictExist(anim) then
		return false
	end

	RequestAnimDict(anim)

	while not HasAnimDictLoaded(anim) do
		Wait(0)
	end


	return true
end

PerformKeyAnimation = function (entity)
	local playerPed = PlayerPedId()

	ClearPedTasks(playerPed)

	TaskTurnPedToFaceEntity(playerPed, entity, -1)

	Wait(350)

	LoadModel('P_KEY02X')

	local x,y,z     = table.unpack(GetEntityCoords(playerPed, true))
	local prop      = CreateObject(joaat('P_KEY02'), x, y, z + 0.2, true, true, true)
	local boneIndex = GetEntityBoneIndexByName(playerPed, "SKEL_R_Finger12")

	RequestAnimation('script_common@jail_cell@unlock@key')

	TaskPlayAnim(playerPed, 'script_common@jail_cell@unlock@key', 'action', 8.0, -8.0, 2500, 31, 0, true, 0, false, 0, false)

	AttachEntityToEntity(prop, playerPed, boneIndex, 0.02, 0.0120, -0.00850, 0.024, -160.0, 200.0, true, true, false, true, 1, true)

	Wait(1000)

	RemoveAnimDict('script_common@jail_cell@unlock@key')

	DeleteObject(prop)
	DeleteEntity(prop)
    SetEntityAsNoLongerNeeded(prop)

	ClearPedTasks(playerPed)

end

DrawText3D = function(x, y, z, text)
    local onScreen,_x,_y=GetScreenCoordFromWorldCoord(x, y, z)
    local px,py,pz=table.unpack(GetGameplayCamCoord())
    
    SetTextScale(0.35, 0.35)
    SetTextFontForCurrentCommand(1)
    SetTextColor(255, 255, 255, 215)
    local str = CreateVarString(10, "LITERAL_STRING", text, Citizen.ResultAsLong())
    SetTextCentre(1)
    DisplayText(str,_x,_y)
    local factor = (string.len(text)) / 150
    DrawSprite("generic_textures", "hud_menu_4a", _x, _y+0.0125,0.015+ factor, 0.03, 0.1, 100, 1, 1, 190, 0)
end
