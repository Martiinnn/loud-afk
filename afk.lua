RegisterNetEvent("loud:afk")
AddEventHandler("loud:afk", function()
    local playerCoords = GetEntityCoords(PlayerPedId())

    local input = lib.inputDialog('¿Por qué y por cuanto te vas afk?', {
        {type = 'input', label = 'Razón', description = '¿Por qué te vas AFK?', required = true, min = 0, max = 16},
        {type = 'number', label = 'Minutos', description = '¿Cuántos minutos?', icon = {'far', 'calendar'}, required = true, min = 0, max = 60},
    })

    if not input then return end

    local msg = "¡Estoy AFK por "..input[2].. " Minutos! Razón: " .. input[1] .. ""                        

    TriggerServerEvent("loud:afk:update", msg)
    SetEntityAlpha(PlayerPedId(), 127, true) -- Opacidad del ped
end)


RegisterCommand("afk",function()
  TriggerEvent("loud:afk")
end)


-- https://github.com/DeffoN0tSt3/3d-me-do/blob/master/client.lua
-- @author Elio
local peds = {}

local GetGameTimer = GetGameTimer

function displayText(ped, text)
  local playerPed = PlayerPedId()
  local playerPos = GetEntityCoords(playerPed)
  local targetPos = GetEntityCoords(ped)
  local dist = #(playerPos - targetPos)
  local los = HasEntityClearLosToEntity(playerPed, ped, 17)

  if dist <= 150 and los then
      local exists = peds[ped] ~= nil

      peds[ped] = {
          text = text
      }

      if not exists then
          local display = true
          local initialPedPos = GetEntityCoords(ped) -- Guardamos la posicion inicial del ped

          while display do
              Wait(0)
              local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.3)
              drawAFK(pos, peds[ped].text)

              -- Comprobamos si la posicion cambio más de 2 metros
              local currentPedPos = GetEntityCoords(ped)
              local distanceMoved = #(currentPedPos - initialPedPos)

              if distanceMoved >= 2.0 then
                  display = false -- Ocultamos el texto si la pos cambio
                  SetEntityAlpha(PlayerPedId(), 255, false) -- Reset opacidad si la posicion cambio
                  
              end
          end
          peds[ped] = nil
      end
  end
end

RegisterNetEvent('loud:MostrarTodos', MostrarTodos)

function MostrarTodos(text, target)
    local player = GetPlayerFromServerId(target)
    if player ~= -1 or target == GetPlayerServerId(PlayerId()) then
        local ped = GetPlayerPed(player)
        displayText(ped, text)
    end
end

function drawAFK(coords, text)
  local camCoords = GetGameplayCamCoord()
  local dist = #(coords - camCoords)
  
  local scale = 350 / (GetGameplayCamFov() * dist)

  SetTextColour(0, 220, 0, 255)
  SetTextScale(0.0, 0.5 * scale)
  SetTextFont(1)
  SetTextDropshadow(0, 0, 0, 0, 55)
  SetTextDropShadow()
  SetTextCentre(true)

  BeginTextCommandDisplayText("STRING")
  AddTextComponentSubstringPlayerName(text)
  SetDrawOrigin(coords, 0)
  EndTextCommandDisplayText(0.0, 0.0)
  ClearDrawOrigin()
end

--[[function ShowAFK(text, playerCoords)
	SetFloatingHelpTextWorldPosition(1, playerCoords.x, playerCoords.y, playerCoords.z + 0.9)
	SetFloatingHelpTextStyle(1, 1, 18, 191, 3, 0)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandDisplayHelp(2, false, true, -1)
end]]--