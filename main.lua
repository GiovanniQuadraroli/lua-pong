push = require 'push'

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

V_WIDTH = 432
V_HEIGHT = 243

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

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
    love.graphics.printf('Hello Pong!', 0, V_HEIGHT / 2 - 6, V_WIDTH, 'center')
    push:apply('end')
end
