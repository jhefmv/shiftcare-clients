# frozen_string_literal: true

require 'bundler/setup'
require 'zeitwerk'

class ZeitwerkLoader
  def self.setup
    loader = Zeitwerk::Loader.new
    loader.push_dir(File.expand_path('lib', __dir__))

    # Optionally, enable reloading in development
    # loader.enable_reloading

    loader.setup
    loader
  end
end
# loader = Zeitwerk::Loader.new
# loader.push_dir('./lib')
# loader.setup