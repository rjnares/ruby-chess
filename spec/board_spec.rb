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
