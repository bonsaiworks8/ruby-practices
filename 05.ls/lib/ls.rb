#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def main
  options = ARGV.getopts('a')
  Command.new(options, ARGV[0]).show_list
end

class Command
  MAX_COL = 3
  MAX_LENGTH = 24

  def initialize(options, path)
    @options = options
    path ||= '.'
    @path = path
  end

  def show_list
    return unless exist?

    files = list_up

    max_row = (files.length / MAX_COL.to_f).ceil

    row = 0
    lines = Array.new(max_row, '')
    files.each do |file|
      lines[row] = lines[row] + file.ljust(MAX_LENGTH)
      row += 1

      row = 0 if row >= max_row
    end

    lines.each do |line|
      puts line
    end
  end

  private

  def exist?
    result = Dir.exist?(@path)

    puts '引数に指定されたファイルもしくはディレクトリは存在しません。' unless result

    result
  end

  def list_up
    Dir.foreach(@path).sort.reject do |file|
      if @options['a']
        false
      else
        file.start_with?('.')
      end
    end
  end
end

main
