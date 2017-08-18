require 'spec_helper'

describe 'newrelic::repo::legacy', :type => :class do
  
  context 'OS Family => Redhat' do
    let(:facts) do 
      {
        'os' => {
            'family' => 'RedHat', 
        }
      }
    end

    it { is_expected.to compile }
    it { should contain_package('newrelic-repo-5-3.noarch') }
  end

  context 'OS Family => Debian' do
    let(:facts) do
      { 
        'os' => { 
            'family'  => 'Debian',
            'name'    => 'Debian',
            'release' => { 
              'full' => '7.0'
            }
        },
        'osfamily' => 'Debian',
        'lsbdistcodename' => 'wheezy'
     } 
     end

    it { is_expected.to compile } 
    it { should contain_apt__source('newrelic') } 
  end

end

