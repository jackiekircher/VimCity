require_relative 'vim_wrapper'

module Printer
  include VimWrapper

  def cache_area(buffer, y, height, x, width)
    chars = []
    (y...y+height).each do |row|
      chars << buffer[row][x,width]
    end

    return chars
  end

  def print_to_buffer(buffer, y, x, str)
    y = (y < 1) ? 1 : y
    x = (x < 0) ? 0 : x

    new_line = buffer[y]
    new_line[x, str.length] = str
    buffer[y] = new_line
    redraw

    return str.length
  end

  def print_to_status_buffer(buffer, y, x, str)
    VIM::evaluate("genutils#MoveCursorToWindow(1)")
    @status_buffer[3] = " "*@width
    print_to_buffer(buffer, y, x, str)
    VIM::evaluate("genutils#MoveCursorToWindow(2)")
  end

  def print_area_to_buffer(buffer, y, x, chars)
    height = chars.size
    width  = chars.first.size

    y = (y < 1) ? 1 : y
    x = (x < 0) ? 0 : x

    chars.each do |row|
      new_line = buffer[y]
      new_line[x, row.length] = row
      buffer[y] = new_line
      y += 1
    end

    redraw

    return width
  end

  def clear_buffer(buffer)
    (1...buffer.count).each do |row|
      buffer[row] = " "*buffer[row].length
    end
  end
end
