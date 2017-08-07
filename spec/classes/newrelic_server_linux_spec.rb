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
  it { should contain_class('newrelic') }
  it { should contain_service('newrelic-sysmond') }
  it { should contain_package('newrelic-sysmond') }
  it { should contain_file('/var/log/newrelic') }
  it { should contain_exec('1234567890qwerty') }
  it { should contain_file('/etc/newrelic/nrsysmond.cfg') }

end

