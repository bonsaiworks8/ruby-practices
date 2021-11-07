#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = ARGV.getopts('l')
  Command.new(options, ARGV[0]).show_list
end

class Command
  MAX_COL = 3
  MAX_LENGTH = 24

  # ファイルの種類(8進数表記と記号)の対応表
  FILE_TYPE_TABLE = {
    '04' => 'd',  # ディレクトリ
    '10' => '-',  # 通常ファイル
    '12' => 'l'   # シンボリックリンク
  }.freeze

  PERMISSION_TABLE = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def initialize(options, path)
    @options = options
    path ||= '.'
    @path = path
  end

  def show_list
    return unless exist?

    if @options['l']
      lines = list_up
    else
      files = list_up

      max_row = (files.length / MAX_COL.to_f).ceil

      row = 0
      lines = Array.new(max_row, '')
      files.each do |file|
        lines[row] = lines[row] + file.ljust(MAX_LENGTH)
        row += 1

        row = 0 if row >= max_row
      end
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
    files = Dir.glob('*', base: @path)

    files = list_up_details files if @options['l']

    files
  end

  def list_up_details(files)
    # ハードリンクとファイルサイズ各々で最大の桁数を求める
    hardlink_digits, size_digits = count_digits files

    total_blocks = 0
    lines = files.map do |file|
      full_path = File.join(@path, file)
      stat = File.stat(full_path)

      # ファイルタイプとファイルモード(6桁8進数表記)を取得
      mode =  stat.mode.to_s(8).rjust(6, '0')
      numbers = mode.scan(/(\d{2})(\d)(\d)(\d)(\d)/)

      file_type = FILE_TYPE_TABLE[numbers[0][0]]
      permission = PERMISSION_TABLE[numbers[0][2]] + PERMISSION_TABLE[numbers[0][3]] + PERMISSION_TABLE[numbers[0][4]]
      hardlink = stat.nlink.to_s
      username = Etc.getpwuid(stat.uid).name
      groupname = Etc.getgrgid(stat.gid).name
      size = stat.size.to_s

      date_and_time = stat.mtime.month.to_s.concat(' ', stat.mtime.day.to_s, ' ', stat.mtime.hour.to_s, ':', stat.mtime.min.to_s)
      total_blocks += stat.blocks

      line = +''
      line.concat(file_type, permission, '  ', hardlink.rjust(hardlink_digits), ' ', username, '  ', groupname, '  ', size.rjust(size_digits), ' ',
                  date_and_time, ' ', file)
    end

    lines.unshift((+'total ').concat(total_blocks.to_s))
  end

  def count_digits(files)
    hardlink_digits = 1
    size_digits = 1

    files.each do |file|
      full_path = File.join(@path, file)
      stat = File.stat(full_path)

      hardlink_digits = stat.nlink.to_s.length if stat.nlink.to_s.length > hardlink_digits
      size_digits = stat.size.to_s.length if stat.size.to_s.length > size_digits
    end

    [hardlink_digits, size_digits]
  end
end

main
