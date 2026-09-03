local Player = require("player")
local Hitboxes = require("hitboxes")
local Flags = require("flags")
local SFX = require("sfx")
local tiempo=0
local mejortiempo = math.huge
local active=true
local paused =false
local p, hb, fg, sfx

function love.load()
    p = Player.new(450, 500)
    hb = Hitboxes.new(p)
    fg = Flags.new()
    sfx = SFX.new()
end

function love.keypressed(key)
    if key == "p" then
        paused = not paused
    end
end

function love.update(dt)
    if not paused then
        p:update(dt)
        hb:update(dt)
        fg:update(dt, hb)
        tiempo = tiempo + dt
    end

    if hb.gameLost then
            sfx:playLose()
        end

        if mejorTiempo == nil or tiempo < mejorTiempo then
    mejorTiempo = tiempo
    end
end

function love.draw()
    p:draw()
    hb:draw()
    fg:draw()
     love.graphics.print(string.format("Tiempo actual: %.2f", tiempo), 550, 0)
    love.graphics.print(string.format("Mejor tiempo: %.2f", mejorTiempo), 550, 20)
end