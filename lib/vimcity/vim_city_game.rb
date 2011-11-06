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

    @map = Map.new(@main_buffer)

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
      end

      update_status_bar
      wait 50
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
    # load city stuff here when we get to it

    @city = City.new()
  end

  def init_cursor
    c = VIM::evaluate("getpos('.')")
    @last_char = @main_buffer[c[1]][c[2]]
    print_to_buffer(@main_buffer, c[1], c[2], '.')
  end

  def update_status_bar
    VIM::evaluate("genutils#MoveCursorToWindow(1)")
    @city.coins +=1
    @status_buffer[1] = " "*@width
    print_to_buffer(@status_buffer, 1, 0,  "Money: #{@city.coins}c")
    print_to_buffer(@status_buffer, 1, 18, "Population: #{@city.population}")
    VIM::evaluate("genutils#MoveCursorToWindow(2)")
  end

  def update_cursor(x,y)
    c = VIM::evaluate("getpos('.')")
    previous_char = @last_char
    print_to_buffer(@main_buffer, c[1], c[2], previous_char)

    c[1] += y
    c[1] = 1 if c[1] < 1
    c[1] = @map.height+1 if c[1] >= @map.height+1

    c[2] += x
    c[2] = @map.offset if c[2] < @map.offset
    c[2] = @map.width-(@map.offset-1) if c[2] >= (@map.width+@map.offset)

    VIM::evaluate("cursor(#{c[1]},#{c[2]})")
    #VIM::evaluate("setpos('.', [#{c[0]},#{c[1]},#{c[2]},#{c[3]}])")

    @last_char = @main_buffer[c[1]][c[2]]
    print_to_buffer(@main_buffer, c[1], c[2], " ")
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
    while true
      input = wait_for_input(["\t","\r"," "])
      if input == "\t"
        # cycle through buildings
      elsif input == "\r"
        # select building
        return
      else
        return
      end
    end
  end

end
