
local Player = require("player")

local M = require("menace")
local Asteroid = M.Asteroid
local DeathZone = M.DeathZone
local Explosion = M.Explosion

local Flags = require("flags")
local SFX = require("sfx")
local HUD = require("hud")
local Events = require("events")

-- Clases HUD --
local Timer = HUD.Timer
local BestTime = HUD.BestTime
local DeathCounter = HUD.DeathCounter


local paused = false

local tiempo = 0
local mejorTiempo = nil
local muertes = 0

local derrotaAnterior = false
local explosionDesbloqueada = false

-- Objetos --
local p, ast, dz, xpl, fg, sfx
local timer, besttime, deathcounter


function love.load()
    
    print("MAIN.LUA SE HA CARGADO")
    p = Player.new(450, 500)
    ast = M.Asteroid:new(p)
    dz = M.DeathZone:new(p, 200, 200, 64, 64)
    xpl = M.Explosion:new(p, 502, 100, 64, 64)

    
    xpl.active = false

    fg = Flags.new()
    sfx = SFX.new()

    -- Crear HUD --
    timer = Timer.new(550, 0)
    besttime = BestTime.new(550, 20)
    deathcounter = DeathCounter.new(550, 40)

    -- Evento gameLost--
    Events.on("player_died", function(tiempoFinal)
        print("EVENTO: player_died", tiempoFinal)
        muertes = muertes + 1

        if mejorTiempo == nil or tiempoFinal > mejorTiempo then
            mejorTiempo = tiempoFinal
        end

        sfx:playLose()
    end)

    -- Evento Unlock --
    Events.on("explosion_unlocked", function()
        explosionDesbloqueada = true
        xpl.active = true
    end)
end



function love.keypressed(key)
    if key == "p" then
        paused = not paused
    end

    
    if key == "r" and dz.gameLost then
        dz.gameLost = false
        dz.gameWon = false

        ast.gameLost = false
        ast.gameWon = false

        xpl.gameLost = false
        xpl.gameWon = false

        tiempo = 0
        derrotaAnterior = false
    end
end



function love.update(dt)
    if not paused then
        -- Actualizar entidades
        p:update(dt)
        ast:update(dt)
        dz:update(dt)

        -- Avanzar el tiempo mientras la partida sigue activa
        if not dz.gameLost and not dz.gameWon then
            tiempo = tiempo + dt
        end

        -- Desbloquear la explosion al llegar a 40 segundos
        if tiempo >= 40 and not explosionDesbloqueada then
            Events.emit("explosion_unlocked")
        end

        xpl:update(dt)
        fg:update(dt, dz, ast)
    end

    -- Detectar derrotas producidas por cualquier entidad
    local derrotaActual =
        dz.gameLost or ast.gameLost or xpl.gameLost

    -- Emitir el evento solo cuando comienza una nueva derrota
    if derrotaActual and not derrotaAnterior then
        -- Unificar el estado de derrota para el resto del juego
        dz.gameLost = true
        dz.gameWon = false

        -- Limpiar los estados locales de las entidades
        ast.gameLost = false
        xpl.gameLost = false

        -- Notificar a los observadores
        Events.emit("player_died", tiempo)

        -- Reiniciar el cronometro de la partida
        tiempo = 0
    end

    derrotaAnterior = dz.gameLost

    -- Actualizar HUD
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

    -- HUD
    timer:draw()
    besttime:draw()
    deathcounter:draw()

    
    if paused then
        love.graphics.print("PAUSA", 550, 70)
    end
end
