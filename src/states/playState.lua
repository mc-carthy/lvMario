PlayState = Class{ __includes = BaseState}

function PlayState:init()
    tilesheet = love.graphics.newImage('assets/sprites/tiles.png')
    quads = GenerateQuads(tilesheet, TILE_SIZE, TILE_SIZE)

    topperSheet = love.graphics.newImage('assets/sprites/tileTops.png')
    topperQuads = GenerateQuads(topperSheet, TILE_SIZE, TILE_SIZE)

    tilesets = GenerateTileSets(quads, TILE_SETS_WIDE, TILE_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)
    toppersets = GenerateTileSets(topperQuads, TOPPER_SETS_WIDE, TOPPER_SETS_TALL, TILE_SET_WIDTH, TILE_SET_HEIGHT)

    tileset = math.random(#tilesets)
    topperset = math.random(#toppersets)

    characterSheet = love.graphics.newImage('assets/sprites/character.png')
    characterQuads = GenerateQuads(characterSheet, CHARACTER_WIDTH, CHARACTER_HEIGHT)

    characterX = VIRTUAL_WIDTH / 2 - (CHARACTER_WIDTH / 2)
    characterY = ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT
    characterDY = 0
    
    idleAnimation = Animation {
        frames = { 1 },
        interval = 1
    }
    movingAnimation = Animation {
        frames = { 10, 11 },
        interval = 0.2
    }
    jumpAnimation = Animation {
        frames = { 3 },
        interval = 1
    }

    currentAnimation = idleAnimation
    direction = 1

    mapWidth = 20
    mapHeight = 20

    cameraScroll = 0

    backgroundR = math.random()
    backgroundG = math.random()
    backgroundB = math.random()

    tiles = generateLevel()
end

function PlayState:update(dt)
    characterDY = characterDY + GRAVITY
    characterY = characterY + characterDY * dt

    if characterY > ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT then
        characterY = ((7 - 1) * TILE_SIZE) - CHARACTER_HEIGHT
        characterDY = 0
    end

    currentAnimation:update(dt)

    currentAnimation = idleAnimation
    if love.keyboard.isDown('left') then
        characterX = characterX - CHARACTER_MOVE_SPEED * dt
        currentAnimation = movingAnimation
        direction = -1
    elseif love.keyboard.isDown('right') then
        characterX = characterX + CHARACTER_MOVE_SPEED * dt
        currentAnimation = movingAnimation
        direction = 1
    end
    if characterDY ~= 0 then
        currentAnimation = jumpAnimation
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
            love.graphics.draw(tilesheet, tilesets[tileset][tile.id], 
                (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)

            if tile.topper then
                love.graphics.draw(topperSheet, toppersets[topperset][tile.id], 
                    (x - 1) * TILE_SIZE, (y - 1) * TILE_SIZE)
            end
        end
    end

    love.graphics.draw(
        characterSheet, 
        characterQuads[currentAnimation:getCurrentFrame()], 
        math.floor(characterX) + CHARACTER_WIDTH / 2, 
        math.floor(characterY) + CHARACTER_HEIGHT / 2,
        0,
        direction, 
        1,
        CHARACTER_WIDTH / 2, CHARACTER_HEIGHT / 2)
    Push:finish()
end


function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'space' then
        characterDY = JUMP_VELOCITY
    end
    if key == 'r' then
        tileset = math.random(#tilesets)
        topperset = math.random(#toppersets)
    end
end

function generateLevel()
    local tiles = {}

    for y = 1, mapHeight do
        table.insert(tiles, {})

        for x = 1, mapWidth do
            table.insert(tiles[y], {
                id = SKY,
                topper = false
            })
        end
    end

    for x = 1, mapWidth do
        local spawnPillar = math.random(5) == 1
        
        if spawnPillar then
            for pillar = 4, 6 do
                tiles[pillar][x] = {
                    id = GROUND,
                    topper = pillar == 4 and true or false
                }
            end
        end

        for ground = 7, mapHeight do
            tiles[ground][x] = {
                id = GROUND,
                topper = (not spawnPillar and ground == 7) and true or false 
            }
        end
    end

    return tiles
end