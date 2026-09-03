--Tabla--
local Flags = {}

function Flags.new()
    local self = {
        vick = false,
        lost = false,
        resetTimer = 0,
        resetDelay = 2 
    }

--Carga Interaccion--
    function self:update(dt, hitboxes)
        if hitboxes.gameVick then
            self.vick = true
            self.lost = false
        elseif hitboxes.gameLost then
            self.lost = true
            self.vick = false
            self.resetTimer = self.resetTimer + dt
            if self.resetTimer >= self.resetDelay then
                hitboxes.gameLost = false
                self.resetTimer = 0
            end
        end
    end
--Renderizacion de Flags--
    function self:draw()
        if self.vick then
            love.graphics.setColor(0, 1, 0)
            love.graphics.printf("¡Ganaste!", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
        elseif self.lost then
            love.graphics.setColor(1, 0, 0)
            love.graphics.printf("¡Derrota!", 0, love.graphics.getHeight()/2, love.graphics.getWidth(), "center")
        end
        love.graphics.setColor(1, 1, 1)
    end

    return self
end

return Flags