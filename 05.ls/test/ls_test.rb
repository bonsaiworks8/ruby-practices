#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class LsTest < Minitest::Test
  # ls コマンドでの../sampleディレクトリ内のファイルの出力
  OUTPUT_TEST1 = <<~OUTPUT1.freeze
    Gemfile                 babel.config.js         log#{'                     '}
    Gemfile.lock            bin                     package.json#{'            '}
    Procfile                config                  postcss.config.js#{'       '}
    README.md               config.ru#{'               '}
  OUTPUT1

  # ls -l コマンドでの../sampleディレクトリ内のファイルの出力
  OUTPUT_TEST4 = <<~OUTPUT4
    total 0
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 Gemfile
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 Gemfile.lock
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 Procfile
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 README.md
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 babel.config.js
    drwxr-xr-x  2 hideakisuyama  staff  64 10 14 17:55 bin
    drwxr-xr-x  2 hideakisuyama  staff  64 10 14 17:55 config
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 config.ru
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 log
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 package.json
    -rw-r--r--  1 hideakisuyama  staff   0 10 14 17:55 postcss.config.js
  OUTPUT4

  def test_ls1
    options = {}
    assert_output(OUTPUT_TEST1) { Command.new(options, ARGV[0]).show_list }
  end

  def test_ls4
    options = { 'l' => true }
    assert_output(OUTPUT_TEST4) { Command.new(options, ARGV[0]).show_list }
  end
end
