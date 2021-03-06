require 'chef/resource/lwrp_base'

class Chef
  class Resource
    class ConsulClusterServer < Chef::Resource::LWRPBase
      self.resource_name = :consul_cluster_server
      actions :create
      default_action :create

      attribute :datacenter, kind_of: String, name_attribute: true
      attribute :bootstrap_expect, kind_of: String, default: 3
      attribute :servers, kind_of: Array, required: true
      attribute :bind_interface, kind_of: String, default: 'eth1'
      attribute :serve_ui, equal_to: [true, false], default: true
      attribute :acl_datacenter, kind_of: String, default: nil
      attribute :acl_default_policy, equal_to: ['allow', 'deny', nil], default: nil
      attribute :acl_master_token, kind_of: String, default: nil

      def bind_addr
        addresses = node['network']['interfaces']["#{bind_interface}"]['addresses']
                      .detect{|k,v| v['family'] == 'inet' } & servers
        unless addresses.length
          Chef::Application.fatal("Servers attribute must include an address assigned to this machine")
        end
        addresses.first # The array should really only be one item anyways
      end
    end
  end
end
