--Clase principal
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
function Menace:collide()
    local playerHitbox = {
        x = self.player.x,
        y = self.player.y,
        w = self.player.sprites.idle:getWidth(),
        h = self.player.sprites.idle:getHeight()
    }

    local zone = self.zone
    return playerHitbox.x < zone.x + zone.w and
           zone.x < playerHitbox.x + playerHitbox.w and
           playerHitbox.y < zone.y + zone.h and
           zone.y < playerHitbox.y + playerHitbox.h
end

function Menace:draw()
end

-- Subclase Asteroid
local Asteroid = setmetatable({}, {__index = Menace})
Asteroid.__index = Asteroid

function Asteroid:new(player)
    local self = Menace:new(player, 700, 0, 64, 64)
    setmetatable(self, Asteroid)

    self.sprites = {
        love.graphics.newImage("sprites/Asteroid1.png"),
        love.graphics.newImage("sprites/Asteroid2.png"),
        love.graphics.newImage("sprites/Asteroid3.png"),
        love.graphics.newImage("sprites/Asteroid4.png")
    }

    self.frame = 1
    self.timer = 0
    self.vx = -100   
    self.vy = 200   
    return self
end

function Asteroid:update(dt)
    self.zone.x = self.zone.x + self.vx * dt
    self.zone.y = self.zone.y + self.vy * dt
    self.timer = self.timer + dt
    if self.timer > 0.15 then
        self.frame = self.frame % #self.sprites + 1
        self.timer = 0
    end

    -- Reinicio--
    if self.zone.y > love.graphics.getHeight() + 50 or self.zone.x < -64 then
        self.zone.x = 700
        self.zone.y = 0
    end
    
    if self:collide() then
        self.player.x = 450
        self.player.y = 500
        self.gameLost = true
        self.gameWon  = false
    end
end

--Renderizado--
function Asteroid:draw()
    love.graphics.draw(self.sprites[self.frame], self.zone.x, self.zone.y)
end

--Subclase DeathZone--
local DeathZone = setmetatable({}, {__index = Menace})
DeathZone.__index = DeathZone

function DeathZone:new(player, x, y, w, h)
    local self = Menace:new(player, x, y, w, h)
    setmetatable(self, DeathZone)
    return self
end

return {Menace=Menace, Asteroid=Asteroid, DeathZone=DeathZone}
