class City

  attr_accessor :coins, :population

  def initialize(coins=1000, population=100)
    @coins = coins
    @population = population
    @population_cap = 0
    @money_per_second = 1
    @people_per_second = 1
    @happiness = 1
  end

  def update
    @coins+=@money_per_second
    if @population < @population_cap 
	@population+=@people_per_second*@happiness
    	@population=@population.round
    end
    @happiness-=0.001
    @happiness = 0.001 if @happiness < 0
  end

end
