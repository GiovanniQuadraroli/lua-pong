push = require 'push'

Class = require 'class'

require 'Paddle'
require 'Ball'

WINDOW_HEIGHT = 720
WINDOW_WIDTH = 1280

V_WIDTH = 432
V_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    push:setupScreen(V_WIDTH, V_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    player1Score = 0
    player2Score = 0
    servingPlayer = '1'
    limitScore = 3

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(V_WIDTH - 10, V_HEIGHT - 30, 5, 20)

    ball = Ball(V_WIDTH / 2 - 2, V_HEIGHT / 2 - 2, 4, 4)
    gameState = 'start'

end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'serve' then
        ball.dy = math.random(-50, 50)
        if servingPlayer == '1' then
            ball.dx = math.random(140, 200)
        elseif servingPlayer == '2' then
            ball.dx = -math.random(140, 200)
        end
    end
    if gameState == 'play' then
        if ball.y < player2.y + player2.height / 2 then
            player2.y = player2.y - 3
        elseif ball.y > player2.y + player2.height / 2 then
            player2.y = player2.y + 3
        end
        if ball:collide(player1) then
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        if ball:collide(player2) then
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
            sounds['paddle_hit']:play()
        end
        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy * 1.03
            ball.dx = ball.dx * 1.03
            sounds['wall_hit']:play()
        end
        if ball.y >= V_HEIGHT - 4 then
            ball.y = V_HEIGHT - 4
            ball.dy = -ball.dy * 1.03
            ball.dx = ball.dx * 1.03
            sounds['wall_hit']:play()
        end
        if ball.x < -4 then
            player2Score = player2Score + 1
            gameState = 'serve'
            ball:reset()
            player1:reset()
            player2:reset()
            sounds['score']:play()
            servingPlayer = '1'
            if player2Score == limitScore then
                winnerPlayer = '2'
                gameState = 'completed'
            end
        elseif ball.x > V_WIDTH + 4 then
            player1Score = player1Score + 1
            gameState = 'serve'
            ball:reset()
            player1:reset()
            player2:reset()
            sounds['score']:play()
            servingPlayer = '2'
            if player1Score == limitScore then
                winnerPlayer = '1'
                gameState = 'completed'
            end
        end
    end

    -- player 1 movement
    if love.keyboard.isDown('w') then
        player1.dY = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dY = PADDLE_SPEED
    else
        player1.dY = 0
    end

    -- -- player 2 movement
    -- if love.keyboard.isDown('up') then
    --     player2.dY = -PADDLE_SPEED
    -- elseif love.keyboard.isDown('down') then
    --     player2.dY = PADDLE_SPEED
    -- else
    --     player2.dY = 0
    -- end

    if gameState == 'play' then
        ball:update(dt)
    end
    player1:update(dt)
    player2:update(dt)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'serve'
        elseif gameState == 'play' then
            gameState = 'serve'
            ball:reset()
            player1:reset()
            player2:reset()
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'completed' then
            gameState = 'start'
            ball:reset()
            player1:reset()
            player2:reset()
            player1Score = 0
            player2Score = 0
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.clear(40 / 255, 45 / 255, 52 / 255, 255 / 255)

    displayScore()

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Hello Pong!', 0, 10, V_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 20, V_WIDTH, 'center')
    elseif gameState == 'serve' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Player ' .. servingPlayer .. "'s serve!", 0, 10, V_WIDTH, 'center')
        love.graphics.printf('Press Enter to serve!', 0, 20, V_WIDTH, 'center')
    elseif gameState == 'completed' then
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' .. winnerPlayer .. " won!", 0, 10, V_WIDTH, 'center')
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to play again!', 0, 30, V_WIDTH, 'center')
        -- nothing to render
    end

    player1:render()
    player2:render()
    ball:render()
    displayFPS()
    push:apply('end')
end

function displayFPS()
    love.graphics.setFont(smallFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1Score), V_WIDTH / 2 - 50, V_HEIGHT / 3)
    love.graphics.print(tostring(player2Score), V_WIDTH / 2 + 30, V_HEIGHT / 3)
end
