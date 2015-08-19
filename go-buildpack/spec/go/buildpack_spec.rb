require 'spec_helper'

describe Go::Buildpack do
  it 'has a version number' do
    expect(Go::Buildpack::VERSION).not_to be nil
  end
end
