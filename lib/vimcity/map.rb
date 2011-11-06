class Map

  attr_accessor :width, :height
  attr_accessor :offset

  include Printer

  def initialize(buffer, width=200,  height=70)
    @buffer = buffer
    @offset = 1
    @width = width
    @height = height

    @buildings_grid = Array.new(@height) { Array.new(@width) { " " } }

    empty_space= " "*@offset + "."*@width 
    @buffer[1]=empty_space

    (0...@height).each do |line|
      @buffer.append(line,empty_space)  
    end

    redraw
  end

  def add_building(building, y, x)
    (y...(y+building.height)).each do |row|
      (x...(x+building.width)).each do |col|
        @buildings_grid[row][col] = [y,x]
      end
    end

    @buildings_grid[y][x] = building
  end

  def destroy_building(y, x)
    print @buildings_grid
    return nil if @buildings_grid[y][x] == " "

    if @buildings_grid[y][x].kind_of? Building
      coords = [y,x]
      building = @buildings_grid[y][x]
    elsif @buildings_grid[y][x].kind_of? Array
      coords = @buildings_grid[y][x]
      building = @buildings_grid[coords[0]][coords[1]]
    end

    if building && coords
      (coords[0]...(coords[0]+building.height)).each do |line|
        @buildings_grid[line] = Array.new(building.width) {" "}
      end
    end

    return building, coords
  end
end
