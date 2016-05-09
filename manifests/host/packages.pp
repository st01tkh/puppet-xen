class xen::host::packages($set = 'common', $networking_type = 'bridge') {
  case $set {
    'minimal': {
	  notify {'installing minimal': }
	  include xen::host::packages::minimal
    }
    'additional': { include xen::host::packages::additional }
    'common': {
      include xen::host::packages::minimal
      include xen::host::packages::xen_tools
    }
  } 
  case $networking_type {
    'bridge': {
	  include xen::host::packages::bridge
    }
  }
}
