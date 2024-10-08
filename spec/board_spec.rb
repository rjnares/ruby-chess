# frozen_string_literal: true

require_relative '../lib/board'

RSpec.describe Board do
  let(:rules) { class_double('Rules').as_stubbed_const(transfer_nested_constants: true) }
  let(:grid) { board.instance_variable_get(:@grid) }
  subject(:board) { described_class.new }

  describe '#initialize' do
    it 'creates a grid with 8 rows' do
      expect(grid.length).to eq(8)
    end

    it 'creates a grid with 8 columns' do
      expect(grid.all? { |row| row.length == 8 }).to eq(true)
    end

    it 'sets last move instance variable to nil' do
      expect(board.instance_variable_get(:@last_moved)).to be_nil
    end

    context 'when pawns are created' do
      it 'adds black pawns to row 1' do
        result = grid[1].all? do |val|
          val.instance_of?(Pawn) && val.color == :black
        end
        expect(result).to eq(true)
      end

      it 'adds white pawns to row 6' do
        result = grid[6].all? do |val|
          val.instance_of?(Pawn) && val.color == :gray
        end
        expect(result).to eq(true)
      end
    end

    context 'when rooks are created' do
      it 'adds white rook to row 7, column 0' do
        result = grid[7][0].instance_of?(Rook) && grid[7][0].color == rules::WHITE
        expect(result).to eq(true)
      end

      it 'adds white rook to row 7, column 7' do
        result = grid[7][7].instance_of?(Rook) && grid[7][7].color == rules::WHITE
        expect(result).to eq(true)
      end

      it 'adds black rook to row 0, column 0' do
        result = grid[0][0].instance_of?(Rook) && grid[0][0].color == rules::BLACK
        expect(result).to eq(true)
      end

      it 'adds black rook to row 0, column 7' do
        result = grid[0][7].instance_of?(Rook) && grid[0][7].color == rules::BLACK
        expect(result).to eq(true)
      end
    end

    context 'when kings are created' do
      it 'adds white king to row 7, column 4' do
        result = grid[7][4].instance_of?(King) && grid[7][4].color == rules::WHITE
        expect(result).to eq(true)
      end

      it 'adds black king to row 0, column 4' do
        result = grid[0][4].instance_of?(King) && grid[0][4].color == rules::BLACK
        expect(result).to eq(true)
      end
    end

    context 'when queens are created' do
      it 'adds white queen to row 7, column 3' do
        result = grid[7][3].instance_of?(Queen) && grid[7][3].color == rules::WHITE
        expect(result).to eq(true)
      end

      it 'adds black queen to row 0, column 3' do
        result = grid[0][3].instance_of?(Queen) && grid[0][3].color == rules::BLACK
        expect(result).to eq(true)
      end
    end

    context 'when knights are created' do
      it 'adds white knight to row 7, column 1' do
        result = grid[7][1].instance_of?(Knight) && grid[7][1].color == rules::WHITE
        expect(result).to eq(true)
      end

      it 'adds white knight to row 7, column 6' do
        result = grid[7][6].instance_of?(Knight) && grid[7][6].color == rules::WHITE
        expect(result).to eq(true)
      end

      it 'adds black knight to row 0, column 1' do
        result = grid[0][1].instance_of?(Knight) && grid[0][1].color == rules::BLACK
        expect(result).to eq(true)
      end

      it 'adds black knight to row 0, column 6' do
        result = grid[0][6].instance_of?(Knight) && grid[0][6].color == rules::BLACK
        expect(result).to eq(true)
      end
    end

    context 'when bishops are created' do
      it 'adds white bishop to row 7, column 2' do
        result = grid[7][2].instance_of?(Bishop) && grid[7][2].color == rules::WHITE
        expect(result).to eq(true)
      end

      it 'adds white bishop to row 7, column 5' do
        result = grid[7][5].instance_of?(Bishop) && grid[7][5].color == rules::WHITE
        expect(result).to eq(true)
      end

      it 'adds black bishop to row 0, column 2' do
        result = grid[0][2].instance_of?(Bishop) && grid[0][2].color == rules::BLACK
        expect(result).to eq(true)
      end

      it 'adds black bishop to row 0, column 5' do
        result = grid[0][5].instance_of?(Bishop) && grid[0][5].color == rules::BLACK
        expect(result).to eq(true)
      end
    end
  end

  describe '#last_move' do
    let(:my_value) { 'my value' }

    before do
      board.instance_variable_set(:@last_move, my_value)
    end

    it 'returns the value of the last move instance variable' do
      expect(board.instance_variable_get(:@last_move)).to eq(my_value)
    end
  end

  describe '#display' do
    before do
      allow(board).to receive(:display_file_labels)
      allow(board).to receive(:display_rows)
    end

    it 'calls #display_file_labels once' do
      expect(board).to receive(:display_file_labels).once
      board.display
    end

    it 'calls #display_rows once' do
      expect(board).to receive(:display_rows).once
      board.display
    end
  end

  describe '#empty?' do
    let(:position) { 'position' }

    context 'when Rules::position_to_row_column returns nil' do
      before do
        allow(rules).to receive(:position_to_row_column)
      end

      it 'returns true' do
        expect(board.empty?(position)).to eq(true)
      end
    end

    context 'when Rules::position_to_row_column does not return nil' do
      let(:row) { 1 }
      let(:column) { 2 }

      before do
        allow(rules).to receive(:position_to_row_column).and_return([row, column])
      end

      context 'when position is nil' do
        before do
          grid[row][column] = nil
        end

        it 'returns true' do
          expect(board.empty?(position)).to eq(true)
        end
      end

      context 'when position is not nil' do
        before do
          grid[row][column] = double('pawn')
        end

        it 'returns false' do
          expect(board.empty?(position)).to eq(false)
        end
      end
    end
  end

  describe '#available_moves' do
    let(:position) { 'position' }

    context 'when Rules::position_to_row_column returns nil' do
      before do
        allow(rules).to receive(:position_to_row_column)
      end

      it 'returns an empty array' do
        expect(board.available_moves(position)).to eq([])
      end
    end

    context 'when position is empty' do
      let(:row) { 1 }
      let(:column) { 4 }

      before do
        allow(rules).to receive(:position_to_row_column).and_return([row, column])
        grid[row][column] = nil
      end

      it 'returns an empty array' do
        expect(board.available_moves(position)).to eq([])
      end
    end

    context 'when position is not empty' do
      let(:row) { 1 }
      let(:column) { 4 }
      let(:pawn) { instance_double('Pawn') }

      before do
        allow(rules).to receive(:position_to_row_column).and_return([row, column])
        grid[row][column] = pawn
      end

      it 'calls #available_moves on the piece once' do
        expect(pawn).to receive(:available_moves).with(board, row, column).once
        board.available_moves(position)
      end
    end
  end

  describe '#piece' do
    let(:position) { 'position' }

    context 'when position does not exist' do
      before do
        allow(rules).to receive(:position_to_row_column).and_return(nil)
      end

      it 'returns nil' do
        expect(board.piece(position)).to be_nil
      end
    end

    context 'when position exists' do
      let(:row) { 1 }
      let(:column) { 4 }

      context 'when position is empty' do
        before do
          allow(rules).to receive(:position_to_row_column).and_return([row, column])
          grid[row][column] = nil
        end

        it 'returns nil' do
          expect(board.piece(position)).to be_nil
        end
      end

      context 'when position has a piece' do
        let(:pawn) { double('pawn') }

        before do
          allow(rules).to receive(:position_to_row_column).and_return([row, column])
          grid[row][column] = pawn
        end

        it 'returns the piece' do
          expect(board.piece(position)).to eq(pawn)
        end
      end
    end
  end
end
