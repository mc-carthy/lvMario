PlayState = Class{ __includes = BaseState}

function PlayState:init()

end

function PlayState:update(dt)

end

function PlayState:draw()
    love.graphics.print('test', 10, 10)
end