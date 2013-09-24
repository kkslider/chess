require './chess_piece.rb'

class Board
  attr_accessor :state

  def initialize
    @state = Array.new(8) { Array.new(8) }
    setup
  end


  def setup
    pawn = Pawn.new(self, :black)
    pawn.position = [1, 0]
    @state[1][0] = pawn
  end

  def to_s
    @state.each_with_index do |row, index_r|
      row.each_with_index do |column, index_c|
        square = @state[index_r][index_c]
        if square
          print square
        else
          print " #{@state[index_r][index_c].inspect} "
        end
      end

      puts
    end
  end


end

class HumanPlayer
end

class Game
end