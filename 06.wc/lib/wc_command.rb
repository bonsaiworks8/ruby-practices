# frozen_string_literal: true

class WcCommand
  MAX_DIGITS = 8

  def initialize(options, paths)
    @options = options
    @paths = paths
  end

  def execute
    @paths.size.positive? ? print_in_long_format : print_in_default_format
  end

  private

  def print_each_number(line_count, word_count, byte_size, path = nil)
    row_data =
      if @options['l']
        [format_digits(line_count), ' ', path]
      else
        [format_digits(line_count), format_digits(word_count), format_digits(byte_size), ' ', path]
      end

    puts row_data.join
  end

  def count_each_number(lines)
    line_count = 0
    word_count = 0
    byte_size = 0
    lines.each do |line|
      line_count += 1
      word_count += line.split(/\s+/).length
      byte_size += line.bytesize
    end

    [line_count, word_count, byte_size]
  end

  def format_digits(value)
    value.to_s.rjust(MAX_DIGITS)
  end

  def print_in_default_format
    line_count, word_count, byte_size = count_each_number readlines
    print_each_number line_count, word_count, byte_size
  end

  def print_in_long_format
    total_line_count = 0
    total_word_count = 0
    total_byte_size = 0
    @paths.each do |path|
      line_count, word_count, byte_size = count_each_number File.readlines(path)

      total_line_count += line_count
      total_word_count += word_count
      total_byte_size += byte_size

      print_each_number line_count, word_count, byte_size, path
    end

    print_each_number total_line_count, total_word_count, total_byte_size, 'total' if @paths.size > 1
  end
end
