#!/usr/bin/env ruby

require 'date'
require 'optparse'

class MyCalender
  DAY_OF_WEEK = ['日', '月', '火', '水', '木', '金', '土']

  # ANSIカラーエスケープシーケンス
  FG_BLACK = "\e[30m"
  BG_WHITE = "\e[47m"
  DEFAULT = "\e[0m"

  def initialize(year: Date.today.year, month: Date.today.month)
    @year = year
    @month = month
    @first_date = Date.new(year, month, 1)
    @end_date = Date.new(year, month, -1)
  end

  def show
    puts "#{@month}月 #{@year}".center(20)
    puts DAY_OF_WEEK.join(' ')
    puts format_days
  end

  private

  def format_days
    days=''

    # 月の最初の日の曜日の位置に至るまで空白を入れる
    @first_date.wday.times do
      days += '　 '
    end

    day = 1
    while day <= @end_date.day
      current_date = Date.new(@year, @month, day)
      if current_date == Date.today
        # 今日の日付に色を付ける
        days += (FG_BLACK + BG_WHITE)
      end

      days += day.to_s.rjust(2)

      days+=DEFAULT

      if current_date.wday == 6
        # 土曜日なら改行コードを入れる
        days += "\n"
      else
        days += ' '
      end

      day += 1
    end

    days
  end
end

# コマンドライン引数・オプションの処理
options = ARGV.getopts('y:m:')

# 入力チェック
mes=''
if options["y"]
  mes = "The year designation is incorrect. Range is between 1970 and 2100.\n" unless options["y"].match(/(^19[7-9][0-9]$)|(^2[0][0-9]{2}$)|(^2100$)/)
end
if options["m"]
  mes += "The month designation is incorrect. Range is between 1 and 12.\n" unless options["m"].match(/(^[1-9]$|^1[0-2]$)/)
end

# 入力エラーでプログラム終了
unless mes.empty?
  puts mes
  exit
end

if !options["y"] && !options["m"]
  my_calender= MyCalender.new
elsif options["y"] && options["m"]
  my_calender= MyCalender.new(year: options["y"].to_i, month: options["m"].to_i)
elsif options["y"] && !options["m"]
  my_calender= MyCalender.new(year: options["y"].to_i)
else
  my_calender= MyCalender.new(month: options["m"].to_i)
end

# カレンダー表示
my_calender.show
