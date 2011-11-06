class Starport < Building

  def initialize
    @symbol = ['\ /',
               ' = ',
               '/ \\']
    @height = 3
    @width  = 3
    @cost   = 2000
    @capacity = "N/A"
    @description = "Allows for interstellar travel"
    @bonuses = "Boosts your city's population"
  end

end
