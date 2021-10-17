#!/usr/bin/env ruby
# frozen_string_literal: true

def main
  MyFile.new(ARGV[0]).show_list
end

class MyFile
  MAX_COL = 3
  MAX_LENGTH = 24

  def initialize(path)
    path ||= '.'
    @path = path
  end

  def show_list
    return unless exist?

    files = list_up
    max_row = (files.length / MAX_COL) + 1

    col = 1
    row = 1
    h = {}
    h.default = ''
    files.each do |file|
      h[row.to_s] = h[row.to_s] + file.ljust(MAX_LENGTH)
      row += 1

      if row > max_row
        col += 1
        row = 1
      end
    end

    h.each_value do |value|
      puts value
    end
  end

  def exist?
    result = Dir.exist?(@path)

    puts '引数に指定されたファイルもしくはディレクトリは存在しません。' unless result

    result
  end

  def list_up
    Dir.children(@path).sort.reject do |file|
      file.start_with?('.')
    end
  end
end

main
