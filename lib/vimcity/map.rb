class Map

  attr_accessor :width, :height
  attr_accessor :offset

  include Printer

  def initialize(buffer, width=200,  height=70)
    @buffer = buffer
    @offset = 1
    @width = width
    @height = height

    empty_space= " "*@offset + "."*@width 
    
    @buffer[1]=empty_space

    (0...@height).each do |line|
      @buffer.append(line,empty_space)  
    end

    redraw
  end

end
