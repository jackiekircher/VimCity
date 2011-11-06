class Building

  attr_reader :symbol
  attr_reader :height
  attr_reader :width
  attr_reader :cost
  attr_reader :capacity
  attr_reader :description
  attr_reader :bonuses
  attr_reader :workers_required

  BUILDING_TYPES = [:Seitch, :FarmA, :Starport, :AtmoGen]

  def add_to_city(city)
    city.coins -= self.cost
    city.population_cap += self.capacity
    city.free_workers-= self.workers_required
  end

  def remove_from_city(city)
    city.coins += self.cost/3
    city.population_cap -= self.capacity
    city.free_workers+= self.workers_required
  end
end
