function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] = love.graphics.newQuad(
                x * tilewidth, 
                y * tileheight, 
                tilewidth,
                tileheight, 
                atlas:getDimensions()
            )
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function GenerateTileQuads(atlas)
    local tiles = {}

    local x = 0
    local y = 0

    local counter = 1

    for row = 1, 9 do
        for i = 1, 2 do
            tiles[counter] = {}
            
            for col = 1, 6 do
                table.insert(tiles[counter], love.graphics.newQuad(
                    x, y, 32, 32, atlas:getDimensions()
                ))
                x = x + 32
            end

            counter = counter + 1
        end
        y = y + 32
        x = 0
    end

    return tiles
end

function GenerateTileSets(quads, setsX, setsY, sizeX, sizeY)
    local tilesets = {}
    local tableCounter = 0
    local sheetWidth = setsX * sizeX
    local sheetHeight = setsY * sizeY

    for tilesetY = 1, setsY do
        for tilesetX = 1, setsX do
            table.insert(tilesets, {})
            tableCounter = tableCounter + 1

            for y = sizeY * (tilesetY - 1) + 1, sizeY * (tilesetY - 1) + 1 + sizeY do
                for x = sizeX * (tilesetX - 1) + 1, sizeX * (tilesetX - 1) + 1 + sizeX do
                    table.insert(tilesets[tableCounter], quads[sheetWidth * (y - 1) + x])
                end
            end
        end
    end

    return tilesets
end