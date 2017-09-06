require 'rails_helper'

describe MoviesHelper do
  context 'oddness feature' do
    it 'should get odd for count=1' do
      expect(helper.oddness(1)).to eq 'odd'
    end
    it 'should get even for count=2' do
      expect(helper.oddness(2)).to eq 'even'
    end
  end
end