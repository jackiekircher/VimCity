require_relative 'vim_wrapper'

module Printer
  include VimWrapper

  def print_to_buffer(buffer, y, x, str)
    x = (x < 0) ? 0 : x
    y = (y < 1) ? 1 : y

    new_line = buffer[y]
    new_line[x, str.length] = str
    buffer[y] = new_line
    redraw

    return str.length
  end

end
