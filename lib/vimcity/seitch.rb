class Seitch < Building

  def initialize
    @symbol = ['H']
    @height = 1
    @width  = 1
    @cost   = 100
    @capacity = 10
    @workers_required = 0
    @description = "A simple house"
    @bonuses = "none"
  end

  def remove_from_city(city)
    super(city)
    city.population = city.population_cap if city.population > city.population_cap
  end

end
