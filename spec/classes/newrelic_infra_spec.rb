require 'spec_helper'

describe 'newrelic::infra::linux', :type => :class do

  let(:facts) do
  {
    'os' => {
      'family' => 'RedHat',
    },
      'operatingsystem' => 'Centos',
      'operatingsystemmajrelease' => '7',
  }
  end


  let(:params) do
   {
     :newrelic_license_key => '1234567890qwerty',
   }
  end


  it { is_expected.to compile }
  it { should contain_package('newrelic-infra') }
  it { should contain_service('newrelic-infra').that_requires('Package[newrelic-infra]') }
  it { should contain_file('/etc/newrelic-infra.yml').with_content("license_key: 1234567890qwerty\n") }
  
  context 'with newrelic_manage_repo => true' do
    let(:params)do 
      super().merge({ 'newrelic_manage_repo' => 'true'})
    end

    it { should contain_yumrepo('newrelic-infra') }
  end
end

