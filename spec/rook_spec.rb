# frozen_string_literal: true

require_relative '../lib/rook'
require_relative '../lib/rules'

RSpec.describe Rook do
  let(:white_rook) { described_class.new(:white) }
  let(:black_rook) { described_class.new(:black) }
  let(:board) { instance_double('board') }

  it 'returns rook unicode' do
    expect(described_class::UNICODE).to eq("\u265C")
  end

  describe '#initialize' do
    let(:expected_color) { 'expected_color' }
    subject(:rook) { described_class.new(expected_color) }

    it 'sets the color instance variable' do
      expect(rook.instance_variable_get(:@color)).to eq(expected_color)
    end
  end

  describe '#available_moves' do
    let(:row) { 'row' }
    let(:column) { 'column' }

    before do
      allow(white_rook).to receive(:default_moves)
      allow(black_rook).to receive(:default_moves)
    end

    context 'when rook is white' do
      it 'calls #default_moves once' do
        expect(white_rook).to receive(:default_moves).with(board, row, column).once
        white_rook.available_moves(board, row, column)
      end
    end

    context 'when rook is black' do
      it 'calls #default_moves once' do
        expect(black_rook).to receive(:default_moves).with(board, row, column).once
        black_rook.available_moves(board, row, column)
      end
    end
  end
end
