class xen::host::network($networking_type = 'bridged', $scenario = '') {
  # case regex example  /^(Debian|Ubuntu)$/:
  case $operatingsystem {
    'Ubuntu': {
      case $lsbdistcodename {
        'trusty', 'precise': {
          service {'network-manager':
            enable => false,
          }
        }
      }
    }
  }
  case $networking_type {
    'bridged': {
      include xen::host::packages::bridge
    }
  }
}
