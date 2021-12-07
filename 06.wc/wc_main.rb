#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './lib/wc'

def main
  options = ARGV.getopts('l')
  WcCommand.new(options, ARGV).execute
end

main
