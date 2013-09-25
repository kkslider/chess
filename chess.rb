require './chess_piece.rb'

class Board
  attr_accessor :state

  BLACK_ROW_PAWNS = 1
  WHITE_ROW_PAWNS = 6

  def initialize
    @state = Array.new(8) { Array.new(8) }
    setup
  end

  def setup
    setup_black_pieces
    setup_white_pieces
  end

  def setup_pawns(row)
    color = (row == BLACK_ROW_PAWNS) ? :black : :white
    @state[row].each_with_index do |square, column|
      @state[row][column] = Pawn.new(self, color, [row, column])
    end
  end

  def setup_black_pieces
    setup_pawns(BLACK_ROW_PAWNS)
    @state[0][0] = Rook.new(self, :black, [0, 0])
    @state[0][1] = Knight.new(self, :black, [0, 1])
    @state[0][2] = Bishop.new(self, :black, [0, 2])
    @state[0][3] = Queen.new(self, :black, [0, 3])
    @state[0][4] = King.new(self, :black, [0, 4])
    @state[0][5] = Bishop.new(self, :black, [0, 5])
    @state[0][6] = Knight.new(self, :black, [0, 6])
    @state[0][7] = Rook.new(self, :black, [0, 7])
  end

  def setup_white_pieces
    setup_pawns(WHITE_ROW_PAWNS)
    @state[7][0] = Rook.new(self, :white, [7, 0])
    @state[7][1] = Knight.new(self, :white, [7, 1])
    @state[7][2] = Bishop.new(self, :white, [7, 2])
    @state[7][3] = Queen.new(self, :white, [7, 3])
    @state[7][4] = King.new(self, :white, [7, 4])
    @state[7][5] = Bishop.new(self, :white, [7, 5])
    @state[7][6] = Knight.new(self, :white, [7, 6])
    @state[7][7] = Rook.new(self, :white, [7, 7])
  end


  def to_s
    puts "   0  1  2  3  4  5  6  7  "
    @state.each_with_index do |row, index_r|
      print index_r.to_s + " "
      row.each_with_index do |column, index_c|
        square = @state[index_r][index_c]
        if square
          print square
        else
          print " - "
        end
      end

      puts
    end

    ""
  end

end

class HumanPlayer
  attr_reader :color

  def initialize(color)
    @color = color
  end

  def to_s
    @color == :white ? "Player 1 (W)" : "Player 2 (B)"
  end
end

class ChessGame
  attr_accessor :current_player

  def play
    board = Board.new
    print board
    player_1 = HumanPlayer.new(:white)
    player_2 = HumanPlayer.new(:black)

    puts "Welcome to Chess!"
    puts "Player one (white) will go first."
    puts "Player two (black) will go second."
    run_game(board, player_1, player_2)
  end

  def run_game(board, player_1, player_2)
    game_over = false
    @current_player = player_1
    until game_over


      puts "#{current_player}, your turn. Enter position of the piece you " +
        "would like to move. e.g. '1 2' for position at row 2, column 3"
      begin
        move_from = gets.chomp.split.map(&:to_i) #[1, 2]
        piece = board.state[move_from[0]][move_from[1]]
      rescue IndexError
        puts "please re-enter"
        retry
      end
      next if !piece || piece.color != @current_player.color

      puts "#{current_player}, Enter the position you would like to move " +
      "the #{piece.class}."
      begin
        move_to = gets.chomp.split.map(&:to_i)

        if piece.valid_moves.include?(move_to)
          piece.position = move_to
          board.state[move_to[0]][move_to[1]] = piece
          board.state[move_from[0]][move_from[1]] = nil

          if piece.class == Pawn
            piece.initial_move = false
          end
          print board
        else
          next
        end
      rescue IndexError
        puts "please re-enter"
        retry
      end

      @current_player = (@current_player == player_1) ? player_2 : player_1
    end
  end

end

game = ChessGame.new
game.play

#
# board = Board.new
# print board