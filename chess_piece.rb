
module SlidingPiece
  def valid_moves
    valid_moves = []
    self.direction.each do |direction|
      (1..8).each do |multiplier|
        x = position[0] + (direction[0] * multiplier)
        y = position[1] + (direction[1] * multiplier)

        next if out_of_bounds?([x, y])

        unless reached_piece?([x, y])
          valid_moves << [x, y]
        else
          valid_moves << [x, y] if @board.state[x][y].color == opp_color
          break
        end
      end
    end

    valid_moves
  end
end

module SteppingPiece
  def valid_moves
    valid_moves = []
    self.direction.each do |direction|
      x = position[0] + direction[0]
      y = position[1] + direction[1]
      next if out_of_bounds?([x, y])

      unless reached_piece?([x, y])
        valid_moves << [x, y]
      else
        valid_moves << [x, y] if @board.state[x][y].color == opp_color
      end
    end

    valid_moves
  end
end


class Piece
  attr_accessor :color, :position, :direction, :board

  def initialize(board, color, position)
    @board = board
    @color = color
    @position = position
    @direction = get_direction
  end

  def opp_color
    self.color == :black ? :white : :black
  end

  def out_of_bounds?(move) #[2, 0]
    x = move[0]
    y = move[1]
    board_size = @board.state[0].length
    (x < 0 || x >= board_size) || (y < 0 || y >= board_size)
  end

  def reached_piece?(move)
    x = move[0]
    y = move[1]
    !!@board.state[x][y]
  end

end

class Pawn < Piece
  attr_accessor :initial_move

  def initialize(board, color, position)
    super(board, color, position)
    @direction = get_direction
    # @position = position
    @initial_move = true
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

  def valid_normal_move?(move)
    return false if out_of_bounds?(move)
    x = move[0]
    y = move[1]
    !@board.state[x][y]
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
    if @color == :white
      " \u2659 "
    else
      " \u265F "
    end
  end
end

class Rook < Piece
  include SlidingPiece

  def get_direction
    [[1, 0], [0, 1], [0, -1], [-1, 0]]
  end

  def to_s
    if @color == :white
      " \u2656 "
    else
      " \u265C "
    end
  end
end

class Knight < Piece
  include SteppingPiece

  def get_direction
    [[1, 2], [1, -2], [-1, 2], [-1, -2], [2, 1], [2, -1], [-2, 1], [-2, -1]]
  end

  def to_s
    if @color == :white
      " \u2658 "
    else
      " \u265E "
    end
  end
end

class Bishop < Piece
  include SlidingPiece

  def get_direction
    [[-1, -1], [-1, 1], [1, 1], [1, -1]]
  end

  def to_s
    if @color == :white
      " \u2657 "
    else
      " \u265D "
    end
  end
end

class Queen < Piece
  include SlidingPiece

  def get_direction
    [[1, 0], [0, 1], [0, -1], [-1, 0], [-1, -1], [-1, 1], [1, 1], [1, -1]]
  end

  def to_s
    if @color == :white
      " \u2655 "
    else
      " \u265B "
    end
  end
end

class King < Piece
  include SteppingPiece

  def get_direction
    [[1, 0], [0, 1], [0, -1], [-1, 0], [-1, -1], [-1, 1], [1, 1], [1, -1]]
  end

  def to_s
    if @color == :white
      " \u2654 "
    else
      " \u265A "
    end
  end
end