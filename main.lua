push = require 'push'

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

V_WIDTH = 432
V_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    math.randomseed(os.time())

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

    ballX = V_WIDTH / 2 - 2
    ballY = V_HEIGHT / 2 - 2

    ballDX = math.random(2) == 1 and 100 or -100
    ballDY = math.random(-50, 50) * 1.5

    gameState = 'start'

end

function love.update(dt)

    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1Y = math.max(player1Y + -PADDLE_SPEED * dt, 0)
    elseif love.keyboard.isDown('s') then
        player1Y = math.min(player1Y + PADDLE_SPEED * dt, V_HEIGHT - 20)
    end

    if love.keyboard.isDown('up') then
        player2Y = math.max(player2Y + -PADDLE_SPEED * dt, 0)
    elseif love.keyboard.isDown('down') then
        player2Y = math.min(player2Y + PADDLE_SPEED * dt, V_HEIGHT - 20)
    end

    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'play'
        elseif gameState == 'play' then
            gameState = 'start'
            ballX = V_WIDTH / 2 - 2
            ballY = V_HEIGHT / 2 - 2

            ballDX = math.random(2) == 1 and 100 or -100
            ballDY = math.random(-50, 50) * 1.5
        end
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
    love.graphics.rectangle('fill', ballX, ballY, 4, 4)
    push:apply('end')
end
