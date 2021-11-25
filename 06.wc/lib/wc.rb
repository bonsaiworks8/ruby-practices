#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'matrix'

def main
  options = ARGV.getopts('l')

  if ARGV.size.positive?
    ARGV.each do |path|
      WcCommand.new(options, path).execute # ファイルから読み込み
    end
    WcCommand.append_total
  else
    WcCommand.new(options, nil).execute # 標準入力から読み込み
  end
end

class WcCommand
  MAX_DIGITS = 8
  @totals = Array.new(3, 0)

  class << self
    def append_total
      puts [@totals[0].to_s.rjust(MAX_DIGITS), @totals[1].to_s.rjust(MAX_DIGITS), @totals[2].to_s.rjust(MAX_DIGITS),
            ' total'].join
    end

    def calculate_total(line_count, word_count, char_count)
      @totals = (Vector.elements(@totals) + Vector.elements([line_count, word_count, char_count])).to_a
    end
  end

  def initialize(options, path)
    @options = options
    @path = path
    @line_count = 0
    @word_count = 0
    @char_count = 0
  end

  def execute
    lines = if @path
              readlines_from_file
            else
              readlines
            end

    build lines

    print_word_count
  end

  private

  def build(lines)
    count_each_number lines
    self.class.calculate_total @line_count, @word_count, @char_count
  end

  def print_word_count
    if @options['l']
      puts [@line_count.to_s.rjust(MAX_DIGITS), ' ', @path].join
    else
      puts [@line_count.to_s.rjust(MAX_DIGITS), @word_count.to_s.rjust(MAX_DIGITS), @char_count.to_s.rjust(MAX_DIGITS), ' ', @path].join
    end
  end

  def readlines_from_file
    @file = File.open @path
    lines = @file.readlines
    @file.close
    lines
  end

  def count_each_number(lines)
    lines.each do |line|
      @line_count += 1
      @word_count += line.split(/\s+/).length
      @char_count += line.bytesize
    end
  end
end

main
