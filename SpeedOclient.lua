-- Forza Horizon 4 Speedometer for FiveM
-- Author: Akkariin | Github: https://github.com/kasuganosoras/fh4speed
-- Modified Sources | Github: https://github.com/ProjectFairnessLabs/fh4speedometer
-- If you like this script, please give Akkariin a like on the Fivem forum, thanks

local isHide = false
local isMetric = true  -- Default to KMH (metric) mode
local reload = false
local startreload = false
local RefreshMulti = 1
local rpmlimit = 0.83 
local rpmlimitdata = 7.5 
RegisterCommand("speedometer", function(_, args)
	if args[1] == "unit" then
		isMetric = not isMetric
		local unit = isMetric and "KMH" or "MPH"
		TriggerEvent("chatMessage", "SYSTEM", {255, 0, 0}, "The speedometer has switched to " .. unit .."!")
		TriggerEvent("mosh_notify:notify", "INFO", "<span class=\"text-black\">The speedometer has switched to " .. unit .. "!</span>", "blue", "info", 5000)
	else
		ToggleDisplay()
	end
end, false)

TriggerEvent('chat:addSuggestion', '/speedometer', 'Toggle the speedometer display.', {
    { name="unit", help="Switch speedometer units between KMH and MPH." }
})

RegisterKeyMapping("speedometer", "Enable or disable the speedometer.", "keyboard", "f10")
Citizen.CreateThread(function()
    while true do
        local startCount = GetFrameCount()
        Wait(250)
        local endCount = GetFrameCount()
        local frameNum = (endCount - startCount)*4     
        if frameNum <= Config.MinFramerate then
        	RefreshMulti = (Config.MinFramerate / frameNum)
        else
        	RefreshMulti = 1
        end
    end
end)
Citizen.CreateThread(function()
	while true do
		Wait(Config.RefreshSpeed*RefreshMulti)

		if IsPauseMenuActive() then
				SendNUIMessage({HideHud = true})
				startreload = true
			else
				if startreload then
				reload = true	
				startreload = false
			else
				reload = false
			end
		end

		playerPed = GetPlayerPed(-1)
		ResetHudComponentValues(6)
		ResetHudComponentValues(7)
		ResetHudComponentValues(9)
		
		if playerPed and IsPedInAnyVehicle(playerPed) and not isHide then
			
			playerCar = GetVehiclePedIsIn(playerPed, false)
			
			if playerCar and GetPedInVehicleSeat(playerCar, -1) == playerPed then
				local NcarRPM                      = GetVehicleCurrentRpm(playerCar)
				local NcarSpeed                    = GetEntitySpeed(playerCar)
				local NcarGear                     = GetVehicleCurrentGear(playerCar)
				local NcarIL                       = GetVehicleIndicatorLights(playerCar)
				local NcarAcceleration             = IsControlPressed(0, 71)
				local NcarHandbrake                = GetVehicleHandbrake(playerCar)
				local NcarBrakeABS                 = (GetVehicleWheelSpeed(playerCar, 0) <= 0.0) and (NcarSpeed > 0.0)
				local NcarLS_r, NcarLS_o, NcarLS_h = GetVehicleLightsState(playerCar)
				-- Move the damn HUD so it doesn't intefere with the speedo when it is active. Took me a while to get a hold of this.
				SetHudComponentPosition(6, -0.14, -0.06)
				SetHudComponentPosition(7, -0.14, -0.022)
				SetHudComponentPosition(9, -0.14, 0.0154)
				
				local shouldUpdate = false
				
				if NcarRPM ~= carRPM or NcarSpeed ~= carSpeed or NcarGear ~= carGear or NcarIL ~= carIL or NcarAcceleration ~= carAcceleration 
					or NcarHandbrake ~= carHandbrake or NcarBrakeABS ~= carBrakeABS or NcarLS_r ~= carLS_r or NcarLS_o ~= carLS_o or NcarLS_h ~= carLS_h then
					shouldUpdate = true
				end
				if shouldUpdate or reload then
					carRPM          = NcarRPM
					carGear         = NcarGear
					carSpeed        = NcarSpeed
					carIL           = NcarIL
					carAcceleration = NcarAcceleration
					carHandbrake    = NcarHandbrake
					carBrakeABS     = NcarBrakeABS
					carLS_r         = NcarLS_r
					carLS_o         = NcarLS_o
					carLS_h         = NcarLS_h

					local speedUnit = isMetric and "KMH" or "MPH"
					hash = GetEntityModel(playerCar)
					if Config.vehicleRPM[hash] then
						customrpm = Config.vehicleRPM[hash][1]
						rpmlimit = Config.vehicleRPM[hash][2]
						rpmlimitdata = ((0.75/0.83)*(Config.vehicleRPM[hash][2]+0.00))*10
						scalerpm = (1/(1-Config.vehicleRPM[hash][3]))
						carRPM = (carRPM-Config.vehicleRPM[hash][3])*scalerpm
					else
						customrpm = nil
						rpmlimit = 0.83
						rpmlimitdata = 7.5
						scalerpm = (1/(1-0))
						carRPM = (carRPM-0)*scalerpm
					end
					if GetEntitySpeed(playerCar) < 0.05 and not IsVehicleInBurnout(playerCar)  then
						carGear = "N"
					end
	
					if not IsPauseMenuActive() then
					SendNUIMessage({
						ShowHud                = true,
						CurrentCarRPM          = carRPM,
						CurrentCarGear         = carGear,
						CurrentCarSpeed        = carSpeed,
						CurrentCarKmh          = math.ceil(carSpeed * 3.6),
						CurrentCarMph          = math.ceil(carSpeed * 2.236936),
						CurrentCarIL           = carIL,
						CurrentCarAcceleration = carAcceleration,
						CurrentCarHandbrake    = carHandbrake,
						CurrentCarABS          = GetVehicleWheelBrakePressure(playerCar, 0) > 0 and not carBrakeABS,
						CurrentCarLS_r         = carLS_r,
						CurrentCarLS_o         = carLS_o,
						CurrentCarLS_h         = carLS_h,
						PlayerID               = GetPlayerServerId(GetPlayerIndex()),
						Unit                   = speedUnit,  -- New line to send speed unit to the HUD
						CarClass			   = GetVehicleClass(playerCar),
						CustomRPM 			   = customrpm,
						RPMLimit			   = rpmlimit,
						RPMLimitData		   = rpmlimitdata
					})
					end
					
				else
					Wait(100)
				end
			else
				SendNUIMessage({HideHud = true})
			end
		else
			SendNUIMessage({HideHud = true})
			Wait(100)
		end
	end
end)

function ToggleDisplay()
	if isHide then
		isHide = false
	else
		SendNUIMessage({HideHud = true})
		isHide = true
	end
end
