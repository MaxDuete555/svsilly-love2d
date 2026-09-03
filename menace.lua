-- menace.lua
local Menace = {}
Menace.__index = Menace

function Menace:new(player, x, y, w, h)
    local self = setmetatable({}, Menace)
    self.player = player
    self.zone = {x=x, y=y, w=w, h=h}
    return self
end

function Menace:update(dt)
end
function Menace:draw()
end

-- Subclase Asteroid
local Asteroid = setmetatable({}, {__index = Menace})
Asteroid.__index = Asteroid

function Asteroid:new(player)
    local self = Menace:new(player, 200, -100, 64, 64)
    setmetatable(self, Asteroid)
    -- sprites, animación, etc.
    return self
end

-- Subclase DeathZone
local DeathZone = setmetatable({}, {__index = Menace})
DeathZone.__index = DeathZone

function DeathZone:new(player, x, y, w, h)
    local self = Menace:new(player, x, y, w, h)
    setmetatable(self, DeathZone)
    return self
end

return {Menace=Menace, Asteroid=Asteroid, DeathZone=DeathZone}
