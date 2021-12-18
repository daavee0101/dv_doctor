Config = {}

Config.SharedObject = 'esx:getSharedObject'

Config.EnableLog = true
Config.WebhookImg = "https://i.imgur.com/CyFGInF.png"
Config.Webhook = "webhook"

Config.Locale = "en"

Config.EnableHeal = true -- if you type the command the npc doctor will arrive and heal you when you are not died yet, when you die the doctor will revive you. 
Config.EnableRevive = true
Config.EnableText = true

Config.Key = "E"

Config.DoctorCommand = "doki"
Config.AmbulanceJob = "ambulance"
Config.UsePrice = true
Config.UseMoneyAccount = 'bank' -- 'bank' or 'money' (or 'black_money')

--=[# WORK IN PROGRESS #]=--
-- Config.EnableNPC = false 
-- Config.BlacklistJobs = {'grove', 'vagos'} 
-- Config.PedModel = "s_m_y_blackops_02"
-- Config.PedText = "~b~Doki"
-- Config.ReviveDuration = 50000 -- time in ms
-- Config.HealDuration = 5000 -- time in ms

Config.EnableBilling = true -- if billing enabled, you can get bills when you don't have enought money

Config.SuccessRate = 100 -- if wanna revive all time just set to 100 (exactly not in percentage)

Config.DrawTxtFont = 4

Config.Prices = {
    revive = 1000,
    heal = 500
}

function Notification(msg)
    --- YOUR CODE FOR NOTIFY ---
	ESX.ShowNotification(msg)

    --- FOR EXAMPLE ---
    -- mythic_notify ()
    --exports['mythic_notify']:SendAlert('inform', msg)
end
