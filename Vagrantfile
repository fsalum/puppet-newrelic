# -*- mode: ruby -*-
# vi: set ft=ruby :
#

if ENV['VAGRANT_HOME'].nil?
    ENV['VAGRANT_HOME'] = './'
end

newrelic = {
    :'centos5'  => { :memory => '120', :ip => '10.1.2.10', :box => 'puppetlabs/centos-5.10-64-puppet',  :domain => 'newrelic.local' },
    :'centos65' => { :memory => '120', :ip => '10.1.2.11', :box => 'puppetlabs/centos-6.5-64-puppet',   :domain => 'newrelic.local' },
    :'precise'  => { :memory => '120', :ip => '10.1.2.20', :box => 'puppetlabs/ubuntu-12.04-64-puppet', :domain => 'newrelic.local' },
    :'saucy'    => { :memory => '120', :ip => '10.1.2.21', :box => 'puppetlabs/ubuntu-13.10-64-puppet', :domain => 'newrelic.local' },
    :'trusty'   => { :memory => '360', :ip => '10.1.2.22', :box => 'puppetlabs/ubuntu-14.04-64-puppet', :domain => 'newrelic.local' },
    :'squeeze'  => { :memory => '120', :ip => '10.1.2.30', :box => 'puppetlabs/debian-6.0.9-64-puppet', :domain => 'newrelic.local' },
    :'wheezy'   => { :memory => '120', :ip => '10.1.2.31', :box => 'puppetlabs/debian-7.5-64-puppet',   :domain => 'newrelic.local' },
}

Vagrant::Config.run("2") do |config|

    newrelic.each_pair do |name, opts|
        config.vm.define name do |n|
            config.vm.provider :virtualbox do |vb|
                vb.customize ["modifyvm", :id, "--memory", opts[:memory] ]
            end
            n.vm.network "private_network", ip: opts[:ip]
            n.vm.box = opts[:box]
            n.vm.host_name = "#{name}" + "." + opts[:domain]
            n.vm.synced_folder "#{ENV['VAGRANT_HOME']}","/etc/puppet/modules/newrelic"
            n.vm.provision :shell, :inline => "gem install puppet facter --no-ri --no-rdoc" if name == "trusty"
            n.vm.provision :shell, :inline => "puppet module install puppetlabs-apt"
            n.vm.provision :shell, :inline => "puppet module install puppetlabs-apache"
            n.vm.provision :puppet do |puppet|
                puppet.manifests_path = "tests"
                puppet.manifest_file  = "php.pp"
                puppet.module_path = "./"
            end
        end
    end

end
