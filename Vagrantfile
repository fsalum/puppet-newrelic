Vagrant.require_version ">= 1.6.5"

# ====================
# BOX DEFINITIONS
# ====================

BOXES = [
  { name: "debian7",  box: "debian/wheezy64",  version: "7.11.2", puppet_version: "4.10.6" },
  { name: "debian8",  box: "debian/jessie64",  version: "8.9.0", puppet_version: "4.10.6" },
  { name: "ubuntu14", box: "ubuntu/trusty64", version: "20170810.0.0" },
  { name: "ubuntu16", box: "ubuntu/xenial64", version: "20170811.0.0" },
  { name: "centos6",  box: "centos/6", version: "1707.01" },
  { name: "centos7",  box: "centos/7", version: "1707.01" }
]

# ====================
# VAGRANT CONFIG
# ====================

unless Vagrant.has_plugin?("vagrant-puppet-install")
  raise 'vagrant-puppet-install is not installed!'
end

Vagrant.configure("2") do |config|

  ssh_base_port = 2600
  local_username ||= `whoami`.strip

  # = Actually do some work
  BOXES.each_with_index do |definition,idx|

    name = definition[:name]
    ip = 254 - idx

    config.puppet_install.puppet_version = "4.10.6"
    config.vm.define name, autostart: false do |c|

      # == Basic box setup
      c.vm.box         = definition[:box]
      c.vm.box_version = definition[:version] unless definition[:version].nil?
      c.vm.hostname    = "#{local_username}-newrelic-vagrant-#{name}"
      c.vm.network :private_network, ip: "10.0.255.#{ip}"

      # == Shared folder
      if Vagrant::Util::Platform.darwin?
        config.vm.synced_folder ".", "/vagrant", nfs: true
        c.nfs.map_uid = Process.uid
        c.nfs.map_gid = Process.gid
      else
        c.vm.synced_folder ".", "/vagrant", type: "nfs"
      end

      # == Disable vagrant's default SSH port, then configure our override
      new_ssh_port = ssh_base_port + idx
      c.vm.network :forwarded_port, guest: 22, host: 2222, id: "ssh", disabled: "true"
      c.ssh.port = new_ssh_port
      c.vm.network :forwarded_port, guest: 22, host: new_ssh_port

      # == Set resources if configured
      c.vm.provider "virtualbox" do |v|
        v.name = "puppet_newrelic_#{name}"
        v.memory = definition[:memory] unless definition[:memory].nil?
        v.cpus = definition[:cpus] unless definition[:cpus].nil?
      end

      # == Setup port forwarding if configugred
      if not definition[:ports].nil?
        definition[:ports].each do |port_info|
          c.vm.network :forwarded_port, port_info
        end
      end

      # == Run Puppet
      c.vm.provision :shell, :inline => "for MOD in puppetlabs-apt puppetlabs-apache puppetlabs-stdlib puppet-download_file; do /opt/puppetlabs/puppet/bin/puppet module install $MOD; done"
      c.vm.provision :shell, :inline => "if [ ! -L /etc/puppetlabs/code/environments/production/modules/newrelic ]; then ln -s /vagrant /etc/puppetlabs/code/environments/production/modules/newrelic; fi"
      c.vm.provision :shell, :inline => "STDLIB_LOG_DEPRECATIONS=false /opt/puppetlabs/puppet/bin/puppet apply --verbose --show_diff /vagrant/tests/server_only.pp"
    end
  end
end
