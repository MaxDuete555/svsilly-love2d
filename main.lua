local Player = require("player")
--
local M = require("menace")
local Asteroid = M.Asteroid
local DeathZone = M.DeathZone
local Explosion = M.Explosion
local Flags = require("flags")
local SFX = require("sfx")
local tiempo=0
local mejortiempo = math.huge
local active=true
local paused =false
local p, ast, dz, xpl, fg, sfx

function love.load()
    p = Player.new(450, 500)
    ast = M.Asteroid:new(p)
    dz  = M.DeathZone:new(p, 200, 200, 64, 64)
    xpl = M.Explosion:new(p, 502, 100, 64, 64)
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
        ast:update(dt)
        dz:update(dt)
        xpl:update(dt)
        fg:update(dt, dz, ast)
        tiempo = tiempo + dt
    end

    if dz.gameLost then
            sfx:playLose()
        end

        if mejorTiempo == nil or tiempo < mejorTiempo then
    mejorTiempo = tiempo
    end
end

function love.draw()
    p:draw()
    ast:draw()
    dz:draw()
    xpl:draw()
    fg:draw()
     love.graphics.print(string.format("Tiempo actual: %.2f", tiempo), 550, 0)
    love.graphics.print(string.format("Mejor tiempo: %.2f", mejorTiempo), 550, 20)
end