# frozen_string_literal: true

require_relative '../lib/rules'

RSpec.describe Rules do
  it 'returns 8 for number of ranks' do
    expect(described_class::NUM_RANKS).to eq(8)
  end

  it 'returns 8 for number of files' do
    expect(described_class::NUM_FILES).to eq(8)
  end

  it 'returns light white symbol for light square color' do
    expect(described_class::LIGHT_SQUARE_COLOR).to eq(:light_white)
  end

  it 'returns white symbol for dark square color' do
    expect(described_class::DARK_SQUARE_COLOR).to eq(:white)
  end

  it 'returns array of file labels' do
    expect(described_class::FILES).to eq(%w[a b c d e f g h])
  end

  it 'returns 6 as start row for white pawns' do
    expect(described_class::WHITE_PAWNS_START_ROW).to eq(6)
  end

  it 'returns 1 as start row for black pawns' do
    expect(described_class::BLACK_PAWNS_START_ROW).to eq(1)
  end

  it 'returns gray symbol for white colored pieces' do
    expect(described_class::WHITE).to eq(:gray)
  end

  it 'returns black symbol for black colored pieces' do
    expect(described_class::BLACK).to eq(:black)
  end
end
