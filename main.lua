
local Player = require("player")

local M = require("menace")
local Asteroid = M.Asteroid
local DeathZone = M.DeathZone
local Explosion = M.Explosion

local Flags = require("flags")
local HUD = require("hud")

local Timer = HUD.Timer
local BestTime = HUD.BestTime
local DeathCounter = HUD.DeathCounter
local SFX = require("sfx")
local active = true
local paused = false

local tiempo = 0
local mejorTiempo = nil
local muertes = 0
local derrotaAnterior = false

local p, ast, dz, xpl, fg, sfx
local timer, besttime, deathcounter


function love.load()
    p = Player.new(450, 500)
    ast = M.Asteroid:new(p)
    dz = M.DeathZone:new(p, 200, 200, 64, 64)
    xpl = M.Explosion:new(p, 502, 100, 64, 64)
    fg = Flags.new()
    sfx = SFX.new()

    -- Crear HUD --
    timer = Timer.new(550, 0)
    besttime = BestTime.new(550, 20)
    deathcounter = DeathCounter.new(550, 40)
end


function love.keypressed(key)
    if key == "p" then
        paused = not paused
    end

    
    if key == "r" and dz.gameLost then
    dz.gameLost = false
    dz.gameWon = false
    tiempo = 0
    derrotaAnterior = false
    end
end


function love.update(dt)
    if not paused then
        p:update(dt)
        ast:update(dt)
        dz:update(dt)

        tiempo = tiempo + dt

        -- Unlocks --
        if tiempo >= 40 then
            xpl.active = true
        end

        xpl:update(dt)
        fg:update(dt, dz, ast)
    end

    -- Detectar una nueva derrota --
    if dz.gameLost and not derrotaAnterior then
    muertes = muertes + 1
    sfx:playLose()

    -- Guardar el récord antes de reiniciar el tiempo
    if mejorTiempo == nil or tiempo > mejorTiempo then
        mejorTiempo = tiempo
    end

    tiempo = 0
end

    derrotaAnterior = dz.gameLost

    -- Actualizar HUD --
    timer:update(dt, tiempo)
besttime:update(dt, mejorTiempo)
deathcounter:update(dt, muertes)
end


function love.draw()
    p:draw()
    ast:draw()
    dz:draw()
    xpl:draw()
    fg:draw()

    -- Dibujar HUD --
    timer:draw()
    besttime:draw()
    deathcounter:draw()
end
