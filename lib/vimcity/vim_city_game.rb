require_relative 'printer'

class VimCityGame
  include Printer

  def initialize
    (0...VIM::Buffer.count).each do |buffer|
      buffer = VIM::Buffer[buffer]
      buffer_name = (buffer.name) ? buffer.name.split("/").last : ""
      @main_buffer = buffer if buffer_name == "VimCity"
      @status_buffer = buffer if buffer_name == "Welcome_to_VimCity"
    end

    (0...VIM::Window.count).each do |w|
      window = VIM::Window[w]
      if window.buffer == @main_buffer
        @main_window = window
        @main_window_n = w
      end
      if window.buffer == @status_buffer
        @status = window
        @status_window_n = w
      end
    end

    @height = @main_window.height
    @width  = @main_window.width

    @map = Map.new(@main_buffer, 120, 300)
    @insert_mode = false
    @current_building = nil


    VIM::evaluate("genutils#MoveCursorToWindow(2)") #oh hey, 2 is the lower panel ./sigh
    start_game
  end

  def start_game

    display_splash
    display_menu

    init_city
    update_status_bar

    init_cursor

    # start game loop
    while true
      input = get_char(0)

      if input == 'q' || input == '\x1b' #<ESC>
        response = prompt("Are you sure want to quit? (y/N) ")
        if response == 'y'
          quit #quit main buffer
          quit #quit status buffer
          return
        end
        redraw
      elsif input == 'h'
        update_cursor(-1,0)
      elsif input == 'j'
        update_cursor(0,1)
      elsif input == 'k'
        update_cursor(0,-1)
      elsif input == 'l'
        update_cursor(1,0)

      elsif input == 'i'
        building_menu


      elsif input == ' '
        if @insert_mode
          reset_cursor
          @current_building = false
          @insert_mode = false
        end

      elsif input == 'p'
        add_building

      elsif input == 'x'
        destroy_building
      end

      update_status_bar
      @city.update()
      wait 80
    end
  end

  def display_splash
    #TODO
  end

  def display_menu
    #TODO
  end


  private

  ##
  # :section: init

  def init_city
    #load city stuff here when we get to it
    @city = City.new(5000, 100)

    house1 = Seitch.new()
    house1.add_to_city(@city)
    @map.add_building(house1,34, 24)
    print_area_to_buffer(@main_buffer, 34, 24, house1.symbol)
    house2 = Seitch.new()
    house2.add_to_city(@city)
    @map.add_building(house2,34, 24)
    print_area_to_buffer(@main_buffer, 35, 24, house2.symbol)
    house3 = Seitch.new()
    house3.add_to_city(@city)
    @map.add_building(house3,34, 24)
    print_area_to_buffer(@main_buffer, 34, 25, house3.symbol)
    starport = Starport.new()
    starport .add_to_city(@city)
    @map.add_building(starport,30, 30)
    print_area_to_buffer(@main_buffer, 30, 30, starport.symbol)
    farm = FarmA.new()
    farm .add_to_city(@city)
    @map.add_building(farm ,37, 24)
    print_area_to_buffer(@main_buffer, 37, 24, farm.symbol)
    atmo = AtmoGen.new()
    atmo .add_to_city(@city)
    @map.add_building(atmo ,38, 26)
    print_area_to_buffer(@main_buffer, 34, 30, atmo .symbol)
  end

  def init_cursor
    @cursor = [" "] #use an array for area cursors
    c = get_cursor_pos
    @last_chars = cache_area(@main_buffer, c[0], 1, c[1], 1)
    print_area_to_buffer(@main_buffer, c[0], c[1], @cursor)
  end

  def update_status_bar
    VIM::evaluate("genutils#MoveCursorToWindow(1)")
    @status_buffer[1] = " "*@width
    print_to_buffer(@status_buffer, 1, 0,
                    "Money: #{@city.coins.round}")
    print_to_buffer(@status_buffer, 1, 18,
                    "Population: #{@city.population.round} / #{@city.population_cap}")
    print_to_buffer(@status_buffer, 1, 40,
                    "Free Workers: #{@city.free_workers.round}")
    print_to_buffer(@status_buffer, 1, 87,
                    "Oxygen: #{@city.oxygen.round}")
    VIM::evaluate("genutils#MoveCursorToWindow(2)")
  end

  def update_cursor(x,y)
    c = get_cursor_pos

    cursor_height = @cursor.size
    cursor_width  = @cursor.first.size

    print_area_to_buffer(@main_buffer, c[0], c[1], @last_chars)

    c[0] += y
    c[0] = 1 if c[0] < 1
    c[0] = @map.height+2-cursor_height if c[0]+cursor_height >= @map.height+2

    c[1] += x
    c[1] = @map.offset if c[1] < @map.offset
    c[1] = @map.width-(@map.offset)-cursor_width+2 if c[1]+cursor_width >= (@map.width+@map.offset+1)

    set_cursor_pos(c[0], c[1])

    @last_chars = cache_area(@main_buffer,
                             c[0], cursor_height,
                             c[1], cursor_width)
    print_area_to_buffer(@main_buffer, c[0], c[1], @cursor)
  end

  def reset_cursor
    c = get_cursor_pos
    print_area_to_buffer(@main_buffer, c[0], c[1], @last_chars)
    @last_chars = cache_area(@main_buffer,
                             c[0], 1,
                             c[1], 1)
    @cursor = [" "]
    print_area_to_buffer(@main_buffer, c[0], c[1], @cursor)

    return
  end

  def wait_for_input(valid_input)
    return if Array.new(valid_input).empty?

    if valid_input.include?("any")
      char = VIM::evaluate("getchar()")
    else
      while true
        char = VIM::evaluate("getchar()")
        break if valid_input.include?(char.chr)
      end
    end

    return char.chr
  end

  def building_menu
    
    buffer = popup_buffer('new_building', 44)

    w = VIM::Window.current
    (1...w.height).each do |line|
      buffer.append(line, " "*w.width)
    end
    buffer[1]  = "--------------------------------------------"
    buffer[2]  = "--- press tab to view all building types ---"
    buffer[3]  = "--------------------------------------------"
    buffer[4]  = "---        press space to cancel         ---"
    buffer[5]  = "--------------------------------------------"


    buildings = Building::BUILDING_TYPES
    select = 0

    while true
      #building preview
      building = Kernel.const_get(buildings[select]).new
      buffer[w.height] = "--------------------------------------------"
      buffer[w.height-3] = "  Bonuses: #{building.bonuses}"
      buffer[w.height-4] = "  Capacity: #{building.capacity}"
      buffer[w.height-5] = "  Cost: #{building.cost}"
      buffer[w.height-8] = "  #{building.description}"

      print_area_to_buffer(buffer,
                           (w.height/2)-(2+building.height/2),
                           (w.width/2)-(building.width/2),
                           building.symbol)
      redraw

      input = wait_for_input(["\t","\r"," ","q"])
      if input == "\t"
        # cycle through buildings
        select += 1
        select  = 0 if select > (buildings.size - 1)
        (6...(w.height-1)).each do |row|
          buffer[row] = " "*w.width
        end
      elsif input == "\r"
        # select building
        quit

        #c = VIM::Window.current.cursor
        c = get_cursor_pos
        print_area_to_buffer(@main_buffer, c[0], c[1], @last_chars)
        @last_chars = cache_area(@main_buffer,
                                 c[0], building.height,
                                 c[1], building.width)
        @cursor = building.symbol
        print_area_to_buffer(@main_buffer, c[0], c[1], @cursor)

        @insert_mode = true
        @current_building = building
        return
      else
        break
      end
    end

    quit
  end

  def add_building

    if @insert_mode && @current_building
      failure = false
      @last_chars.each do |row|
        failure = true if row != "."*@current_building.width
      end

      # warn and return if failure
      return if failure
      # warn and return if ont enough coins
      return if @city.coins < @current_building.cost

      # for deleting buildings
      # c = get_cursor_pos
      @current_building.add_to_city(@city)
      c = get_cursor_pos
      @map.add_building(@current_building, c[0], c[1])
      @last_chars = @current_building.symbol
    end
  end
    
  def destroy_building
    c = get_cursor_pos
    building, building_coords = @map.destroy_building(c[0], c[1])
    return if building.nil?

    blank_building =Array.new(building.height) { "."*building.width }
    print_area_to_buffer(@main_buffer,
                         building_coords[0],
                         building_coords[1],
                         blank_building)
    @last_chars = cache_area(@main_buffer,
                             c[0], building.height,
                             c[1], building.width)
    building.remove_from_city(@city)
  end
end

