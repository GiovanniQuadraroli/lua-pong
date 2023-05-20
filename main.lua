push = require 'push'

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

V_WIDTH = 432
V_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    smallFont = love.graphics.newFont('font.ttf', 8)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    push:setupScreen(V_WIDTH, V_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    player1Y = 30
    player2Y = V_HEIGHT - 50
end

function love.update(dt)

    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    if love.keyboard.isDown('up') then
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        player2Y = player2Y + PADDLE_SPEED * dt
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)
    love.graphics.setFont(smallFont)
    love.graphics.printf('Hello Pong!', 0, 20, V_WIDTH, 'center')
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), V_WIDTH / 2 - 50, V_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), V_WIDTH / 2 + 30, V_HEIGHT / 3)
    love.graphics.rectangle('fill', 10, player1Y, 5, 20)
    love.graphics.rectangle('fill', V_WIDTH - 10, player2Y, 5, 20)
    love.graphics.rectangle('fill', V_WIDTH / 2 - 2, V_HEIGHT / 2 - 2, 4, 4)
    push:apply('end')
end
