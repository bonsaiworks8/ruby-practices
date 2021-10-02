#!/usr/bin/env ruby

require 'date'
require 'optparse'

class MyCalender
  DAY_OF_WEEK = ['日', '月', '火', '水', '木', '金', '土'].freeze

  # ANSIカラーエスケープシーケンス
  FG_BLACK = "\e[30m".freeze
  BG_WHITE = "\e[47m".freeze
  DEFAULT = "\e[0m".freeze

  def initialize(year:, month:)
    @year = (year ||= Date.today.year).to_i
    @month = (month ||= Date.today.month).to_i
    @first_date = Date.new(@year, @month, 1)
    @last_date = Date.new(@year, @month, -1)
  end

  def show
    puts "#{@month}月 #{@year}".center(20)
    puts DAY_OF_WEEK.join(' ')
    puts format_days
  end

  private

  def format_days
    days = ''

    # 月の最初の日の曜日の位置に至るまで空白を入れる
    @first_date.wday.times do
      days += '　 '
    end
    
    (@first_date..@last_date).each do |current_date|
      if current_date == Date.today
        # 今日の日付に色を付ける
        days += (FG_BLACK + BG_WHITE)
      end

      days += current_date.day.to_s.rjust(2)

      days += DEFAULT

      if current_date.saturday?
        # 土曜日なら改行コードを入れる
        days += "\n"
      else
        days += ' '
      end
    end

    days
  end
end

# コマンドライン引数・オプションの処理
options = ARGV.getopts('y:m:')

# 入力チェック
message = ''
if options["y"]
  message = "The year designation is incorrect. Range is between 1970 and 2100.\n" unless options["y"].match(/(^19[7-9][0-9]$)|(^2[0][0-9]{2}$)|(^2100$)/)
end
if options["m"]
  message += "The month designation is incorrect. Range is between 1 and 12.\n" unless options["m"].match(/(^[1-9]$|^1[0-2]$)/)
end

# 入力エラーでプログラム終了
unless message.empty?
  puts message
  exit
end

my_calender = MyCalender.new(year: options["y"], month: options["m"])

# カレンダー表示
my_calender.show
