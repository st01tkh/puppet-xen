class xen::host::network($networking_type = 'bridged', $scenario = '') {
  # case regex example  /^(Debian|Ubuntu)$/:
  case $operatingsystem {
    'Ubuntu': {
      case $lsbdistcodename {
        'precise': {
          service {'network-manager':
            enable => false,
          }
        }
        'trusty': {
          class {'xen::host::network::fix::cloud_init_nonet_hangs': }
        }
      }
    }
  }
  case $networking_type {
    'bridged': {
      class {'xen::host::network::type::bridged': }
    }
  }
}
