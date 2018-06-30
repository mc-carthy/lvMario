require('src/utils/dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())

    stateMachine = StateMachine {
        ['play'] = function() return PlayState() end
    }

    stateMachine:change('play')

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })
end

function love.update(dt)
    stateMachine:update(dt)
end

function love.draw()
    stateMachine:draw()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end