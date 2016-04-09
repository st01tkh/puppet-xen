class xen::host::packages::bridge {
  case $operatingsystem {
    'Ubuntu': {
      package { ['bridge-utils']: ensure => present }
    }
    default: {
      fail("Unknown operation system $operationsystem")
    }
  }
}
