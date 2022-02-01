window_width=1300
window_height=750

Class = require "Class"

Paddle = Class{}
Ball = Class{}
--change
function Paddle:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.speed = 200
end

function Ball:init(x,y,width,height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.xspeed = 0
    self.yspeed = 0
end

function Paddle:draw()
    love.graphics.rectangle("fill",self.x,self.y,self.width,self.height)
end

function Ball:draw()
    love.graphics.draw(ball_image,self.x,self.y,0,0.018,0.018)
end

function Ball:update(dt)
    self.x=self.x+self.xspeed*dt
    self.y=self.y+self.yspeed*dt
    if self.y<0 then
        ball.yspeed=-ball.yspeed
        self.y=0
        tok:play()
    end
    if self.y>window_height-self.height then
        ball.yspeed=-ball.yspeed
        self.y=window_height-self.height
        tok:play()
    end
    if collision(ball,left_paddle)then
        ball.xspeed=-ball.xspeed*1.1
        ball.x=left_paddle.width
        tik:play()
    end
    if collision(ball,right_paddle)then
        ball.xspeed=-ball.xspeed*1.1
        ball.x=window_width-right_paddle.width-ball.width
        tik:play()
    end
    if (self.x>window_width)then
        player1_score=player1_score+1
        self.x=window_width/2-self.width/2      
        self.y=window_height/2-self.height/2
        turn=2
        self.xspeed=-math.random(250,350)
        if math.random(1,2)==1 then
            self.yspeed=math.random(100,600)
        else
            self.yspeed=-math.random(100,600)
        end
    elseif (self.x<-self.width)then
        player2_score=player2_score+1
        self.x=window_width/2-self.width/2        
        self.y=window_height/2-self.height/2
        turn=1
        self.xspeed=math.random(100,600)
        if math.random(1,2)==1 then
            self.yspeed=math.random(250,350)
        else
            self.yspeed=-math.random(100,600)
        end
    end
end

function collision(k,v)
    return k.x+k.width>v.x and
           k.x<v.x+v.width and
           k.y+k.height>v.y and
           k.y<v.y+v.height
end

function love.keypressed(key)
    if key=="space" and state=="steady" then
        state="play"
        if math.random(1,2)==1 then
            ball.xspeed=math.random(250,450)
        else
            ball.xspeed=-math.random(250,450)
        end
        if math.random(1,2)==1 then
            ball.yspeed=math.random(250,450)
        else
            ball.yspeed=-math.random(250,450)
        end
    end
end

function love.load ()
    math.randomseed=(os.time())
    love.window.setMode(window_width,window_height)
    left_paddle = Paddle(0,window_height/2-100/2,20,100)
    right_paddle = Paddle(window_width-20, window_height/2-100/2,20,100)
    ball = Ball(window_width/2-5,window_height/2-5,10,10)
    player1_score=0
    player2_score=0
    turn=1
    state="steady"
    Background=love.graphics.newImage('Images/bg.jpg')
    ball_image=love.graphics.newImage('Images/ball.png')
    tik=love.audio.newSource('Audio/Tik.mp3','static')
    tok=love.audio.newSource('Audio/Tok.mp3','static')
    Music=love.audio.newSource('Audio/Music.mp3',"stream")
end

function love.update (dt)
    if love.keyboard.isDown('w')then
        left_paddle.y=math.max(0,left_paddle.y-left_paddle.speed*dt)
    end
    if love.keyboard.isDown('s')then
        left_paddle.y=math.min(window_height-left_paddle.height,left_paddle.y+left_paddle.speed*dt)
    end
    if love.keyboard.isDown('up')then
        right_paddle.y=math.max(0,right_paddle.y-right_paddle.speed*dt)
    end
    if love.keyboard.isDown('down')then
        right_paddle.y=math.min(window_height-right_paddle.height,right_paddle.y+right_paddle.speed*dt)
    end
    ball:update(dt)
    Music:play()
    Music:setLooping(true)
end

function love.draw ()
    love.graphics.draw(Background,0,0,0,0.5,0.5)
    if state=="steady"then
        love.graphics.setFont(love.graphics.newFont(30))
        love.graphics.setColor(0,1,0)
        love.graphics.printf("press space to start the game",0,window_height/2+100,window_width,"center")
        love.graphics.setColor(0,0,1)
        left_paddle:draw()
        love.graphics.setColor(1,0,0)
        right_paddle:draw()
        love.graphics.setColor(1,1,1)
        ball:draw()
    else
        love.graphics.setColor(0,0,1)
        left_paddle:draw()
        love.graphics.setColor(1,0,0)
        right_paddle:draw()
        love.graphics.setColor(1,1,1)
        ball:draw()
        love.graphics.setFont(love.graphics.newFont(30))
        love.graphics.setColor(0,1,0)
        love.graphics.printf(tostring(player1_score),200,100,100,"center")
        love.graphics.printf(tostring(player2_score),1000,100,100,"center")
        love.graphics.setColor(1,1,1)
    end
end