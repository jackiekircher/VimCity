class Starport < Building

  def initialize
    @symbol = ['\ /',
               ' = ',
               '/ \\']
    @height = 3
    @width  = 3
    @cost   = 2000
    @capacity = 0
    @workers_required = 40
    @description = "Allows for interstellar travel"
    @bonuses = "Boosts your city's population"
  end
  
  def add_to_city(city)
    city.people_per_second+=1
    super(city)
  end

end
