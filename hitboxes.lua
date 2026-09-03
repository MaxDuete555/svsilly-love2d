--Tabla--
local Hitboxes = {}

function Hitboxes.new(player)
    local self = {
        player = player,
        startX = player.x,
        startY = player.y,

        defeatZone = {x = 200, y = 200, w = 64, h = 64},
        goalZone   = {x = 600, y = 100, w = 64, h = 64},
        gameWon    = false,
        gameLost   = false,

        asteroidSprites = {
            love.graphics.newImage("sprites/Asteroid1.png"),
            love.graphics.newImage("sprites/Asteroid2.png"),
            love.graphics.newImage("sprites/Asteroid3.png"),
            love.graphics.newImage("sprites/Asteroid4.png")
        },
        asteroidFrame = 1,
        meteorTimer = 0
    }

    -- ABB
    local function collide(a, b)
        return a.x < b.x + b.w and
               b.x < a.x + a.w and
               a.y < b.y + b.h and
               b.y < a.y + a.h
    end
    
    --Actualización Hitboxes
    function self:update(dt)
        local playerHitbox = {
            x = self.player.x,
            y = self.player.y,
            w = self.player.sprites.idle:getWidth(),
            h = self.player.sprites.idle:getHeight()
        }

        self.meteorTimer = self.meteorTimer + dt
        if self.meteorTimer > 0.15 then
            self.asteroidFrame = self.asteroidFrame % #self.asteroidSprites + 1
            self.meteorTimer = 0
        end

        if collide(playerHitbox, self.defeatZone) then
            self.player.x = self.startX
            self.player.y = self.startY
            self.gameLost = true
            self.gameWon = false
        elseif collide(playerHitbox, self.goalZone) then
            self.gameWon = true
            self.gameLost = false
        end
    end

    --Dibujo
    function self:draw()
        love.graphics.draw(self.asteroidSprites[self.asteroidFrame], self.defeatZone.x, self.defeatZone.y)
        love.graphics.setColor(0, 1, 0, 0.3)
        love.graphics.rectangle("fill", self.goalZone.x, self.goalZone.y, self.goalZone.w, self.goalZone.h)
        love.graphics.setColor(1, 1, 1)
    end

    return self
end

return Hitboxes