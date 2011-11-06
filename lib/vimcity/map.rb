
require_relative 'printer'

class Map

  include Printer

  def initialize(buffer=VIM::Buffer.current)
    @buffer = buffer
    empty_line = "E"*VIM::Window.current.width

    @buffer[1]=empty_line

    (1...VIM::Window.current.height).each do |line|
      @buffer.append(line, empty_line)
    end

    redraw
  end

  def add_building(x,y,type)
  end
end
