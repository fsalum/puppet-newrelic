node default {

  class { '::phpfpm':
      poold_purge => true,
  }

  ::phpfpm::pool { 'main': }

  class { '::nginx':
    
  }

}
