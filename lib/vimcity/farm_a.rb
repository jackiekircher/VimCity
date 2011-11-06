class FarmA < Building

  def initialize
    @symbol = ['~~~~v~',
               '~V~~~ ',
               '~v~~V~']
    @height = 3
    @width  = 6
    @cost   = 1000
    @capacity = 0
    @workers_required = 10
    @description = "Produces purple grass, a desirable commodity"
    @bonuses = "Goods sell for 2c a worker, maximum of 20"
  end

  def add_to_city(city)
    city.money_per_second+=1
    super(city)
  end

  def remove_from_city(city)
    city.money_per_second-=1
    super(city)
  end

end
