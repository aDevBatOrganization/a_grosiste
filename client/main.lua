local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
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
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
end)

local NPC = {
    {seller = true, model = "a_m_y_smartcaspat_01", x = 63.45,  y = -1729.04,  z = 28.64, h = 48.41},
}

Citizen.CreateThread(function()
    while ESX == nil do
	TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
	Citizen.Wait(0)
    end
    for _, v in pairs(NPC) do
        RequestModel(GetHashKey(v.model))
        while not HasModelLoaded(GetHashKey(v.model)) do
            Wait(1)
        end
        local npc = CreatePed(4, v.model, v.x, v.y, v.z, v.h,  false, true)
        SetPedFleeAttributes(npc, 0, 0)
        SetPedDropsWeaponsWhenDead(npc, false)
        SetPedDiesWhenInjured(npc, false)
        SetEntityInvincible(npc , true)
        FreezeEntityPosition(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        if v.seller then 
            RequestAnimDict("missfbi_s4mop")
            while not HasAnimDictLoaded("missfbi_s4mop") do
                Wait(1)
            end
            TaskPlayAnim(npc, "missfbi_s4mop" ,"guard_idle_a" ,8.0, 1, -1, 49, 0, false, false, false)
        else
            GiveWeaponToPed(npc, GetHashKey("WEAPON_ADVANCEDRIFLE"), 2800, true, true)
        end
    end
end)

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Grosiste Entreprise","Achetez en gros", nil, nil)
_menuPool:Add(mainMenu)

function AddShopsMenu(menu)
    local shopsmenu = _menuPool:AddSubMenu(menu, "Objets en Gros", nil, nil)
    
    local water = NativeUI.CreateItem("Pack d'eau part 50", "")
    shopsmenu.SubMenu:AddItem(water)
    water:RightLabel("~g~500$")
    
    local levure = NativeUI.CreateItem("50 sachet de levures", "")
    shopsmenu.SubMenu:AddItem(levure)
    levure:RightLabel("~g~850$")

    local barquette = NativeUI.CreateItem("100 barquette en plastique vide", "")
    shopsmenu.SubMenu:AddItem(barquette)
    barquette:RightLabel("~g~200$")


    shopsmenu.SubMenu.OnItemSelect = function(menu, item)
    if item == water then
        TriggerServerEvent('buyWater')
        ESX.ShowNotification('Vous avez payez ~g~500$')
        Citizen.Wait(1)
    elseif item == levure then
        TriggerServerEvent('buyLevure')
        ESX.ShowNotification('Vous avez payez ~g~150$')
        Citizen.Wait(1)
    elseif item == barquette then
        TriggerServerEvent('buyBarquette')
        ESX.ShowNotification('Vous avez payez ~g~200$')
        Citizen.Wait(1)
        end
    end  

end

AddShopsMenu(mainMenu)
_menuPool:RefreshIndex()

local shopi = {
    {x = 63.45,  y = -1729.04,  z = 29.64}
}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        _menuPool:MouseEdgeEnabled (false);

        for k in pairs(shopi) do

            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, shopi[k].x, shopi[k].y, shopi[k].z)

            if dist <= 1.2 then
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_TALK~ pour parler au ~r~Vendeur")
				if IsControlJustPressed(1,51) then 
                    mainMenu:Visible(not mainMenu:Visible())
				end
            end
        end
    end
end)

-- blips --

local blips = {
    {title="Grosiste", colour=17, id=52, x = 63.45,  y = -1729.04,  z = 29.64},

}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.9)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)
    end
end)


