require 'aws-sdk'
require 'sgupdater/updater'

module Sgupdater
  class Client
    attr_reader :logger

    def initialize(cli_options = {}, aws_configuration = {})
      @cli_options = cli_options
      @logger ||= Logger.new STDOUT

      aws_configuration[:logger] = Logger.new STDOUT if @cli_options[:verbose]

      @ec2 = Aws::EC2::Resource.new aws_configuration
    end

    def show
      cidr = @cli_options[:from_cidr]
      security_groups_with_cidr(cidr).each {|sg| put_perms(sg, cidr)}
    end

    def update
      updater = Sgupdater::Updater.new(@cli_options)
      updater.replace(@cli_options[:from_cidr], @cli_options[:to_cidr])
      updater.update
    end

    def security_groups_with_cidr(cidr)
      @ec2.security_groups(
        filters: [
          {name: 'ip-permission.cidr', values: [cidr]}
        ]
      )
    end

    def put_perms(sg, cidr)
      sg.ip_permissions.each do |perm|
        perm.ip_ranges.select {|ip| ip.values.include? cidr}.each do
          puts [sg.vpc_id, sg.group_id, sg.group_name, perm.from_port, perm.to_port, cidr].join("\t")
        end
      end
    end
  end
end
