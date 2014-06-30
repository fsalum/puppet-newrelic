# -*- mode: ruby -*-
# vi: set ft=ruby :
#

if ENV['VAGRANT_HOME'].nil?
    ENV['VAGRANT_HOME'] = './'
end

newrelic = {
    :'centos65' => { :memory => '120', :ip => '10.1.2.13', :box => 'puppetlabs/centos-6.5-64-puppet',   :domain => 'newrelic.local' },
    :'trusty'   => { :memory => '360', :ip => '10.1.2.14', :box => 'ubuntu/trusty64',                   :domain => 'newrelic.local' },
    :'saucy'    => { :memory => '120', :ip => '10.1.2.15', :box => 'puppetlabs/ubuntu-13.10-64-puppet', :domain => 'newrelic.local' },
    :'precise'  => { :memory => '120', :ip => '10.1.2.16', :box => 'puppetlabs/ubuntu-12.04-64-puppet', :domain => 'newrelic.local' },
    :'debian74' => { :memory => '120', :ip => '10.1.2.17', :box => 'puppetlabs/debian-7.4-64-puppet',   :domain => 'newrelic.local' },
}

Vagrant::Config.run("2") do |config|
  config.vbguest.auto_update = false
  config.hostmanager.enabled = false

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
