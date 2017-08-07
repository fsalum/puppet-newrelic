require 'spec_helper'

describe 'newrelic', :type => :class do
  let(:facts) {{
        :osfamily           => 'RedHat',
  }}

  it { is_expected.to compile }

end
