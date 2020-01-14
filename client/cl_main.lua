local myHorse = {0, 0, 0, 0}
local playerPed = PlayerPedId()

RegisterCommand('spawnhorse', function(source, args, rawCommand)

	checkHorse()
    
end)

RegisterCommand('flee', function(source, args, rawCommand)

	fleeHorse()
    
end)

RegisterCommand('dh', function(source, args, rawCommand)

	delHorse()
    
end)

RegisterCommand('behorse', function(source, args, rawCommand)

	RequestModel(-1963397600)
    
	Citizen.CreateThread(function()
        local waiting = 0
        while not HasModelLoaded(-1963397600) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                print("Could not load ped")
                break
            end
        end
            SetPlayerModel(playerPed, -1963397600)
			Citizen.InvokeNative(0x283978A15512B2FE, playerPed)
			
			SetModelAsNoLongerNeeded(-1963397600)
    end)
    
end)

RegisterCommand('reghorse', function(source, args, rawCommand)
	local isMounted = IsPedOnMount(playerPed)
	local isOwned = IsEntityAMissionEntity(GetMount(playerPed))
	print(isOwned)
	if args[1] ~= nil and isMounted then
		if not isOwned then
			newVeh('horse', args[1])
		else
			TriggerEvent("redemrp_notification:start", "Horse is owned by someone!" , 3, "error")
		end
	elseif isMounted then
		if not isOwned then
			newVeh('horse')
		else
			TriggerEvent("redemrp_notification:start", "Horse is owned by someone!" , 3, "error")
		end
	else
		TriggerEvent("redemrp_notification:start", "You must be mounted on a horse!" , 3, "warning")
		print('Not mounted!')
	end
    
end)

RegisterCommand('defaulthorse', function(source, args, rawCommand)

	defHorse(args[1])
    
end)

RegisterNetEvent('z00thorses:spawnHorse')
AddEventHandler('z00thorses:spawnHorse', function(horseData, horseName, id)
  myHorse[1] = tonumber(horseData)
  myHorse[2] = id
  myHorse[3] = horseName
  print("Model: ", myHorse[1], " DB ID: ", myHorse[2])
  if myHorse[1] ~= 0 then
	local x,y,z = table.unpack(GetOffsetFromEntityInWorldCoords(playerPed, 0.0, -40.0, 0.0))
	local gChk, groundZ = nil, nil
	
	for height = 1, 1000 do
            gChk, groundZ = GetGroundZAndNormalFor_3dCoord(x, y, height+0.0)
				if gChk then
					print('FOUND GROUND!: ' .. groundZ)
					break
				end

            --[[local foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords["x"], waypointCoords["y"], height + 0.0)

            if foundGround then
                SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords["x"], waypointCoords["y"], height + 0.0)

                break
            end

            Citizen.Wait(5)--]]
    end

	RequestModel(myHorse[1])
    
	Citizen.CreateThread(function()
        local waiting = 0
        while not HasModelLoaded(myHorse[1]) do
            waiting = waiting + 100
            Citizen.Wait(100)
            if waiting > 5000 then
                print("Could not load ped")
                break
            end
        end
            myHorse[4] = CreatePed(myHorse[1], x, y, groundZ+2, GetEntityHeading(playerPed), 1, 0)
			Citizen.InvokeNative(0x6A071245EB0D1882, myHorse[4], playerPed, -1, 7.2, 2.0, 0, 0)
			Citizen.InvokeNative(0x283978A15512B2FE, myHorse[4], true)
			--Citizen.InvokeNative(0x58A850EAEE20FAA3, myHorse[4])
			Citizen.InvokeNative(0x23f74c2fda6e7c61, -1230993421, myHorse[4])
			SetPedNameDebug(myHorse[4], myHorse[3])
			SetPedPromptName(myHorse[4], myHorse[3])
			
			SetModelAsNoLongerNeeded(myHorse[4])
    end)
  end
end)

function checkHorse(source, args, rawCommand)
	local isMounted = IsPedOnMount(playerPed)
	playerPed = PlayerPedId() --Updating when needed?
	if myHorse[4] ~= 0 then
		if not isMounted then
			Citizen.InvokeNative(0x6A071245EB0D1882, myHorse[4], playerPed, -1, 7.2, 2.0, 0, 0)
		end
	else
		TriggerServerEvent("z00thorses:getHorse")
	end
end

function fleeHorse(source, args, rawCommand)

	if myHorse[4] ~= 0 then
		DeletePed(myHorse[4])
		TriggerServerEvent("z00thorses:stableHorse", myHorse[2])
		myHorse[4] = 0
	end
    
end

function newVeh(vehType, id)
	print(vehType, id)
	local currentHorse = GetEntityModel(GetMount(playerPed))
	local inPut1 = ""
	local inPut2 = ""
	Citizen.CreateThread(function()
		AddTextEntry("FMMC_MPM_TYP8", "Name your horse:")
		DisplayOnscreenKeyboard(1, "FMMC_MPM_TYP8", "", "Name", "", "", "", 30)
		while (UpdateOnscreenKeyboard() == 0) do
			DisableAllControlActions(0);
			Citizen.Wait(0);
		end
		if (GetOnscreenKeyboardResult()) then
			inPut1 = GetOnscreenKeyboardResult()
			print('Horse Hash?', currentHorse, inPut1)
			TriggerServerEvent('z00thorses:newVehicle', currentHorse, vehType, inPut1, id)
		end
	
	end)
end

RegisterNetEvent('z00thorses:delMount')
AddEventHandler('z00thorses:delMount', function()
	
	local currentHorse = IsEntityAMissionEntity(GetMount(playerPed))
	print(currentHorse)
	if not currentHorse then
		local horsePed = GetEntityModel(GetMount(playerPed))
		DeletePed(horsePed)
	end

end)
	

function delHorse(source, args, rawCommand)

	if myHorse[4] ~= 0 then
		DeletePed(myHorse[4])
		TriggerServerEvent("z00thorses:stableHorse", myHorse[2])
		myHorse[4] = 0
	end
    
end

function defHorse(name)

	TriggerServerEvent("z00thorses:defVeh", name)
	
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        --DisableControlAction(0,0x24978A28,true)
        if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x24978A28) then -- Control =  H
			checkHorse()
			Citizen.Wait(10000) --Flood Protection?
        end
		
		if Citizen.InvokeNative(0x91AEF906BCA88877, 0, 0x4216AF06) then -- Control = Horse Flee
			local horseCheck = Citizen.InvokeNative(0x7912F7FC4F6264B6, playerPed, myHorse[4])
			if horseCheck then
				fleeHorse()
			end
		end			
		
    end
end)
