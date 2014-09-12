module VimWrapper

  def get_cursor_pos
    return VIM::evaluate("getpos('.')")[1,2]
  end

  def set_cursor_pos(y,x)
    return VIM::evaluate("cursor(#{y},#{x})")
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

  def popup_buffer(name, width=0)
    VIM::command('vsplit')
    VIM::evaluate("genutils#MoveCursorToWindow(3)")
    VIM::command("silent e #{name}")
    VIM::command("vertical resize #{width}") if width > 0
    VIM::command("setlocal noreadonly")
    VIM::command("setlocal nonumber")
    VIM::command("setlocal noswapfile")
    VIM::command("setlocal buftype=nofile")
    VIM::command("setlocal nolist")

    ##
    # fill up the new buffer so it can be drawn on
    buffer = VIM::Buffer.current
    window = VIM::Window.current
    (1...window.height).each do |line|
      buffer.append(line, " "*window.width)
    end

    return buffer, window
  end
end
