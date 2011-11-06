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
      clear_screen
      VIM::message("Your window is too small, please resize it to at least 70x20")
      VIM::command('q!')
    else
      start_game
    end
  end

  def start_game
    Map.new(@buffer)

    display_splash
    wait_for_input("any")
    display_menu
    
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
    clear_screen
    print_to_screen(1,1,"foo")
    #TODO
  end

  def display_menu
    clear_screen
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
