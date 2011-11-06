class Building

  attr_reader :symbol
  attr_reader :height
  attr_reader :width
  attr_reader :cost
  attr_reader :capacity
  attr_reader :description
  attr_reader :bonuses

  BUILDING_TYPES = [:Seitch, :FarmA, :Starport]
end
