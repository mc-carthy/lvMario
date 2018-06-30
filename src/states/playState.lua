PlayState = Class{ __includes = BaseState}

function PlayState:init()
    tiles = {}
    
    tilesheet = love.graphics.newImage('assets/sprites/tiles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)
    
    mapWidth = 20
    mapHeight = 20

    cameraScroll = 0

    backgroundR = math.random()
    backgroundG = math.random()
    backgroundB = math.random()

    for y = 1, mapHeight do
        table.insert(tiles, {})
        
        for x = 1, mapWidth do
            table.insert(tiles[y], {
                id = y < 5 and SKY or GROUND
            })
        end
    end
end

function PlayState:update(dt)
    if love.keyboard.isDown('left') then
        cameraScroll = cameraScroll - CAMERA_SCROLL_SPEED * dt
    elseif love.keyboard.isDown('right') then
        cameraScroll = cameraScroll + CAMERA_SCROLL_SPEED * dt
    end
end

function PlayState:draw()
    Push:start()
        love.graphics.translate(-math.floor(cameraScroll), 0)
        love.graphics.clear(backgroundR, backgroundG, backgroundB, 255)
        
        for y = 1, mapHeight do
            for x = 1, mapWidth do
                local tile = tiles[y][x]
                love.graphics.draw(tilesheet, quads[tile.id], (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end
    Push:finish()
end