#!/usr/bin/env ruby
# encoding: UTF-8

require 'fileutils'

['class', 'errors', 'instance'].each do |subfolder|
  if RUBY_VERSION.to_i >= 2
    require_relative "superfile/#{subfolder}"
  else
    this_folder = File.dirname __FILE__
    require File.join(this_folder, 'superfile', subfolder)
  end
end