# frozen_string_literal: true

require 'rubygems'
ENV['BUNDLE_GEMFILE'] ||= 'Gemfile'
gemfile = File.expand_path("../../../#{ENV.fetch('BUNDLE_GEMFILE', nil)}", __dir__)

if File.exist?(gemfile)
  ENV['BUNDLE_GEMFILE'] = gemfile
  require 'bundler'
  Bundler.setup
end

$LOAD_PATH.unshift File.expand_path('../../../lib', __dir__)
