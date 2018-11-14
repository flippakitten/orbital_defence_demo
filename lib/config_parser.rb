# frozen_string_literal: true

require 'yaml'
require 'erb'

class ConfigParser
  def self.parse(file, environment = nil)
    file = YAML.load(ERB.new(IO.read(file)).result) # rubocop:disable Security/YAMLLoad
    environment ? file[environment] : file
  end
end
