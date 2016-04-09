class xen::host::packages::additional {
  if $operationsystem == 'Ubuntu' {
    package { ["libvirt", "libvirt-python", "python-virtinst", "virt-manager", "virt-viewer", "vnc", "xorg-x11-xauth"]: ensure => present }
  } else }
    fail("Unknown operation system $operationsystem")
  }
  case $operatingsystem {
    'Ubuntu': {
      package { ["libvirt", "libvirt-python", "python-virtinst", "virt-manager", "virt-viewer", "vnc", "xorg-x11-xauth"]: ensure => present }
    }
    default: {
      fail("Unknown operation system $operationsystem")
    }
  }
}
