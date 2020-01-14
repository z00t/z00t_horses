RegisterServerEvent('z00thorses:getHorse')
AddEventHandler('z00thorses:getHorse', function()
local _source = source
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		local identifier = user.getIdentifier()
		local charid = user.getSessionVar("charid")
			--print(identifier)
			
		MySQL.Async.fetchAll('SELECT * FROM stables WHERE `identifier`=@identifier AND `charid`=@charid AND `type`=@horses AND `default`=1;', {identifier = identifier, charid = charid, horses = 'horse'}, function(horses)
		
		if horses[1] ~= nil then
			print("Horse:", horses[1].id, "Name: ", horses[1].name)
			local name = horses[1].name
			local id = horses[1].id
			if horses[1].stabled then
				horse = horses[1].vehicles
			else
				horse = 0
			end
			TriggerClientEvent("z00thorses:spawnHorse", _source, horse, name, id)
		end
		end)
		
		MySQL.Async.execute("UPDATE stables SET `stabled`=0 WHERE `identifier`=@identifier AND `charid`=@charid AND `type`=@horses AND `default`=1", {identifier = identifier, charid = charid, horses = 'horse'}, function(done)
		end)
	end)
end)

RegisterServerEvent('z00thorses:stableHorse')
AddEventHandler('z00thorses:stableHorse', function(id)
local _source = source
local _id = id
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		local identifier = user.getIdentifier()
		local charid = user.getSessionVar("charid")
			--print(identifier)
			
		MySQL.Async.execute("UPDATE stables SET `stabled`=1 WHERE id=@id", {id = _id}, function(rowsChanged)
		if rowsChanged == 0 then
			TriggerClientEvent("redemrp_notification:start", _source, "ERROR: Horse not stabled!", 3, "error")
		else
			TriggerClientEvent("redemrp_notification:start", _source, "Horse stabled!", 3, "success")
		end
		end)
		print("Horse ", _id, " stabled!")
		
	end)
end)

RegisterServerEvent('z00thorses:newVehicle')
AddEventHandler('z00thorses:newVehicle', function(vehHash, vehType, vehName, id)
local _source = source
local _vehHash = vehHash
local _type = vehType
local _vehName = vehName
local _id = id

  if _id ~= nil then
	_source = tonumber(_id)
	print(source, 'saving vehicle for', _source, '...')
  end	
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		local identifier = user.getIdentifier()
		local charid = user.getSessionVar("charid")
			--print(identifier)
		
		MySQL.Async.fetchAll('SELECT * FROM stables WHERE `identifier`=@identifier AND `charid`=@charid;', {identifier = identifier, charid = charid}, function(horses)
		local count = 0
		local nChk = false
		print('Init:', nChk)
		for _ in pairs(horses) do count = count + 1 end
		if count < Config.StableSlots then
		 if horses[1] == nil then
			nChk = true
		 else
		  for i = 1, #horses do 
			if _vehName == horses[i].name then
				nChk = false
				print('Post', _vehName, horses[i].name, nChk)
				break
			else
				nChk = true
				print('Post', _vehName, horses[i].name, nChk)
			end
		  end
		 end
		  if nChk then		
			MySQL.Async.execute('INSERT INTO stables (`identifier`, `charid`, `vehicles`, `name`, `type`) VALUES (@identifier, @charid, @vehicles, @name, @kind);',
			{
				identifier = identifier,
				charid = charid,
				vehicles = _vehHash,
				name = _vehName,
				kind = _type
			}, function(rowsChanged)
			end)
			print("Vehicle", _vehName, "registered!")
			TriggerClientEvent("redemrp_notification:start", _source, _type .. " " .. _vehName .. " Registered!", 3, "success")
			TriggerClientEvent("z00thorses:delMount", _source)
		  else
			print("Name already in use!")
			TriggerClientEvent("redemrp_notification:start", _source, "Name already in use!", 3, "error")
		  end
		else
			print(_source, "Stable slot limit reached!")
			TriggerClientEvent("redemrp_notification:start", _source, "Stable slot limit reached!", 3, "error")
		end
		
		end)
	end) 
end)

RegisterServerEvent('z00thorses:defVeh')
AddEventHandler('z00thorses:defVeh', function(name)
	local _source = source
	local _name = name
	TriggerEvent('redemrp:getPlayerFromId', _source, function(user)
		local identifier = user.getIdentifier()
		local charid = user.getSessionVar("charid")
			--print(identifier)

		MySQL.Async.execute("UPDATE stables SET `default`=0 WHERE `identifier`=@identifier AND `charid`=@charid AND `type`=@horses AND `default`=1", {identifier = identifier, charid = charid, horses = 'horse'}, function(done)
		end)
			
		MySQL.Async.execute("UPDATE stables SET `default`=1 WHERE `identifier`=@identifier AND `charid`=@charid AND `name`=@name AND `type`=@horses", {identifier = identifier, charid = charid, name = _name, horses = 'horse'}, function(rowsChanged)
		if rowsChanged == 0 then
			TriggerClientEvent("redemrp_notification:start", _source, "Setting default horse failed!", 3, "error")
		else
			TriggerClientEvent("redemrp_notification:start", _source, _name .. " set to default!", 3, "error")
		end
		end)
		print(_source, "set vehicle", name, "as a default!")
	end)
end)