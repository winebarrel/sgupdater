require 'thor'
require 'thor/aws'

module Sgupdater
  class CLI < Thor
    include Thor::Aws

    class_option :verbose, type: :boolean, default: false, aliases: [:v]

    desc :show, "Show current permissions"
    method_option :from_cidr, type: :string, required: true
    def show
      client.show
    end

    desc :update, "Update cidr address"
    method_option :from_cidr, type: :string, required: true
    method_option :to_cidr, type: :string, required: true
    def update
      client.update
    end

    private
    def client
      @client ||= Client.new options, aws_configuration
    end
  end
end

