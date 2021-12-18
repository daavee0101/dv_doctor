local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	['tab'] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent(Config.SharedObject, function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

	TriggerServerEvent('dv_doctor:countEms')
end)

local emsCount = 0

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	while ESX == nil do Wait(0) end
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
	TriggerServerEvent('dv_doctor:countEms')
end)

RegisterNetEvent('dv_doctor:noCash')
AddEventHandler('dv_doctor:noCash', function(type)
	if type == 'bank' then 
		Notification(_U('not_enough_money') " ($" ..Config.Prices.revive.. " - BANK")
	else
		Notification(_U('not_enough_money') "($" ..Config.Prices.revive.. " - CASH")
	end
end)

RegisterNetEvent('dv_doctor:fail')
AddEventHandler('dv_doctor:fail', function()
	Notification(_U('revive_fail'))
end)

RegisterNetEvent('dv_doctor:heal')
AddEventHandler('dv_doctor:heal', function()
	local ped = PlayerPedId()
	SetEntityHealth(ped, GetEntityMaxHealth(ped))
end)

AddEventHandler('esx:onPlayerDeath', function(data)
	IsDead = true
	showTxt = true
	inProgress = false
end)

AddEventHandler('playerSpawned', function(spawn)
    IsDead = false
	showTxt = false
	inProgress = false
end)

RegisterNetEvent('dv_doctor:setEms')
AddEventHandler('dv_doctor:setEms', function(count1)
	emsCount = count1
end)

Citizen.CreateThread(function()
     while true do
        Citizen.Wait(0)
		if IsDead then
			if Config.EnableText then
				if showTxt then 
					drawOn(1.235, 1.542, 1.0,1.0,0.40, "~w~["..Config.Key.."] " .. _U('call_npc'), 255, 255, 255, 255)
				end
			end
			if Config.EnableRevive or Config.EnableHeal then 
				if IsControlJustPressed(0, Keys[Config.Key]) then
					TriggerServerEvent('dv_doctor:countEms')
					if emsCount <= 0 then  
						showTxt = false
						startDoki()
						inProgress = true
					else
						showTxt = true
						Notification(_U('online_ems'))
					end
				end
			end
		end
 	end
end)

RegisterCommand(Config.DoctorCommand, function() 
	if Config.EnableRevive or Config.EnableHeal then 
		TriggerServerEvent('dv_doctor:countEms')
		if emsCount <= 0 then  
			showTxt = false
			startDoki()
			inProgress = true
		else
			showTxt = true
			Notification(_U('online_ems'))
		end
	end
end)

function startDoki()
	local playerped = PlayerPedId()
	if IsDead then
		if Config.EnableRevive then 
			TriggerServerEvent('dv_doctor:startDoki', "reviving")
		end
		if Config.EnableHeal and not Config.EnableRevive then 
			Notification(_U('cant_use'))
		end
	else
		if not IsDead and GetEntityHealth(playerped) > 0 then 
			if Config.EnableHeal then 
				TriggerServerEvent('dv_doctor:startDoki', "healing")
			end
			if Config.EnableRevive and not Config.EnableHeal then 
				Notification(_U('cant_use'))
			end
		else
			Notification(_U('no_damage'))
		end
	end
end

function drawOn(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(Config.DrawTxtFont)
    SetTextProportional(0)
    SetTextScale(scale, scale)
	SetTextColour( 0,0,0, 255 )
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(0, 0, 0, 0, 255)
    SetTextDropShadow()
	SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/1.255, y - height/1 + 0.374)
end

RegisterNetEvent('dv_doctor:sendBill')
AddEventHandler('dv_doctor:sendBill', function(type)
	TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(PlayerId()), 'society_ambulance', _U('npc_bill') .. type .. ' - ', Config.Prices.heal)
end)