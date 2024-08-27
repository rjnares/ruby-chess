# frozen_string_literal: true

require_relative '../lib/rules'

describe Rules do
  it 'returns 8 for number of ranks' do
    expect(Rules::NUM_RANKS).to eq(8)
  end

  it 'returns 8 for number of files' do
    expect(Rules::NUM_FILES).to eq(8)
  end

  it 'returns light white symbol for light square color' do
    expect(Rules::LIGHT_SQUARE_COLOR).to eq(:light_white)
  end

  it 'returns white symbol for dark square color' do
    expect(Rules::DARK_SQUARE_COLOR).to eq(:white)
  end

  it 'returns array of file labels' do
    expect(Rules::FILES).to eq(%w[a b c d e f g h])
  end
end
