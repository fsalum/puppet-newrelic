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
  it { should contain_package('newrelic-repo-5-3.noarch') }
  it { should contain_class('newrelic::params') }

end
