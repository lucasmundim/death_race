#!/usr/bin/env ruby
begin
  require "rubygems"
  require "bundler"
rescue LoadError
  raise "Could not load the bundler gem. Install it with `gem install bundler`."
end

if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.24")
  raise RuntimeError, "Your bundler version is too old." +
   "Run `gem install bundler` to upgrade."
end

begin
  # Set up load paths for all bundled gems
  ENV["BUNDLE_GEMFILE"] = File.expand_path("../../Gemfile", __FILE__)
  Bundler.setup
  Bundler.require
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run `bundle install`?"
end

class Game < Chingu::Window
  def initialize
    super
    self.input = { :escape => :exit } # exits example on Escape

    @player = Player.create
    @player.input = { 
                      :holding_left => :move_left,
                      :holding_right => :move_right,
                      :holding_up => :accelerate,
                      :holding_down => :reverse
                    }
    @track = Track.create
    @track.input = { 
                      :holding_left => :move_left,
                      :holding_right => :move_right,
                      :holding_up => :move_top,
                      :holding_down => :move_down
                    }
    @track.player = @player
  end
  
  def update
    super
    #@player.move
  end
  
  
  def draw
    super
    fill(Gosu::Color.new(0xFF61442B))
  end
    
  # def update
  #     super
  #     self.caption = "FPS: #{self.fps} milliseconds_since_last_tick: #{self.milliseconds_since_last_tick}"
  #   end
end

class Track < Chingu::GameObject
  #trait :viewport
  trait :velocity
  attr_accessor :player
  
  def initialize
    super
    self.image = Gosu::Image["track1.png"]
    #self.viewport.lag = 0                           # 0 = no lag, 0.99 = a lot of lag.
    #self.viewport.game_area = [0, 0, 1000, 1000]    # Viewport restrictions, full "game world/map/area"
    self.zorder = 1
    #self.max_velocity = [0.1, 0.1]
  end
  
  def update
    super
    #self.viewport.center_around(player)
  end
  
  def draw
    super
  end
  
  def move_left
    #@x += 3 
  end

  def move_right
    #@x -= 3
  end
  
  # def move(x=nil, y=nil)
  #     self.velocity_x *= 0.95
  #     self.velocity_y *= 0.95
  #   end
  
  def move_top
    self.velocity_x -= Gosu::offset_x(self.player.angle, 0.5)
    self.velocity_y -= Gosu::offset_y(self.player.angle, 0.5)
  end
  
  def move_down
    self.velocity_x += Gosu::offset_x(self.player.angle, 0.5)
    self.velocity_y += Gosu::offset_y(self.player.angle, 0.5)
  end
end

class Player < Chingu::GameObject  
  #traits :velocity
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
    
    #@x = @y = 100 
    @x = 800/2
    @y = 600/2
    @angle = 0.0
    self.zorder = 10
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
    #self.velocity_x += Gosu::offset_x(@angle, 0.5)
    #self.velocity_y += Gosu::offset_y(@angle, 0.5)
  end
  
  def reverse
    #self.velocity_x -= Gosu::offset_x(@angle, 0.5)
    #self.velocity_y -= Gosu::offset_y(@angle, 0.5)
  end
  
  def move(x = nil, y = nil)
    @x += x
    @y += y
    @x %= 800
    @y %= 600
    
    #self.velocity_x *= 0.95
    #self.velocity_y *= 0.95
  end
end


Game.new.show