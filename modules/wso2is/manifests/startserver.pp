#----------------------------------------------------------------------------
#  Copyright (c) 2018 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#----------------------------------------------------------------------------

class wso2is::startserver{
	$install_path			 = '/usr/lib/wso2/wso2is/5.6.0'

	exec { 'systemctl daemon-reload':
    command  => "systemctl daemon-reload",
    cwd      => "${install_path}/bin",
    path     => '/usr/bin:/usr/sbin:/bin',
    }

  exec { 'start WSO2 Identity Server':
    command  => "sh wso2server.sh start",
    cwd      => "${install_path}/bin",
    path     => '/usr/bin:/usr/sbin:/bin',
    }

		# service { wso2is:
		# 	     ensure     => running,
		# 	     hasstatus  => true,
		# 	     hasrestart => true,
		# 	     enable     => true
		# }
}
