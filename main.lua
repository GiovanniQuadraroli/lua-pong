push = require 'push'

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

V_WIDTH = 432
V_HEIGHT = 243

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    font = love.graphics.newFont('font.ttf',8)

    love.graphics.setFont(font)

    push:setupScreen(V_WIDTH, V_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40/255,45/255,52/255,255/255)
    love.graphics.printf('Hello Pong!', 0, 20, V_WIDTH, 'center')
    love.graphics.rectangle('fill',10,30,5,20)
    love.graphics.rectangle('fill',V_WIDTH-10,V_HEIGHT-50,5,20)
    love.graphics.rectangle('fill',V_WIDTH/2-2,V_HEIGHT/2-2,4,4)
    push:apply('end')
end
