#!/usr/bin/env ruby
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "../lib"))
require "hobo"
Hobo.new.save_darling
