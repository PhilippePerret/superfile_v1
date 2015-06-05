#!/usr/bin/env ruby
# encoding: UTF-8

unless respond_to? :require_relative
  def require_relative relpath
    @this_folder ||= File.expand_path(File.dirname __FILE__)
    require File.join(@this_folder, relpath)
  end
end

require_relative 'superfile/class'
require_relative 'superfile/errors'
require_relative 'superfile/instance'
