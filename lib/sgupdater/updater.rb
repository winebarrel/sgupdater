require 'piculet'
require 'tempfile'
require 'json'
require 'aws-sdk-v1'

module Sgupdater
  class Updater
    def initialize(options = {})
      @options = options.dup
      @options[:without_convert] = true
      @options[:format] = :json
      AWS.config(@options)
      @client = Piculet::Client.new(@options)
      @exported = @client.export(without_convert: true)
    end

    def replace(from, to)
      @exported.each do |vpc, sgs|
        sgs.each do |sg, props|
          props[:ingress].each do |ing|
            ing[:ip_ranges].each_with_index do |cidr, i|
              if cidr == from
                ing[:ip_ranges][i] = to
                puts [vpc ? vpc : 'classic', sg, props[:name], ing[:protocol], ing[:port_range], ing[:ip_rages], ing[:groups], cidr].join("\t")
              end
            end
          end
        end
      end
    end

    def update
      exported = JSON.pretty_generate(@exported)
      file = Tempfile.new('exported')
      begin
        file.puts exported
        file.rewind
        file.rewind
        updated = @client.apply(file)
      ensure
        file.close
        file.unlink
      end
      updated
    end
  end
end

