RegisterServerEvent("loud:afk:update")
AddEventHandler("loud:afk:update", function(msg)

    local src = source

    TriggerClientEvent('loud:MostrarTodos', -1, msg, src)

end)




