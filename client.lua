ESX = exports.es_extended:getSharedObject()

local seduto = false

RegisterCommand("heal", function()
    TriggerEvent('esx_basicneeds:healPlayer')
    ESX.ShowNotification("Ti sei curato con successo!")
end)

RegisterCommand('sitcar', function()
    local ped = PlayerPedId()
    local vehicle   = ESX.Game.GetClosestVehicle(GetEntityCoords(ped))
    local vehCoords, pCoords = GetEntityCoords(vehicle), GetEntityCoords(ped)
    if #(coords - punto) < 3.0 then
        if not seduto then
            TaskEnterVehicle(ped, vehicle, 2000, 1, 1.0, 1, 0)
            Citizen.Wait(2000)
            TaskLeaveVehicle(ped, vehicle, 16)
            Citizen.Wait(5)
            seduto = true
            AttachEntityToEntity(ped, vehicle, -1, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            ExecuteCommand('e sit5')
            ESX.ShowNotification("Sei entrato nel veicolo")
        else
            seduto = false
            DetachEntity(ped)
            ExecuteCommand('e c')
            ESX.ShowNotification("Sei uscito dal veicolo")
        end
    else
        ESX.ShowNotification("Non ci sono veicoli nelle vicinanze")
    end
end)

RegisterCommand("fix",function(source)
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        local auto = GetVehiclePedIsIn(PlayerPedId(), false)

        exports['progressBars']:startUI(4000, "Riparando Auto")
        Citizen.Wait(4000)
        SetVehicleFixed(auto)
        SetVehicleDirtLevel(auto, 0.0)
    else
        ESX.ShowNotification("Devi essere in un veicolo per poterlo riparare!")
    end
end)

RegisterCommand("id",function()
    ESX.ShowNotification("Il tuo id è ".. GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())))
end)

RegisterCommand("giubbo", function()
	SetPedArmour(PlayerPedId(), 100)
    ESX.ShowNotification("Ti messo l'armatura!")
end)

RegisterCommand("ammo", function()
	local player = PlayerPedId()
    local calcio, arma = GetCurrentPedWeapon(player, 1)
    local calcio, colpi = GetMaxAmmo(player, arma)

    if IsPedArmed(player, 4) then 
        SetPedAmmo(player, arma, 250)
        ESX.ShowNotification("Hai ricaricato "..colpi.." nella tua arma!")
    else
        ESX.ShowNotification("Non hai un'arma in mano!")
    end
end)

RegisterCommand("giorno", function()
    NetworkOverrideClockTime(12, 00, 00)
    ESX.ShowNotification("Hai impostato il meteo di giorno!")
end)

RegisterCommand("pomeriggio", function()
    NetworkOverrideClockTime(18, 00, 00)
    ESX.ShowNotification("Hai impostato il meteo di pomeriggio!")
end)

RegisterCommand("notte", function()
    NetworkOverrideClockTime(00, 00, 00)
    ESX.ShowNotification("Hai impostato il meteo di notte!")
end)

announcestring = false
lastfor = 5

RegisterNetEvent('announce')
announcestring = false
AddEventHandler('announce', function(msg)

	announcestring = msg
	PlaySoundFrontend(-1, "DELETE","HUD_DEATHMATCH_SOUNDSET", 1)
	Citizen.Wait(lastfor * 2000)
	announcestring = false
end)

function Initialize(scaleform)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(5)
    end
    PushScaleformMovieFunction(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
	PushScaleformMovieFunctionParameterString("~y~Annuncio")
    PushScaleformMovieFunctionParameterString(announcestring)
    PopScaleformMovieFunctionVoid()
    return scaleform
end


Citizen.CreateThread(function()
    local sleep = 250
while true do
    if announcestring then
		scaleform = Initialize("mp_big_message_freemode")
        sleep = 0
		DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
    end
    Wait(sleep)
end
end)



RegisterCommand('moto', function()
    TriggerEvent('esx:spawnVehicle', 'bf400')
    end)
    

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/id', 'Per sapere il tuo id!',{})
	TriggerEvent('chat:addSuggestion', '/fix', 'Per ripare il veicolo!',{})
	TriggerEvent('chat:addSuggestion', '/heal', 'Per curarti!',{})
    TriggerEvent('chat:addSuggestion', '/sitcar', 'Per sederti su un veicolo!',{})
    TriggerEvent('chat:addSuggestion', '/giubbo', 'Per il giubbotto antiproiettile!',{})
    TriggerEvent('chat:addSuggestion', '/ammo', 'Per ricaricare i colpi!',{})
    TriggerEvent('chat:addSuggestion', '/giorno', 'Per impostare il meteo di giorno!',{})
	TriggerEvent('chat:addSuggestion', '/pomeriggio', 'Per impostare il meteo di pomeriggio!',{})
	TriggerEvent('chat:addSuggestion', '/notte', 'Per impostare il meteo di notte!',{})
    TriggerEvent('chat:addSuggestion', '/announce', 'Per fare un\'annuncio!',{})
    TriggerEvent('chat:addSuggestion', '/moto', 'Per spawnare una moto!',{})
end)

