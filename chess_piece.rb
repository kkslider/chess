require './chess.rb'

class Piece
  attr_accessor :color, :position, :direction, :board

  def initialize(board, color)
    @board = board
    @color = color
  end

  def out_of_bounds?(move) #[2, 0]
    x = move[0]
    y = move[1]
    board_size = @board.state[0].length
    return true if (x < 0 || x >= board_size) || (y < 0 || y >= board_size)
    false
  end
end

class Pawn < Piece
  def initialize(board, color)
    super(board, color)
    @direction = get_direction
    @initial_move = true
  end

  def opp_color
    self.color == :black ? :white : :black
  end

  def get_direction
    if @initial_move
      if @color == :black
        [[1, 0], [2, 0]]
      else
        [[-1, 0], [-2, 0]]
      end
    else
      if @color == :black
        [[1, 0]]
      else
        [[-1, 0]]
      end
    end
  end


  def capture_move
    if @color == :black
      # if board[@position[0]+1, @position[1]-1]
      directions = [[1, -1], [1, 1]]
    else @color == :white
      directions = [[-1, -1], [-1, 1]]
    end

    potential_captures = []
    directions.each do |direction|
      row = direction[0]
      column = direction[1]
      move = [@position[0] + row, @position[1] + column]
      if !out_of_bounds?(move)
        square = @board.state[move[0]][move[1]]
        if square && square.color == opp_color
          potential_captures << [@position[0] + row, @position[1] + column]
        end
      end
    end

    potential_captures # 2D array of potential capture spots, else empty array
  end



  # def out_of_bounds?(move) #[2, 0]
  #   x = move[0]
  #   y = move[1]
  #   board_size = @board.state[0].length
  #   return true if (x < 0 || x >= board_size) || (y < 0 || y >= board_size)
  #   false
  # end

  def valid_normal_move?(move)
    return false if out_of_bounds?(move)
    x = move[0]
    y = move[1]
    if @board.state[x][y]
      false
    else
      true
    end
  end

  def valid_moves
    valid_moves = []
    capture_moves = capture_move #[[x,y], [x,y]]
    normal_moves = get_direction

    normal_moves.each do |move|
      x = @position[0] + move[0]
      y = @position[1] + move[1]

      if valid_normal_move?([x, y])
        valid_moves << [x, y]
        next
      else
        break
      end
    end

    valid_moves += capture_moves
  end

  def to_s
    "  P  "
  end
end

class Rook < Piece

  def initialize(board, color)
    super(board, color)
    @direction = get_direction
  end

  def get_direction
    [[-1, 0], [0, 1], [1, 0], [0, -1]]
  end




end

class Knight < Piece
end

class Bishop < Piece
end

class Queen < Piece
end

class King < Piece
end