module Printer

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

end
