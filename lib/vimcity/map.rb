class Map

  attr_accessor :width, :height
  attr_accessor :offset

  include Printer

  def initialize(buffer)
    @buffer = buffer
    @offset = 1
    @width = 40
    @height = 20

    empty_space= " "*@offset + "."*@width 
    
    @buffer[1]=empty_space

    (0...@height).each do |line|
      @buffer.append(line,empty_space)  
    end

    redraw
  end

  def add_building(x,y,type)
  end
end
