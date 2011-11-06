class Map

  include Printer

  def initialize(buffer)
    @buffer = buffer
    @map_offset = 5
    @map_width = 40
    @map_height = 20

    empty_space= " "*@map_offset + "O"*@map_width 
    
    @buffer[1]=empty_space

    (0...@map_height).each do |line|
      @buffer.append(line,empty_space)  
    end

    redraw
  end

  def add_building(x,y,type)
  end
end
