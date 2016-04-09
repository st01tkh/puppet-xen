class xen::host::packages::minimal {
  case $operatingsystem {
    'Ubuntu': {
      case  $lsbdistcodename {
        'precise': {
          notify {'This is Precise': }
          package { ['xen-hypervisor-amd64']: ensure => present }
	}
        'trusty': {
          notify {'This is Trusty': }
          package { ['xen-hypervisor']: ensure => present }
	}
      }
    }
    default: {
      fail("Unknown operation system $operationsystem")
    }
  }
}
