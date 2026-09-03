--Tabla--
local Player = {}
Player.__index = Player

function Player.new(x, y)

    local self = {
        x = x,
        y = y,
        speed = 350,
        dir = "idle",   
        frame = 1,      
        timer = 0,
        sprites = {
            idle   = love.graphics.newImage("sprites/Pidle.png"),
            left   = love.graphics.newImage("sprites/Pright.png"),
            right  = love.graphics.newImage("sprites/Pleft.png"),
            front  = {
                love.graphics.newImage("sprites/Pfront1.png"),
                love.graphics.newImage("sprites/Pfront2.png"),
                love.graphics.newImage("sprites/Pfront3.png")
            }
        }
    }
    setmetatable(self, Player)
    return self
end
    --Actualización jugador
    function Player:update(dt)
        local moving = false

        if love.keyboard.isDown("left") then
            self.x = self.x - self.speed * dt
            self.dir = "left"
            moving = true
        elseif love.keyboard.isDown("right") then
            self.x = self.x + self.speed * dt
            self.dir = "right"
            moving = true
        elseif love.keyboard.isDown("up") then
            self.y = self.y - self.speed * dt
            self.dir = "front"
            moving = true
        elseif love.keyboard.isDown("down") then
            self.y = self.y + self.speed * dt
            self.dir = "idle"
            moving = true
        end

        --Animación de Pfront
        if self.dir == "front" and moving then
            self.timer = self.timer + dt
            if self.timer > 0.15 then
                self.frame = self.frame + 1
                if self.frame > #self.sprites.front then
                    self.frame = 1
                end
                self.timer = 0
            end
        else
            self.frame = 1
        end
    end

--Renderizacon Jugador--
function Player:draw()
    if self.dir == "front" then
        love.graphics.draw(self.sprites.front[self.frame], self.x, self.y)
    else
        love.graphics.draw(self.sprites[self.dir], self.x, self.y)
    end
end

return Player