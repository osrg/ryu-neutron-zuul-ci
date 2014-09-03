# A Jenkins slave that will execute jobs that use devstack
# to set up a full OpenStack environment for test runs.

class os_ext_testing::devstack_slave (
  $bare = true,
  $certname = $::fqdn,
  $ssh_key = '',
  $python3 = false,
  $include_pypy = false,
  $jenkins_url = '',
) {
  include os_ext_testing::base
  include openstack_project::tmpcleanup
  class { 'jenkins::slave':
    bare         => $bare,
    ssh_key      => $ssh_key,
    python3      => $python3,
    include_pypy => $include_pypy,
    jenkins_url  => $jenkins_url,
  }
  include devstack_host

  if $::osfamily == 'Debian' {
    $packages = ['libc6', 'libssl1.0.0', 'openssl', 'module-init-tools',
                 'procps', 'uuid-runtime', 'netbase', 'python-argparse',
                 'dkms', 'make', 'libc6-dev']
    package { $packages:
      ensure => present
    }

    exec { 'ovs2.1.0':
      command => 'dpkg -i openvswitch-common_2.1.0-1_amd64.deb openvswitch-switch_2.1.0-1_amd64.deb openvswitch-datapath-dkms_2.1.0-1_all.deb',
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
      cwd     => '/home/jenkins/ovs2.1.0',
      require => [ Package [ $packages ],
                   File ['/home/jenkins/ovs2.1.0'] ],
    }

    file { '/home/jenkins/ovs2.1.0':
      ensure  => directory,
      owner   => 'jenkins',
      group   => 'jenkins',
      mode    => '0755',
      recurse => true,
      require => File ['/home/jenkins'],
      source  => 'puppet:///modules/os_ext_testing/ovs2.1.0',
    }

    package { 'libnetfilter-conntrack3':
      ensure => present
    }

    exec { 'dnsmasq':
      command => 'dpkg -i dnsmasq-utils_2.68-1_amd64.deb dnsmasq-base_2.68-1_amd64.deb',
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
      cwd     => '/home/jenkins/dnsmasq',
      require => [ Package [ 'libnetfilter-conntrack3'],
                   File ['/home/jenkins/dnsmasq'] ],
    }

    file { '/home/jenkins/dnsmasq':
      ensure  => directory,
      owner   => 'jenkins',
      group   => 'jenkins',
      mode    => '0755',
      recurse => true,
      require => File ['/home/jenkins'],
      source  => 'puppet:///modules/os_ext_testing/dnsmasq',
    }
  }
}
