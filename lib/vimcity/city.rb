class City

  attr_accessor :coins, :population, :population_cap, :people_per_second, :money_per_second, :oxygen, :atmogen
  attr_accessor :free_workers
 
  def initialize(coins=10000, population=0)
    @coins = coins
    @population = population
    @population_cap = 0
    @free_workers = population
    @money_per_second = 0
    @people_per_second = 0
    @oxygen = 1000
    @atmogen = 0
    @happiness = 1
  end

  def update
    @coins+=@money_per_second*2/12.5

    if @population < @population_cap 
	@population+=@people_per_second/12.5*@happiness
	@free_workers+=@people_per_second/12.5*@happiness
    end

    @oxygen -= @population/12.5
    
    @coins -= @atmogen*2/12.5 if @oxygen < @atmogen.round*2000

    @oxygen += @atmogen*80/12.5 if @oxygen < @atmogen * 2000
    @oxygen=0 if @oxygen < 0

    #@happiness-=0.001
    @happiness = 0.001 if @happiness < 0
  end

end
