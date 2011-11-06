class FarmA < Building

  def initialize
    @symbol = ['~~~~v~',
               '~V~~~',
               '~v~~V~']
    @height = 3
    @width  = 6
    @cost   = 1000
    @capacity = "N/A"
    @description = "Produces purple grass, a desirable commodity"
    @bonuses = "Goods sell for 2c a worker, maximum of 20"
  end

end
