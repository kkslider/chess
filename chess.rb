require './chess_piece.rb'
require 'yaml'
#
# class ImproperPieceError < StandardError
# end

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
    # @state[0][0] = Rook.new(self, :black, [0, 0])
    @state[0][1] = Knight.new(self, :black, [0, 1])
    @state[0][2] = Bishop.new(self, :black, [0, 2])
    # @state[0][3] = Queen.new(self, :black, [0, 3])
    @state[0][4] = King.new(self, :black, [0, 4])
    @state[0][5] = Bishop.new(self, :black, [0, 5])
    @state[0][6] = Knight.new(self, :black, [0, 6])
    # @state[0][7] = Rook.new(self, :black, [0, 7])


    @state[4][1] = Rook.new(self, :black, [4, 1])
    @state[2][1] = Rook.new(self, :black, [2, 1])
    @state[2][0] = Queen.new(self, :black, [2, 0])
  end

  def setup_white_pieces
    setup_pawns(WHITE_ROW_PAWNS)
    @state[7][0] = Rook.new(self, :white, [7, 0])
    @state[7][1] = Knight.new(self, :white, [7, 1])
    @state[7][2] = Bishop.new(self, :white, [7, 2])
    @state[7][3] = Queen.new(self, :white, [7, 3])
    # @state[7][4] = King.new(self, :white, [7, 4])
    @state[7][5] = Bishop.new(self, :white, [7, 5])
    @state[7][6] = Knight.new(self, :white, [7, 6])
    @state[7][7] = Rook.new(self, :white, [7, 7])

    @state[3][3] = King.new(self, :white, [3, 3])
  end


  def get_piece_for_current_player(current_player)
    begin
      puts "#{current_player}, your turn. Enter position of the piece you " +
      "would like to move. e.g. '1 2' for position at row 2, column 3"

      move_from = gets.chomp.split.map(&:to_i) #[1, 2]
      piece = self.state[move_from[0]][move_from[1]]
      raise if (!piece || piece.color != current_player.color || piece.valid_moves.empty?)

    rescue
      puts "Please choose a proper piece."
      retry
    end

    piece
  end

  def move_piece(piece, current_player)
    begin
      puts "#{current_player}, Enter the position you would like to move " +
      "the #{piece.class}."

      move_from = piece.position
      move_to = gets.chomp.split.map(&:to_i)

      until piece.valid_moves.include?(move_to)
        puts "#{current_player}, Enter the position you would like to move " +
        "the #{piece.class}."
        move_to = gets.chomp.split.map(&:to_i)
      end

      piece.position = move_to
      self.state[move_to[0]][move_to[1]] = piece
      self.state[move_from[0]][move_from[1]] = nil

      if piece.class == Pawn
        piece.initial_move = false
      end

      # print self
    rescue => e
      puts "Please enter valid coordinates."
      retry
    end
  end

  # def move(start, end)
  #   if board.checked?(@current_player.color)
  #     # for each piece, check each valid move, and if all the valid moves result in checked, you are in checkmate
  #
  #     puts "YO KING IS IN CHECK!! DO SUMTHIN"
  #   end
  #
  #   valid_move = false
  #   until valid_move
  #     begin
  #       puts "#{current_player}, your turn. Enter position of the piece you " +
  #       "would like to move. e.g. '1 2' for position at row 2, column 3"
  #
  #       move_from = gets.chomp.split.map(&:to_i) #[1, 2]
  #       piece = board.state[move_from[0]][move_from[1]]
  #     rescue
  #       puts "please re-enter"
  #       retry
  #     end
  #     next if !piece || piece.color != @current_player.color
  #
  #     begin
  #       puts "#{current_player}, Enter the position you would like to move " +
  #       "the #{piece.class}."
  #
  #       move_to = gets.chomp.split.map(&:to_i)
  #
  #       if piece.valid_moves.include?(move_to)
  #         piece.position = move_to
  #         board.state[move_to[0]][move_to[1]] = piece
  #         board.state[move_from[0]][move_from[1]] = nil
  #
  #         if piece.class == Pawn
  #           piece.initial_move = false
  #         end
  #
  #         if board.checked?(@current_player.color)
  #           puts "YOU MADE A BAAAAAD MOVE SON"
  #           board = YAML::load(serialized_board)
  #           next
  #         end
  #
  #         print board
  #       else
  #         next
  #       end
  #     rescue
  #       puts "please re-enter"
  #       retry
  #     end
  #   end



  def checked?(color) # :white
    player_king = nil
    opp_color = (color == :white) ? :black : :white

    @state.each_with_index do |row, r_index|
      row.each_with_index do |column, c_index|
        piece = @state[r_index][c_index]
        if piece.class == King && piece.color == color
          player_king = piece
          break
        end
      end

      break if player_king
    end

    scan_opp_pieces_for_check(opp_color, player_king.position)
  end

  def scan_opp_pieces_for_check(color, king_position)
    @state.each_with_index do |row, r_index|
      row.each_with_index do |column, c_index|
        piece = @state[r_index][c_index]
        if piece && piece.color == color
          return true if piece.valid_moves.include?(king_position)
        end
      end
    end

    false
  end

  def checkmate?(color)
    serialized_board = self.to_yaml
    temp_board = YAML::load(serialized_board)

    temp_board.state.each_with_index do |row, r_index|
      row.each_with_index do |column, c_index|
        piece = temp_board.state[r_index][c_index]

        if piece && piece.color == color
          piece.valid_moves.each do |valid_move|
            current_x, current_y = piece.position[0], piece.position[1]
            new_x, new_y = valid_move[0], valid_move[1]
            temp_board.state[current_x][current_y] = nil
            temp_board.state[new_x][new_y] = piece

            if !temp_board.checked?(color)
              return false
            end

            serialized_board = self.to_yaml
            temp_board = YAML::load(serialized_board)
          end
        end
      end
    end


    true
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

  def opponent
    self.color == :white ? "Player 2 (B)" : "Player 1 (W)"
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
      serialized_board = board.to_yaml

      if board.checked?(@current_player.color)
        if board.checkmate?(@current_player.color)
          game_over = true
          next
        end

        puts "YO KING IS IN CHECK!! DO SUMTHIN"
      end

      piece_from = board.get_piece_for_current_player(@current_player)
      board.move_piece(piece_from, @current_player)

      if board.checked?(@current_player.color)
        puts "You put yourself in check! Please retry that move."
        board = YAML::load(serialized_board)
        next
      end
      print board
      @current_player = (@current_player == player_1) ? player_2 : player_1
    end

    puts "CHECKMATE! #{@current_player.opponent} HAS WON THE GAME!!"
    puts "#{@current_player}, BETTER LUCK NEXT TIME!!"
  end

end