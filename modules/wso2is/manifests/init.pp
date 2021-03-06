class wso2is (
	$wso2_user				 = 'ubuntu',
	$wso2_group				 = 'ubuntu',
	$service_name			 = 'wso2is',
	$install_path			 = '/usr/lib/wso2/wso2is/5.6.0',

	# Master Datasources
	$wso2_carbon_db    = $wso2is::params::wso2_carbon_db,
	$wso2_reg_db       = $wso2is::params::wso2_reg_db,
	$wso2_user_db      = $wso2is::params::wso2_user_db,
	$wso2_identity_db  = $wso2is::params::wso2_identity_db,
	$wso2_consent_db   = $wso2is::params::wso2_consent_db,

  $ports             = $wso2is::params::ports
#	$hostname	         = $wso2is::params::hostname
#	$mgt_hostname	     = $wso2is::params::mgt_hostname

)

inherits wso2is::params {

# Checking for the OS family
if $::osfamily == 'redhat' {
        $wso2is_package   = 'wso2is-linux-installer-x64-5.6.0.rpm'
        $install_provider = 'rpm'
    }
elsif $::osfamily == 'debian' {
        $wso2is_package   = 'wso2is-linux-installer-x64-5.6.0.deb'
        $install_provider = 'dpkg'
    }

file { '/opt/wso2is':
         ensure => directory,
         owner  => $wso2_user,
         group  => $wso2_group,
    }

file { "/opt/wso2is/$wso2is_package":
         mode   => "0644",
         owner  => $wso2_user,
         group  => $wso2_group,
         source => "puppet:///modules/wso2is/$wso2is_package",
    }

package { "wso2is":
	       provider => "$install_provider",
	       ensure   => installed,
	       source   => "/opt/wso2is/$wso2is_package"
    }

$template_list        = [
#	'repository/conf/identity/identity.xml',
#	'repository/conf/carbon.xml',
#	'repository/conf/user-mgt.xml',
	'repository/conf/datasources/master-datasources.xml',
	'bin/wso2server.sh',
#	'repository/conf/axis2/axis2.xml',
]

$template_list.each |String $template| {
file {"${install_path}/${template}":
		ensure  => file,
    		owner   => $wso2_user,
    		group   => $wso2_group,
    		mode    => '0754',
    		content => template("wso2is/${template}.erb")
		}
}

file { "/etc/init.d/${service_name}":
				ensure  => present,
				owner   => root,
				group   => root,
				mode    => '0755',
				content => template("wso2is/wso2service.erb"),
}
file { "/etc/systemd/system/wso2is.service":
        ensure  => present,
        owner   => root,
        group   => root,
        mode    => '0755',
        content => template("wso2is/wso2is.service.erb"),
}
}
