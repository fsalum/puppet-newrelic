require 'spec_helper'

describe 'newrelic', :type => :class do
  let(:facts) do 
    {
      'os' => {
          'family' => 'RedHat',
        
      }
   }
  end

  it { is_expected.to compile }

end
