require_relative 'printer'

class VimCityGame
  include VimWrapper
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

    start_game
  end

  def start_game
    Map.new(@main_buffer)

    display_splash
    #wait_for_input("any")
    display_menu

    init_city
    init_status_bar

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
        c = VIM::evaluate("getpos('.')")
        c[2] -= 1
        VIM::evaluate("setpos('.', [#{c[0]},#{c[1]},#{c[2]},#{c[3]}])")
      elsif input == 'j'
        c = VIM::evaluate("getpos('.')")
        c[1] -= 1
        VIM::evaluate("setpos('.', [#{c[0]},#{c[1]},#{c[2]},#{c[3]}])")
      elsif input == 'k'
        c = VIM::evaluate("getpos('.')")
        c[1] += 1
        VIM::evaluate("setpos('.', [#{c[0]},#{c[1]},#{c[2]},#{c[3]}])")
      elsif input == 'l'
        c = VIM::evaluate("getpos('.')")
        c[2] += 1
        VIM::evaluate("setpos('.', [#{c[0]},#{c[1]},#{c[2]},#{c[3]}])")
      end

      blink_cursor
      wait 50
    end
  end

  def display_splash
    @main_buffer[1] = "foo"
    #TODO
  end

  def display_menu
    #TODO
  end

  def init_city
    # load city stuff here when we get to it

    @city = City.new()
  end

  def init_status_bar
    @status_buffer[1] = " "*@width
    print_to_buffer(@status_buffer, 0, 1, "Money: #{@city.coins}c")
    print_to_buffer(@status_buffer, 18, 1, "Population: #{@city.population}")
  end


  private

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

  def blink_cursor
    cursor_pos = VIM::evaluate("getpos('.')")
    prev_char = @cursor_last
    @cursor_last = @main_buffer[cursor_pos[1]][cursor_pos[2]]

    if @cursor_last == '_'
      print_to_buffer(@main_buffer, cursor_pos[2], cursor_pos[3], prev_char)
    else
      print_to_buffer(@main_buffer, cursor_pos[2], cursor_pos[3], '_')
    end

    redraw
  end
end
