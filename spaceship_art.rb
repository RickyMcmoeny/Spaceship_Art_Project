require 'rubygems' # only necessary in Ruby 1.8
require 'gosu'


$window_height = 1200 #480 #1200
$window_width = 2120 #640 #1920
$explosion_size = 200 #50
$timer = 50 #50
$missile_speed = 50 # 5
$shrink_rate = 0.5 #0.1

class GameWindow < Gosu::Window
  def initialize
    super($window_width, $window_height, false)
    self.caption = "Space Art"

    @background_image = Gosu::Image.new(self, "media/space_background.jpg", true)
    @player = Player.new(self)
    @player.warp(320, 240)
    @rockets = Array.new
    @explosions = Array.new
    @shoot = false
    
    
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      @player.turn_left
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @player.turn_right
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @player.accelerate
    end
    if button_down? Gosu::KbDown then
      @player.decelerate
    end
    
    if button_down? Gosu::KbSpace then
      if(@shoot == false)
        @shoot = true
      else
        @shoot = false
      end
    end
    
    if (@shoot == true)
      @rockets << @player.fire(self, @player.get_angle, $timer-0)
      @rockets << @player.fire(self, @player.get_angle-25, $timer)
      @rockets << @player.fire(self, @player.get_angle+25, $timer+0)
      @rockets << @player.fire(self, @player.get_angle-50, $timer-0)
      @rockets << @player.fire(self, @player.get_angle+50, $timer+0)
      
    end
    
    @player.move
    
    i = 0
    while i < @rockets.length
      @rockets[i].move
      if @rockets[i].timecheck == true
        @explosions << @rockets[i].explode(self)
        @rockets.delete_at(i)
        i-=1
      end
      i+=1
    end
    
    i = 0
    while i < @explosions.length
      if @explosions[i].shrink == true
        @explosions.delete_at(i)
        i-=1
      end
      i+=1
    end
    
  end

  def draw
    @player.draw
    
    i = 0
    while i < @rockets.length
      @rockets[i].draw
      i+=1
    end
    
    i=0
    while i < @explosions.length
      @explosions[i].draw
      i+= 1
    end
    
    @background_image.draw(0, 0, 0, $window_width/640, $window_height/480);
    
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end
end


class Player
  def initialize(window)
    @image = Gosu::Image.new(window, "media/Starfighter.bmp", false)
    @x = @y = @vel_angle = @vel_x = @vel_y = @angle = 0.0
    @score = 0
  end

  def warp(x, y)
    @x, @y = x, y
  end

  def turn_left
    @vel_angle -= 0.1
  end

  def turn_right
    @vel_angle += 0.1
  end

  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def decelerate
    @vel_x += Gosu::offset_x(@angle, -0.5)
    @vel_y += Gosu::offset_y(@angle, -0.5)
  end
  
  def fire(window, angle, timer)
    return Rocket.new(window, @y, @x, angle, timer)
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @angle += @vel_angle
    @x %= $window_width
    @y %= $window_height

    #@vel_x *= 0.95
    #@vel_y *= 0.95
  end
  
  def get_angle
    return @angle
  end

  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
end


class Rocket
  def initialize(window, y, x, angle, timer)
    @image = Gosu::Image.new(window, "media/rocket.bmp", false)
    @x = x
    @y = y
    @angle = angle
    @vel_x = Gosu::offset_x(@angle, $missile_speed)
    @vel_y = Gosu::offset_y(@angle, $missile_speed)
    @timer = timer
  end

  def move
    @x += @vel_x
    @y += @vel_y
    @x %= $window_width
    @y %= $window_height
    @timer -= 1
  end

  def timecheck
    if @timer <= 0
      return true
    else
      return false
    end
  end
  
  def explode(window)
    return Explosion.new(window, @y, @x, @angle)
    
  end
  
  def draw
    @image.draw_rot(@x, @y, 1, @angle)
  end
  
end

class Explosion
  def initialize(window, y, x, angle)
    @image = Gosu::Image.new(window, "media/explosion.bmp", false)
    @x = x
    @y = y
    @angle = angle
    @size = 1.00
  end
  
  def shrink
    @size -= $shrink_rate
    if @size <= 0
      return true
    end
  end
  
  def draw
    @image.draw(@x-($explosion_size/2)*@size, @y-($explosion_size/2)*@size, 1, @size*($explosion_size/50), @size*($explosion_size/50))
  end
  
end

window = GameWindow.new
window.show






















