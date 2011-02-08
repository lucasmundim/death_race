#!/usr/bin/env ruby
require 'rubygems' rescue nil
$LOAD_PATH.unshift File.join(File.expand_path(__FILE__), "..", "..", "lib")
require 'chingu'
require 'opengl'
require 'gosu'
include Gosu

#require_all(File.join(ROOT, "src"))

# module ZOrder
#   Background, Player, UI = *0..2
# end

class Game < Chingu::Window
  def initialize
    super
    self.input = { :escape => :exit } # exits example on Escape

    @player = Player.create(:x => 200, :y => 200)
    @player.input = { 
                      :holding_left => :move_left,
                      :holding_right => :move_right,
                      :holding_up => :accelerate,
                      :holding_down => :reverse
                    }
  end
  
  def update
    super
    #@player.move
  end
  
  
  def draw
    super
    fill(Color.new(0xFF61442B))
  end
    
  # def update
  #     super
  #     self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  #   end
end

class Player < Chingu::GameObject  
  traits :velocity
  trait :bounding_box, :scale => 1 #, :debug => true
  trait :animation, :delay => 200
  
  def setup
    #@image = Image["whitecar.png"]
    
    #self.velocity_x = 1       # move constantly to the right
    #self.acceleration_x = 0.1 # gravity is basicly a downwards acceleration
    
    # Load the full animation from tile-file media/droid.bmp
    @animation = Chingu::Animation.new(:file => "redcar.png", :width => 66, :height => 65)
    
    @animation.frame_names = { :redcar => 12..12 }
    @frame_name = :redcar
    
    @x = @y = 100 
    @vel_x = @vel_y = @angle = 0.0
  end
  
  def update
    # Move the animation forward by fetching the next frame and putting it into @image
    # @image is drawn by default by GameObject#draw
    @image = @animation[@frame_name].image
    
    #
    # If droid stands still, use the scanning animation
    #
    #@frame_name = :redcar if @x == @last_x && @y == @last_y
  end
  
  def move_left
    @angle -= 3 
  end

  def move_right
    @angle += 3
  end
  
  def accelerate
    @vel_x += Gosu::offset_x(@angle, 0.5)
    @vel_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def reverse
    @vel_x -= Gosu::offset_x(@angle, 0.5)
    @vel_y -= Gosu::offset_y(@angle, 0.5)
  end
  
  def move(x = nil, y = nil)
    @x += @vel_x
    @y += @vel_y
    @x %= 800
    @y %= 600
    
    @vel_x *= 0.95
    @vel_y *= 0.95
  end
end


Game.new.show