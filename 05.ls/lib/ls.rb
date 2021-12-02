#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def main
  options = ARGV.getopts('arl')
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

    files = list_up

    lines = if @options['l']
              create_detailed_format files
            else
              create_list_format files
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

  def create_list_format(files)
    max_row = (files.length / MAX_COL.to_f).ceil

    row = 0
    lines = Array.new(max_row, '')
    files.each do |file|
      lines[row] = lines[row] + file.ljust(MAX_LENGTH)
      row += 1

      row = 0 if row >= max_row
    end

    lines
  end

  def create_detailed_format(files)
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
      hardlink = stat.nlink.to_s.rjust(hardlink_digits + 1) # lsコマンドにスペースの数を合わせるため+1
      username = Etc.getpwuid(stat.uid).name
      gn = Etc.getgrgid(stat.gid).name
      groupname = gn.rjust(gn.length + 1)
      size = stat.size.to_s.rjust(size_digits + 1)
      date_and_time = [stat.mtime.month, stat.mtime.day, stat.mtime.hour.to_s.rjust(2, '0'), ':', stat.mtime.min.to_s.rjust(2, '0')].map(&:to_s)
      total_blocks += stat.blocks

      [file_type + permission, hardlink, username, groupname, size, *date_and_time, file].join(' ').gsub(' : ', ':')
    end

    lines.unshift((+'total ').concat(total_blocks.to_s))
  end

  def list_up
    files = if @options['a']
              Dir.glob('*', File::FNM_DOTMATCH, base: @path)
            else
              Dir.glob('*', base: @path)
            end

    files = files.reverse if @options['r']

    files
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
