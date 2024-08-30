# frozen_string_literal: true

require_relative '../lib/pawn'

RSpec.describe Pawn do
  let(:board) { instance_double('Board') }
  let(:white_color) { :white }
  subject(:white_pawn) { described_class.new(white_color) }

  it 'has the pawn unicode constant' do
    expect(described_class::UNICODE).to eq("\u265F")
  end

  describe '#initialize' do
    it 'sets the color instance variable' do
      expect(white_pawn.instance_variable_get(:@color)).to eq(white_color)
    end
  end

  describe '#color' do
    it 'returns the color instance variable value' do
      expect(white_pawn.color).to eq(white_color)
    end
  end

  describe '#to_s' do
    let(:unicode_str) { double('unicode_str') }
    let(:colorized_str) { 'colorized_str' }

    before do
      allow(unicode_str).to receive(:colorize).and_return(colorized_str)
      allow(white_pawn).to receive(:color).and_return(white_color)
    end

    it 'calls #colorize on unicode string once' do
      stub_const("#{described_class}::UNICODE", unicode_str)
      expect(unicode_str).to receive(:colorize).with(white_color).once
      white_pawn.to_s
    end

    it 'returns the colorized unicode string' do
      stub_const("#{described_class}::UNICODE", unicode_str)
      expect(white_pawn.to_s).to eq(colorized_str)
    end
  end

  describe '#available_moves' do
    let(:row) { 3 }
    let(:column) { 5 }

    it 'returns a [row, column] array' do
      result = white_pawn.available_moves(board, row, column)
      expect(result).to eq([row, column])
    end
  end
end
