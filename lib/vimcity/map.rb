class Map

  def initialize(height, width)
    @height = height
    @width  = width
    
    buildings = Array.new
  end

  def update
    buildings.each do|building|
      building.update()
    end
  end

end
