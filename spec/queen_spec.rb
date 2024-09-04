# frozen_string_literal: true

require_relative '../lib/queen'
require_relative '../lib/rules'

RSpec.describe Queen do
  let(:white_queen) { described_class.new(:white) }
  let(:black_queen) { described_class.new(:black) }
  let(:board) { instance_double('board') }

  it 'returns queen unicode' do
    expect(described_class::UNICODE).to eq("\u265B")
  end

  describe '#color' do
    context 'when queen is white' do
      it 'returns white' do
        expect(white_queen.color).to eq(:white)
      end
    end

    context 'when queen is black' do
      it 'returns black' do
        expect(black_queen.color).to eq(:black)
      end
    end
  end

  describe '#initialize' do
    let(:expected_color) { 'expected_color' }
    subject(:queen) { described_class.new(expected_color) }

    it 'sets the color instance variable' do
      expect(queen.instance_variable_get(:@color)).to eq(expected_color)
    end
  end

  describe '#available_moves' do
    let(:row) { 2 }
    let(:column) { 4 }

    before do
      allow(white_queen).to receive(:bishop_moves).and_return([])
      allow(white_queen).to receive(:rook_moves).and_return([])
      allow(black_queen).to receive(:bishop_moves).and_return([])
      allow(black_queen).to receive(:rook_moves).and_return([])
    end

    context 'when queen is white' do
      context 'when source position does not exist' do
        it 'returns empty array' do
          result = white_queen.available_moves(board, -1, -1)
          expect(result).to eq([])
        end
      end

      it 'calls #bishop_moves once' do
        expect(white_queen).to receive(:bishop_moves).once
        white_queen.available_moves(board, row, column)
      end

      it 'calls #rook_moves once' do
        expect(white_queen).to receive(:rook_moves).once
        white_queen.available_moves(board, row, column)
      end
    end

    context 'when queen is black' do
      context 'when source position does not exist' do
        it 'returns empty array' do
          result = black_queen.available_moves(board, -1, -1)
          expect(result).to eq([])
        end
      end

      it 'calls #bishop_moves once' do
        expect(black_queen).to receive(:bishop_moves).once
        black_queen.available_moves(board, row, column)
      end

      it 'calls #rook_moves once' do
        expect(black_queen).to receive(:rook_moves).once
        black_queen.available_moves(board, row, column)
      end
    end
  end
end
