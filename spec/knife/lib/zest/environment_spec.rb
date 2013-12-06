require 'spec_helper'

describe Environment do
  describe '.all' do
    subject { described_class.all }

    %w( development staging qa production ).each do |env|
      its([env]) { should == { prefix: env[0] } }
    end
  end
end
