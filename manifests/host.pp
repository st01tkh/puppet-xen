class xen::host {
  include xen::host::bootloader
  include xen::host::packages
  include xen::host::network
}
