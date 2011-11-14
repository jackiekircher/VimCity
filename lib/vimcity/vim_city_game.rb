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

    @insert_mode = false
    @current_building = nil

    VIM::evaluate("genutils#MoveCursorToWindow(2)") #oh hey, 2 is the lower panel ./sigh

    # here we go!
    start_game
  end

  
  private

  ##
  # The main game loop
  def start_game

    display_splash

    @map = Map.new(@main_buffer, 120, 300)
    init_city
    init_status_bar
    update_status_bar

    init_cursor

    # start game loop
    while true
      input = get_char(0)

      # quit game
      if input == 'q' || input == '\x1b' #<ESC>
        response = prompt("Are you sure want to quit? (y/N) ")
        if response == 'y'
          quit #quit main buffer
          quit #quit status buffer
          return
        end

      # help menu
      elsif input == "?"
        help_menu

      # cursor movement
      elsif input == 'h'
        update_cursor(-1,0)
      elsif input == 'j'
        update_cursor(0,1)
      elsif input == 'k'
        update_cursor(0,-1)
      elsif input == 'l'
        update_cursor(1,0)

      # insert mode - place buildings
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

      # destroy buildings
      elsif input == 'x'
        destroy_building
      end

      update_status_bar
      @city.update
      wait 80
    end
  end

  def display_splash

    @main_buffer[1] = " "*(VIM::Window.current.width-1)
    (1...VIM::Window.current.height).each do |i|
      @main_buffer.append(i, " "*(VIM::Window.current.width-1))
    end

    ss = File.open("#{Dir.pwd}/lib/menu.txt")
    ss_chars = []
    ss.each_line{|line| ss_chars << line}
    print_area_to_buffer(@main_buffer,
                         @height/2 - 9,
                         @width/2 - 51,
                         ss_chars)

    input = wait_for_input(["any"])

    if input == 'q'
      quit
    else
      clear_buffer(@main_buffer)
    end
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

  ##
  # :section: initialization

  ##
  # Create a starting city with the basics
  def init_city

    @city = City.new(5900, 70)

    house = Seitch.new()
    init_building(house,34,24)
    init_building(house,35,24)
    init_building(house,34,25)
    init_building(house,33,36)
    init_building(house,34,37)
    init_building(house,35,37)
    init_building(house,36,37)
    init_building(house,37,34)

    starport = Starport.new()
    init_building(starport ,30,30)

    farm = FarmA.new()
    init_building(farm ,37,24)

    atmo = AtmoGen.new()
    init_building(atmo ,34,30)
  end

  def init_building(building, y, x)
    building.add_to_city(@city)
    @map.add_building(building, y, x)
    print_area_to_buffer(@main_buffer, y, x, building.symbol)
  end

  def init_cursor
    @cursor = [" "] #use an array for area cursors
    c = get_cursor_pos
    @last_chars = cache_area(@main_buffer, c[0], 1, c[1], 1)
    print_area_to_buffer(@main_buffer, c[0], c[1], @cursor)
  end

  def init_status_bar
    VIM::evaluate("genutils#MoveCursorToWindow(1)")
    @status_buffer[1] = " "*@width
    @status_buffer.append(1, " "*@width)
    @status_buffer.append(2, " "*@width)
    VIM::evaluate("genutils#MoveCursorToWindow(2)")
  end

  ##
  # :section: event updates 

  ##
  # updates the top status bar with current city stats and/or warning messages
  def update_status_bar
    VIM::evaluate("genutils#MoveCursorToWindow(1)")
    @status_buffer[1] = " "*@width
    print_to_buffer(@status_buffer, 1, 0,  "Money: #{@city.coins.round}")
    print_to_buffer(@status_buffer, 1, 18, "Population: #{@city.population.round} / #{@city.population_cap}")
    print_to_buffer(@status_buffer, 1, 40, "Free people: #{@city.free_workers.round}")
    print_to_buffer(@status_buffer, 1, 60, "Oxygen: #{@city.oxygen.round}")
    print_to_buffer(@status_buffer, 2, 90, "- Press '?' for commands -")
    VIM::evaluate("genutils#MoveCursorToWindow(2)")
  end

  ##
  # copies to contents of @last_chars to the screen where the cursor is
  # and copies the contents of the map where the cursor is moving to
  # @last_chars, this supports variable-sized cursors
  def update_cursor(x,y)
    c = get_cursor_pos

    cursor_height = @cursor.size
    cursor_width  = @cursor.first.size

    print_area_to_buffer(@main_buffer, c[0], c[1], @last_chars)

    # we don't want the cursor going off the buffer, so we need to adjust
    # for offset
    c[0] += y
    c[0] = 1 if c[0] < 1
    c[0] = (@map.height + 2 - cursor_height) if c[0]+cursor_height >= (@map.height + 2)

    c[1] += x
    c[1] = @map.offset if c[1] < @map.offset
    c[1] = (@map.width + 2 - (@map.offset) - cursor_width) if c[1]+cursor_width >= (@map.width + @map.offset + 1)

    set_cursor_pos(c[0], c[1])

    @last_chars = cache_area(@main_buffer,
                             c[0], cursor_height,
                             c[1], cursor_width)

    print_area_to_buffer(@main_buffer, c[0], c[1], @cursor)
  end

  ##
  # return the cursor to the base character
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

  def add_building
    return unless @insert_mode && @current_building

    failure = false
    @last_chars.each do |row|
      failure = true if row != "."*@current_building.width
    end

    # warn and return if failure
    if failure
      print_to_status_buffer(@status_buffer, 3, 0,
                             "You cannot place that building there!")
      return
    end

    # warn and return if not enough coins
    if @city.coins < @current_building.cost
      print_to_status_buffer(@status_buffer, 3, 0,
                             "You require more coins to construct that building.")
      return
    end

    # warn and return if not enough free workers
    if @city.free_workers - @current_building.workers_required < 0
      print_to_status_buffer(@status_buffer, 3, 0,
                             "You do not have the citizens to optimally operate that facility!")
      return
    end

    @current_building.add_to_city(@city)
    c = get_cursor_pos
    @map.add_building(@current_building, c[0], c[1])
    @last_chars = @current_building.symbol
  end
    
  def destroy_building
    c = get_cursor_pos
    building, building_coords = @map.destroy_building(c[0], c[1])
    print "#{building}"
    return if building.nil?

    blank_building = Array.new(building.height) { "."*building.width }
    print_area_to_buffer(@main_buffer,
                         building_coords[0],
                         building_coords[1],
                         blank_building)
    @last_chars = cache_area(@main_buffer,
                             c[0], building.height,
                             c[1], building.width)
    building.remove_from_city(@city)
  end


  ##
  # :section: menus

  ##
  # this menu shows a preview and description of the available buildings
  def building_menu
    
    buffer, window = popup_buffer('new_building', 44)

    buffer[1] = "--------------------------------------------"
    buffer[2] = "--- press tab to view all building types ---"
    buffer[3] = "--------------------------------------------"
    buffer[4] = "---        press space to cancel         ---"
    buffer[5] = "--------------------------------------------"

    buildings = Building::BUILDING_TYPES
    select = 0

    while true
      building = Kernel.const_get(buildings[select]).new
      buffer[window.height] = "--------------------------------------------"
      buffer[window.height-2] = "  Bonuses: #{building.bonuses}"
      buffer[window.height-3] = "  Workers Required: #{building.workers_required}"
      buffer[window.height-4] = "  Capacity: #{building.capacity}"
      buffer[window.height-5] = "  Cost: #{building.cost}"
      buffer[window.height-8] = "  #{building.description}"

      print_area_to_buffer(buffer,
                           (window.height/2) - (2 + building.height/2),
                           (window.width/2) - (building.width/2),
                           building.symbol)
      redraw

      # use our own mini event loop while menu is open
      input = wait_for_input(["\t","\r"," ","q"])
      if input == "\t"
        # cycle through buildings
        select += 1
        select  = 0 if select > (buildings.size - 1)
        (6...(window.height - 1)).each do |row|
          buffer[row] = " "*window.width
        end

      elsif input == "\r"
        # select building
        quit

        # set cursor to selected building
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

  ##
  # this menu lists the available game commands
  def help_menu

    buffer, window = popup_buffer('help', 44)

    buffer[1]  = "--------------------------------------------"
    buffer[2]  = "---             VimCity Help             ---"
    buffer[3]  = "--------------------------------------------"

    buffer[6]  = " -- while in command mode (default) --      "
    buffer[7]  = "   ? : bring up help menu                   "
    buffer[8]  = "   h,j,k,l : move cursor                    "
    buffer[9]  = "   i : place building (enter insert mode)   "
    buffer[10] = "   x : destroy building underneath          "
    buffer[11] = "       cursor                               "
    buffer[12] = "   q : quit game                            "

    buffer[14] = " -- while in insert mode --                 "
    buffer[15] = "   p : place building                       "
    buffer[16] = "   space : return to command mode           "

    buffer[window.height-2] = "--------------------------------------------"
    buffer[window.height-1] = "---       press any key to return        ---"
    buffer[window.height]   = "--------------------------------------------"

    redraw
    wait_for_input(["any"])
    quit
  end
end

