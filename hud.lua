--HUD--
local hud = {}
hud.__index = hud

function hud.new(text, x, y)
    local self = setmetatable({}, hud)

    self.text = text or ""
    self.x = x or 0
    self.y = y or 0
    self.value = 0

    return self
end

function hud:update(dt, value)
    if value ~= nil then
        self.value = value
    end
end

function hud:draw()
    love.graphics.print(
        self.text .. tostring(self.value),
        self.x,
        self.y
    )
end

--Timer--
local timer = setmetatable({}, {__index = hud})
timer.__index = timer

function timer.new(x, y)
    local self = hud.new("Tiempo actual: ", x or 550, y or 0)
    setmetatable(self, timer)

    self.tiempo = 0
    return self
end

function timer:update(dt, tiempo)
    if tiempo ~= nil then
        self.tiempo = tiempo
    else
        self.tiempo = self.tiempo + dt
    end

    self.value = string.format("%.2f", self.tiempo)
end

--BestTime--
local besttime = setmetatable({}, {__index = hud})
besttime.__index = besttime

function besttime.new(x, y)
    local self = hud.new("Mejor tiempo: ", x or 550, y or 20)
    setmetatable(self, besttime)

    self.tiempo = nil
    self.value = "--"
    return self
end


function besttime:update(dt, tiempo)
    if tiempo ~= nil then
        self.tiempo = tiempo
        self.value = string.format("%.2f", self.tiempo)
    else
        self.value = "--"
    end
end

--DeathCounter
local deathcounter = setmetatable({}, {__index = hud})
deathcounter.__index = deathcounter

function deathcounter.new(x, y)
    local self = hud.new("Muertes: ", x or 550, y or 40)
    setmetatable(self, deathcounter)

    self.muertes = 0
    return self
end

function deathcounter:update(dt, muertes)
    if muertes ~= nil then
        self.muertes = muertes
    end

    self.value = self.muertes
end


return {
    HUD = hud,
    Timer = timer,
    BestTime = besttime,
    DeathCounter = deathcounter
}
