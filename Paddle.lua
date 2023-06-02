Paddle = Class {}

function Paddle:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.startX = x
    self.startY = y
    self.dY = 0
end

function Paddle:reset()
    self.x = self.startX
    self.y = self.startY
end

function Paddle:update(dt)
    if self.dY < 0 then
        self.y = math.max(0, self.y + self.dY * dt)
    else
        self.y = math.min(V_HEIGHT - self.height, self.y + self.dY * dt)
    end
end

function Paddle:render(dt)
    love.graphics.rectangle('fill', self.x,self.y,self.width,self.height)
end
