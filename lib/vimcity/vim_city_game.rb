require_relative 'vim_wrapper'
require_relative 'printer'

class VimCityGame
  include VimWrapper
  include Printer

  def initialize(buffer=VIM::Buffer.current)
    @buffer = buffer
    @window = VIM::Window.current
    @height = @window.height
    @width  = @window.width

    if @height < 20 || @width < 70
      VIM::message("Your window is too small, please resize it to at least 70x20")
      VIM::command('q!')
    else
      start_game
    end
  end

  def start_game
    display_splash
    wait_for_input("any")
    display_menu

    # start game loop
    while true
      input = get_char(0)

      if input == 'q' || input == '\x1b' #<ESC>
        response = prompt("Are you sure want to quit? (y/N) ")
        if response == 'y'
          quit
          return
        end
        redraw
      end

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
