class Map

  attr_accessor :width, :height
  attr_accessor :offset

  include Printer

  def initialize(buffer)
    @buffer = buffer
    @offset = 1
    @width = 200
    @height = 70

    empty_space= " "*@offset + "."*@width 
    
    @buffer[1]=empty_space

    (0...@height).each do |line|
      @buffer.append(line,empty_space)  
    end

    redraw
  end

  def add_building(building, y, x)
    VIM::message("@buffer = #{@buffer.name}, current buffer = #{VIM::Buffer.current.name}")
    print_area_to_buffer(VIM::Buffer.current, y, x, building.symbol)
  end
end
