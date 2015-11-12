require 'spec_helper'
describe 'nodequery' do

  context 'with defaults for all parameters' do
    it { should contain_class('nodequery') }
  end
end
