# frozen_string_literal: true

require_relative '../lib/bishop'
require_relative '../lib/rules'

RSpec.describe Bishop do
  let(:white_bishop) { described_class.new(:white) }
  let(:black_bishop) { described_class.new(:black) }
  let(:board) { instance_double('board') }

  it 'returns bishop unicode' do
    expect(described_class::UNICODE).to eq("\u265D")
  end

  describe '#color' do
    context 'when bishop is white' do
      it 'returns white' do
        expect(white_bishop.color).to eq(:white)
      end
    end

    context 'when bishop is black' do
      it 'returns black' do
        expect(black_bishop.color).to eq(:black)
      end
    end
  end

  describe '#initialize' do
    let(:expected_color) { 'expected_color' }
    subject(:bishop) { described_class.new(expected_color) }

    it 'sets the color instance variable' do
      expect(bishop.instance_variable_get(:@color)).to eq(expected_color)
    end
  end

  describe '#available_moves' do
    let(:row) { 2 }
    let(:column) { 4 }

    before do
      allow(white_bishop).to receive(:available_moves_up).and_return([])
      allow(white_bishop).to receive(:available_moves_down).and_return([])
      allow(black_bishop).to receive(:available_moves_up).and_return([])
      allow(black_bishop).to receive(:available_moves_down).and_return([])
    end

    context 'when bishop is white' do
      context 'when source position does not exist' do
        it 'returns empty array' do
          result = white_bishop.available_moves(board, -1, -1)
          expect(result).to eq([])
        end
      end

      it 'calls #available_moves_up once' do
        expect(white_bishop).to receive(:available_moves_up).once
        white_bishop.available_moves(board, row, column)
      end

      it 'calls #available_moves_down once' do
        expect(white_bishop).to receive(:available_moves_down).once
        white_bishop.available_moves(board, row, column)
      end
    end

    context 'when bishop is black' do
      context 'when source position does not exist' do
        it 'returns empty array' do
          result = black_bishop.available_moves(board, -1, -1)
          expect(result).to eq([])
        end
      end

      it 'calls #available_moves_up once' do
        expect(black_bishop).to receive(:available_moves_up).once
        black_bishop.available_moves(board, row, column)
      end

      it 'calls #available_moves_down once' do
        expect(black_bishop).to receive(:available_moves_down).once
        black_bishop.available_moves(board, row, column)
      end
    end
  end
end
