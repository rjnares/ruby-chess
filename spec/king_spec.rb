# frozen_string_literal: true

require_relative '../lib/king'
require_relative '../lib/rules'

RSpec.describe King do
  let(:white_king) { described_class.new(:white) }
  let(:black_king) { described_class.new(:black) }
  let(:board) { instance_double('board') }

  it 'returns king unicode' do
    expect(described_class::UNICODE).to eq("\u265A")
  end

  describe '#initialize' do
    let(:expected_color) { 'expected_color' }
    subject(:king) { described_class.new(expected_color) }

    it 'sets the color instance variable' do
      expect(king.instance_variable_get(:@color)).to eq(expected_color)
    end
  end

  describe '#available_moves' do
    let(:row) { 'row' }
    let(:column) { 'column' }

    before do
      allow(white_king).to receive(:default_moves)
      allow(black_king).to receive(:default_moves)
    end

    context 'when king is white' do
      it 'calls #default_moves once' do
        expect(white_king).to receive(:default_moves).with(board, row, column).once
        white_king.available_moves(board, row, column)
      end
    end

    context 'when king is black' do
      it 'calls #default_moves once' do
        expect(black_king).to receive(:default_moves).with(board, row, column).once
        black_king.available_moves(board, row, column)
      end
    end
  end

  describe '#color' do
    context 'when king is white' do
      it 'returns white' do
        expect(white_king.color).to eq(:white)
      end
    end

    context 'when king is black' do
      it 'returns black' do
        expect(black_king.color).to eq(:black)
      end
    end
  end
end
