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
end
