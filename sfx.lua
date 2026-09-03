--Tabla--
local SFX = {}

function SFX.new()
    local self = {}

    --Sonidos
    self.music = love.audio.newSource("soundeffects/musicafond.ogg", "stream")
    self.lose = love.audio.newSource("soundeffects/lose.wav", "static")

    
    self.music:setLooping(true)
    self.music:setVolume(0.5)
    self.music:play() 

    
    function self:playLose()
        love.audio.stop(self.lose) 
        self.lose:play()
    end

    --Pausa y musica (Pendiente)--
    function self:pauseMusic()
        self.music:pause()
    end

    function self:resumeMusic()
        self.music:play()
    end

    function self:stopMusic()
        self.music:stop()
    end

    return self
end

return SFX