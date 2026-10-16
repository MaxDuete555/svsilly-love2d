-- Eventos --
local events = {}

local listeners = {}


function events.on(eventName, callback)
    assert(type(eventName) == "string", "El evento debe tener un nombre")
    assert(type(callback) == "function", "El observador debe ser una funcion")

    listeners[eventName] = listeners[eventName] or {}
    table.insert(listeners[eventName], callback)
end

-- Iniciar Emision--
function events.emit(eventName, ...)
    local observers = listeners[eventName]

    if not observers then
        print("[SIN OBSERVADORES]: " .. eventName)
        return
    end

    -- Subs--
    local snapshot = {}

    for i, callback in ipairs(observers) do
        snapshot[i] = callback
    end

    for _, callback in ipairs(snapshot) do
        callback(...)
        print("[OBSERVADOR EJECUTADO]: " .. eventName)
    end
end

return events
