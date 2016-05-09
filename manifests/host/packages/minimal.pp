class xen::host::packages::minimal {
  case $operatingsystem {
    'Ubuntu': {
      case  $lsbdistcodename {
        'precise': {
          package { ['xen-hypervisor-amd64']: ensure => present }
	}
        'trusty': {
          package { ['xen-hypervisor']: ensure => present }
	}
      }
    }
    default: {
      fail("Unknown operation system $operationsystem")
    }
  }
}
