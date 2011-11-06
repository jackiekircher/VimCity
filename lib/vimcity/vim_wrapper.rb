module VimWrapper

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

    return VIM::Buffer.current
  end
end
