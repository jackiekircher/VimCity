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

    @window = VIM::Window.current
    @height = @window.height
    @width  = @window.width

    @map = Map.new(@main_buffer)
    start_game
  end

  def start_game

    display_splash
    #wait_for_input("any")
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
    @status_buffer[1] = " "*@width
    print_to_buffer(@status_buffer, 1, 0,  "Money: #{@city.coins}c")
    print_to_buffer(@status_buffer, 1, 18, "Population: #{@city.population}")
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

  def wait_for_input(args)
    valid_input = args.split(",")
    if valid_input.first == "any"
      VIM::evaluate("getchar()")
    else
      while true
        break if valid_input.include?(VIM::evaluate("getchar()"))
      end
    end

    return
  end

end
