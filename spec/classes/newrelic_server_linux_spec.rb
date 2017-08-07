require 'spec_helper'

describe 'newrelic::server::linux', :type => :class do
  let(:facts) {{
        :osfamily           => 'RedHat',
  }}

  let(:params) {{
    :newrelic_license_key => '1234567890qwerty',
  }}


  it { is_expected.to compile }

end

