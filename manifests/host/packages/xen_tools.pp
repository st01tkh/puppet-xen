class xen::host::packages::xen_tools{
  case $operatingsystem {
    'Ubuntu': {
      package { ["xen-tools", ]: ensure => present }
    }
    default: {
      fail("Unknown operation system $operationsystem")
    }
  }
}
