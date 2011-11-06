class AtmoGen < Building

  def initialize
    @symbol = ['o|o',
               '|o|']
    @height = 2
    @width  = 3
    @cost   = 1000
    @capacity = 0
    @workers_required = 30
    @description = "Produces oxygen"
    @bonuses = "Permits to expand your city on the planet, can store 2000 Oxygen units"
  end
  
  def add_to_city(city)
    city.atmogen+=1
    super(city)
  end

end
