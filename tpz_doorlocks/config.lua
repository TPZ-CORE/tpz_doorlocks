Config = {}

Config.DevMode = true

--[[-------------------------------------------------------
 General
]]---------------------------------------------------------

-- The following key is locking / unlocking a door when pressing close to the door distance.
Config.DoorKey = 0xC7B5340A

-- The following rendering checks for near locked states / doors.
Config.RenderDoorStateDistance = 30

-- Door Lockpicking is working ONLY for TPZ Properties (If a property has lockpicking enabled).
Config.Lockpicking = {
    Item     = "hardlockpick",
    Stages   = 3, -- (3) By Default, all Lockpicking stages must be successfull to unlock the property door.
	
    RequiredOnlineJob = { Job = "police", Minimum = 5, Notify = true },

    -- TPZ Notify Support.
    -- Includes Property Owner (If online) by default (Not only RequiredOnlineJob).
    NotifyMessage = { 
        title          = "Property Alert", 
        message        = "A property of yours is getting robbed, checkout the map for the location.", -- property owner
        message_target = "A property is getting robbed, checkout the map for the location.", -- required jobs if notify is true.
        icon           = "alert",
        duration       = 10,
    },
}

--[[-------------------------------------------------------
 Door Locations
]]---------------------------------------------------------

Config.DoorsList = {

	-- Valentine Keanes Saloon

    [1] = {
		authorizedJobs = { 'keanessaloon' },

        doors = { 

            [1] = { 
                objCoords = vector3(-243.7268371582,765.04418945313,117.14251708984), 
                objYaw = 110.27790069580078
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-243.7268371582,765.04418945313,117.14251708984),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    [2] = {
		authorizedJobs = { 'keanessaloon' },

        doors = { 

            [1] = { 
                objCoords = vector3(-238.96888732910156, 774.2294311523438, 117.1474838256836), 
                objYaw = -69.99999237060547
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-238.96888732910156, 774.2294311523438, 117.1474838256836),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    -- Valentine Sheriffs

    [3] = { -- FRONT DOOR
		authorizedJobs = { 'police' },

        doors = { 

            [1] = { 
                objCoords = vector3(-276.0126037597656, 802.591064453125, 118.41165161132812), 
                objYaw = 9.9999713897705
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-276.0126037597656, 802.591064453125, 118.41165161132812),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    [4] = { -- BACK DOOR
		authorizedJobs = { 'police' },

        doors = { 

            [1] = { 
                objCoords = vector3(-275.8447570800781, 812.0270385742188, 118.41483306884766), 
                objYaw = -169.99996948242188
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-275.8447570800781, 812.0270385742188, 118.41483306884766),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    
    [5] = { -- SIDE DOOR (JAIL DOOR)
		authorizedJobs = { 'police' },

        doors = { 

            [1] = { 
                objCoords = vector3(-270.76641845703125, 810.0264892578125, 118.39580535888672), 
                objYaw = -80.00006866455078
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-270.76641845703125, 810.0264892578125, 118.39580535888672),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    [6] = { -- INSIDE MAIN JAIL DOOR
		authorizedJobs = { 'police' },

        doors = { 

            [1] = { 
                objCoords = vector3(-275.0230407714844, 809.2737426757812, 118.36856842041016), 
                objYaw = -79.88455200195312
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-275.0230407714844, 809.2737426757812, 118.36856842041016),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    
    [7] = { -- INSIDE MAIN LEFT PRISON JAIL DOOR
		authorizedJobs = { 'police' },

        doors = { 

            [1] = { 
                objCoords = vector3(-273.4643249511719, 809.966064453125, 118.36823272705078), 
                objYaw = 9.99997043609619
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-273.4643249511719, 809.966064453125, 118.36823272705078),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},
	
    [8] = { -- INSIDE MAIN LEFT PRISON JAIL DOOR
		authorizedJobs = { 'police' },

        doors = { 

            [1] = { 
                objCoords = vector3(-272.0520935058594, 808.25830078125, 118.36851501464844), 
                objYaw = -169.99996948242188
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-272.0520935058594, 808.25830078125, 118.36851501464844),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    -- Valentine Medical

    [9] = { -- MEDICS FRONT DOOR
		authorizedJobs = { 'medic' },

        doors = { 

            [1] = { 
                objCoords = vector3(-290.85858154296875, 813.3573608398438, 118.41548156738281), 
                objYaw = 9.9999713897705
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-290.85858154296875, 813.3573608398438, 118.41548156738281),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    [10] = { -- MEDICS BACK DOOR
		authorizedJobs = { 'medic' },

        doors = { 

            [1] = { 
                objCoords = vector3(-281.0745544433594, 815.237548828125, 118.4158935546875), 
                objYaw = 99.99993133544922
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-281.0745544433594, 815.237548828125, 118.4158935546875),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    -- Valentine Gun Smiths

    [11] = { -- FRONT DOOR
		authorizedJobs = { 'valgunsmith' },

        doors = { 

            [1] = { 
                objCoords = vector3(-283.5354919433594, 784.4078369140625, 118.52978515625), 
                objYaw = -0.06996513158082
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-283.5354919433594, 784.4078369140625, 118.52978515625),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},

    [12] = { -- BACK DOOR
		authorizedJobs = { 'valgunsmith' },

        doors = { 

            [1] = { 
                objCoords = vector3(-276.65576171875, 776.6043090820312, 118.5455551147461), 
                objYaw = 179.99998474121094
            },

            [2] = false, -- SET TO FALSE IF THERE IS NO SECOND DOOR.
        },

		textCoords  = vector3(-276.65576171875, 776.6043090820312, 118.5455551147461),
		locked = true,
		distance = 2.0,

        canBreakIn = false, -- If players can use lockpicking to unlock the door.
	},
}
