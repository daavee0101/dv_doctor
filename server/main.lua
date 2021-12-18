ESX = nil

TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)

local Webhook = Config.Webhook
local Profile = Config.WebhookImg

RegisterServerEvent('dv_doctor:countEms')
AddEventHandler('dv_doctor:countEms', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayers = ESX.GetPlayers()
    local ems = 0

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		if xPlayer.job.name == Config.AmbulanceJob then
			ems = ems + 1
		end
	end

	TriggerClientEvent('dv_doctor:setEms', source, ems)
end)

RegisterServerEvent('dv_doctor:startDoki')
AddEventHandler('dv_doctor:startDoki', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)
	if type == "reviving" then
		if Config.UsePrice then 
			if xPlayer.getAccount(Config.UseMoneyAccount).money >= Config.Prices.revive then
				TriggerEvent('dv_doctor:revive', source)
				if Config.EnableLog then
					if Config.Webhook ~= "webhook" or Config.Webhook ~= nil then 
						PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Doctor System', avatar_url = Profile, content = '```css\n['..GetCurrentResourceName()..']\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Revived by NPC medic for $'..Config.Prices.revive..'! [Type: '..type..']```'}), { ['Content-Type'] = 'application/json' })
					else
						print('Webhook not found!')
					end
				end
				xPlayer.removeAccountMoney(Config.UseMoneyAccount, Config.Prices.revive)
			else
				if Config.EnableBilling then 
					TriggerClientEvent('dv_doctor:sendBill', source, "reviving")
					TriggerEvent('dv_doctor:revive', source)
					if Config.EnableLog then
						if Config.Webhook ~= "webhook" or Config.Webhook ~= nil then 
							PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Doctor System', avatar_url = Profile, content = '```css\n['..GetCurrentResourceName()..']\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Revived by NPC medic for $'..Config.Prices.heal..'! + Bill received [Type: '..type..']```'}), { ['Content-Type'] = 'application/json' })
						else
							print('Webhook not found!')
						end
					end
				else
					TriggerClientEvent('dv_doctor:noCash', source, Config.UseMoneyAccount)
				end
			end
		else 
			TriggerEvent('dv_doctor:revive', source)
			if Config.EnableLog then
				if Config.Webhook ~= "webhook" or Config.Webhook ~= nil then 
					PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Doctor System', avatar_url = Profile, content = '```css\n['..GetCurrentResourceName()..']\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Revived by NPC medic! [Type: '..type..']```'}), { ['Content-Type'] = 'application/json' })
				else
					print('Webhook not found!')
				end
			end
		end
	end
	if type == "healing" then 
		if Config.UsePrice then 
			if xPlayer.getAccount(Config.UseMoneyAccount).money >= Config.Prices.heal then
				TriggerClientEvent('dv_doctor:heal', source)
				if Config.EnableLog then
					if Config.Webhook ~= "webhook" or Config.Webhook ~= nil then 
						PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Doctor System', avatar_url = Profile, content = '```css\n['..GetCurrentResourceName()..']\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Healed by NPC medic for $'..Config.Prices.heal..'! [Type: '..type..']```'}), { ['Content-Type'] = 'application/json' })
					else
						print('Webhook not found!')
					end
				end
				xPlayer.removeAccountMoney(Config.UseMoneyAccount, Config.Prices.heal)
			else 
				if Config.EnableBilling then 
					TriggerClientEvent('dv_doctor:sendBill', source, "healing")
					TriggerClientEvent('dv_doctor:heal', source)
					if Config.EnableLog then
						if Config.Webhook ~= "webhook" or Config.Webhook ~= nil then 
							PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Doctor System', avatar_url = Profile, content = '```css\n['..GetCurrentResourceName()..']\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Healed by NPC medic for $'..Config.Prices.heal..'! + Bill received [Type: '..type..']```'}), { ['Content-Type'] = 'application/json' })
						else
							print('Webhook not found!')
						end
					end
				else
					TriggerClientEvent('dv_doctor:noCash', source, Config.UseMoneyAccount)
				end
			end
		else 
			TriggerClientEvent('dv_doctor:heal', source)
			if Config.EnableLog then
				if Config.Webhook ~= "webhook" or Config.Webhook ~= nil then 
					PerformHttpRequest(Webhook, function(Error, Content, Head) end, 'POST', json.encode({username = 'Doctor System', avatar_url = Profile, content = '```css\n['..GetCurrentResourceName()..']\n``````ini\n[ID: ' .. source .. '] | [Name: ' .. xPlayer.name .. '] - Healed by NPC medic! [Type: '..type..']```'}), { ['Content-Type'] = 'application/json' })
				else
					print('Webhook not found!')
				end
			end
		end
	end
end)

RegisterServerEvent('dv_doctor:revive')
AddEventHandler('dv_doctor:revive', function(source)
	local ertek = math.random(1,100)
	if Config.SuccessRate ~= 100 then
		if Config.SuccessRate > ertek then 
			TriggerClientEvent('esx_ambulancejob:revive', source)
		else
			TriggerClientEvent('dv_doctor:fail', source)
		end
	else
		TriggerClientEvent('esx_ambulancejob:revive', source)
	end
end)