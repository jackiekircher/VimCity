class Map

  def initialize(buffer=VIM::Buffer.current)
    @buffer = buffer
    for i in 1..VIM::Window.current.height
      
    end
  end

  def add_building(x,y,type)
    building = BuildingFactory.new(type)
    building.add_to_map(buffer, x, y height, size)
 end
end
