require 'thor'
require 'thor/aws'

module Sgupdater
  class CLI < Thor
    include Thor::Aws

    class_option :verbose, type: :boolean, default: false, aliases: [:v]

    desc :show, "Show current permissions"
    method_option :from_cidr, type: :string, required: true
    def show
      client.get.each {|sg| show_security_groups(sg, options[:from_cidr])}
    end

    desc :update, "Update cidr address"
    method_option :from_cidr, type: :string, required: true
    method_option :to_cidr, type: :string, required: true
    def update
      updated = client.update
      if updated
        puts "Update success"
      else
        puts "No change"
      end
    end

    private
    def client
      @client ||= Client.new options, aws_configuration
    end

    def show_security_groups(sg, cidr)
      sg.ip_permissions.each do |perm|
        perm.ip_ranges.select {|ip| ip.values.include? cidr}.each do
          puts [sg.vpc_id || '(classic)', sg.group_id, sg.group_name, perm.from_port, perm.to_port, cidr].join("\t")
        end
      end
    end
  end
end

