require 'rubygems'
require 'bundler'

Bundler.require

Dir['*'].each { |file| require "./#{file}" if file.end_with?('rb') }
