require_relative 'vim_wrapper'
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
    display_splash
    #wait_for_input("any")
    display_menu

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
      end

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

  def init_status_bar
    @status_buffer[1] = " "*@width
    print_to_buffer(@status_buffer, 0, 1, "Money: 0c")
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

end
