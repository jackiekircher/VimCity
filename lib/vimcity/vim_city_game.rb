class VimCityGame

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
    clear_screen
    #TODO
  end

  def display_menu
    clear_screen
    #TODO
  end


  private

  def print_to_screen(x, y, str)
    x = (x < 0) ? 0 : x
    y = (y < 1) ? 1 : y

    new_line = @buffer[y]
    new_line[x, str.length] = str
    @buffer[y] = new_line
    redraw

    return str.length
  end

  def clear_screen
    VIM::evaluate("genutils#OptClearBuffer()")
    blank_line = " "*@width
    @buffer[1] = blank_line
    (1...@height).each do |line|
      @buffer.append(line, blank_line)
    end
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

  def redraw
    VIM::command("redraw")
  end

  def get_char(timeout)
    char = VIM::evaluate("getchar(#{timeout})")
    return nil if char.nil?

    char.chr
  end

  def prompt(question)
    return VIM::evaluate("input('#{question}')").chomp
  end

  def wait(time)
    VIM::command("sleep #{time}m")
  end

  def quit
    VIM::command('q!')
  end
end
