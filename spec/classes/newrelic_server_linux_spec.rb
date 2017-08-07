require 'spec_helper'

describe 'newrelic::server::linux', :type => :class do
  let(:facts) do
    {
      'os' => {
          'family' => 'RedHat',

      }
   }
  end

  let(:params) do 
    {
    :newrelic_license_key => '1234567890qwerty',
    }
  end

  it { is_expected.to compile }

end

