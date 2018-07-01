PlayState = Class{ __includes = BaseState}

function PlayState:init()
    tiles = {}
    
    tilesheet = love.graphics.newImage('assets/sprites/tiles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)

    characterSheet = love.graphics.newImage('assets/sprites/character.png')
    characterQuads = GenerateQuads(characterSheet, CHARACTER_WIDTH, CHARACTER_HEIGHT)

    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    characterY = ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT
    
    idleAnimation = Animation {
        frames = { 1 },
        interval = 1
    }
    movingAnimation = Animation {
        frames = { 10, 11 },
        interval = 0.2
    }

    currentAnimation = idleAnimation
    direction = 'right'

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
                id = y < 7 and SKY or GROUND
            })
        end
    end
end

function PlayState:update(dt)
    currentAnimation:update(dt)
    if love.keyboard.isDown('left') then
        characterX = characterX - CHARACTER_MOVE_SPEED * dt
        currentAnimation = movingAnimation
        direction = 'left'
    elseif love.keyboard.isDown('right') then
        characterX = characterX + CHARACTER_MOVE_SPEED * dt
        currentAnimation = movingAnimation
        direction = 'right'
    else
        currentAnimation = idleAnimation
    end
    cameraScroll = characterX - (VIRTUAL_WIDTH / 2) + (CHARACTER_WIDTH / 2)
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
        love.graphics.draw(
            characterSheet, 
            characterQuads[currentAnimation:getCurrentFrame()], 
            math.floor(characterX) + CHARACTER_WIDTH / 2, 
            math.floor(characterY) + CHARACTER_HEIGHT / 2,
            0,
            direction == 'left' and -1 or 1, 
            1,
            CHARACTER_WIDTH / 2, CHARACTER_HEIGHT / 2)
    Push:finish()
end