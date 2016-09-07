# Install New Relic PHP Agent

node default {

  # Include main WebServer Role and standard modules
  # windowsfeature is opentable/windows_feature
  windowsfeature{'Web-Server': }
  windowsfeature{'Web-WebServer': }
  windowsfeature{'Web-Static-Content': }
  windowsfeature{'Web-Default-Doc': }
  windowsfeature{'Web-Dir-Browsing': }
  windowsfeature{'Web-Http-Errors': }
  windowsfeature{'Web-Http-Logging': }
  windowsfeature{'Web-Request-Monitor': }
  windowsfeature{'Web-Filtering': }
  windowsfeature{'Web-Stat-Compression': }
  windowsfeature{'Web-Mgmt-Console': }

  # Include .Net module
  $dotnet_modules = $::operatingsystemrelease ? {
    /2008/  => ['Web-Asp-Net'],
    default => ['Web-Asp-Net','Web-Asp-Net45'],
  }
  ensure_resource ('windowsfeature', $dotnet_modules)

  class {'newrelic::server::windows':
    newrelic_license_key => '',
  }

  class {'newrelic::agent::dotnet':
    newrelic_license_key => '',
    require              => Windowsfeature[$dotnet_modules],
  }

}
