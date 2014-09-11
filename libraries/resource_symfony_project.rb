#
# Author:: Bez Hermoso (<bez@activelamp.com>)
# Copyright:: Copyright (c) 2014 ActiveLAMP
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permission and
# limitations under the License.
#

require 'chef/resource'
require_relative 'provider_deploy'
require_relative 'provider_permission_setfacl'

class Chef
  class Resource
    class SymfonyProject < Chef::Resource::Deploy
      def initialize(name, run_list=nil)
        super(name, run_list)
        @resource_name = :symfony_project
        @provider = Chef::Provider::SymfonyProjectDeploy
        @allowed_actions.push(:set_permissions)
        @shared_dirs = {
            'logs' => 'app/logs',
            'cache' => 'app/cache',
            'uploads' => 'web/media/uploads',
            'vendor' => 'vendor'
        }
        @create_dirs_before_symlink = ['web/media/uploads']
        @symlinks = @shared_dirs
        @permission_provider = Chef::Provider::SymfonyProjectPermission::Setfacl
        @web_user = 'www-data'
        @purge_before_symlink.clear
        @symlink_before_migrate.clear
      end

      def shared_dirs(arg=nil)
        set_or_return(:shared_dirs, arg, :kind_of => Hash)
        symlinks(arg)
      end

      def permission_provider(arg=nil)
        set_or_return(:permission_provider, arg, :kind_of => Class)
      end

      def web_user(arg=nil)
        set_or_return(:web_user, arg, :kind_of => String)
      end
    end
  end
end