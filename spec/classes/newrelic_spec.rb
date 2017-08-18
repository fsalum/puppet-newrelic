require 'spec_helper'

describe 'newrelic', :type => :class do
  let(:facts) do 
    {
      'os' => {
          'family' => 'RedHat',
        
      }
   }
  end

  let(:params) do
  {
    :license_key => '1234567890qwerty',
  }
  end

  it { is_expected.to compile }
  it { should contain_class('newrelic::params') }

end
