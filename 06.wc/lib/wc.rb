# frozen_string_literal: true

require 'optparse'

class WcCommand
  MAX_DIGITS = 8

  def initialize(options, paths)
    @options = options
    @paths = paths
  end

  def execute
    if @paths.size.positive?
      total_line_count = 0
      total_word_count = 0
      total_char_count = 0
      @paths.each do |path|
        line_count, word_count, char_count = count_each_number path

        total_line_count += line_count
        total_word_count += word_count
        total_char_count += char_count

        print_each_number path, line_count, word_count, char_count
      end

      print_each_number 'total', total_line_count, total_word_count, total_char_count if @paths.size > 1
    else
      line_count, word_count, char_count = count_each_number nil

      print_each_number nil, line_count, word_count, char_count
    end
  end

  private

  def print_each_number(path, line_count, word_count, char_count)
    each_number = if @options['l']
                    [
                      line_count.to_s.rjust(MAX_DIGITS),
                      ' ',
                      path
                    ]
                  else
                    [
                      line_count.to_s.rjust(MAX_DIGITS),
                      word_count.to_s.rjust(MAX_DIGITS),
                      char_count.to_s.rjust(MAX_DIGITS),
                      ' ',
                      path
                    ]
                  end

    puts each_number.join
  end

  def count_each_number(path)
    lines = path ? File.readlines(path) : readlines

    line_count = 0
    word_count = 0
    char_count = 0
    lines.each do |line|
      line_count += 1
      word_count += line.split(/\s+/).length
      char_count += line.bytesize
    end

    [line_count, word_count, char_count]
  end
end
