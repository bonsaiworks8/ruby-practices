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

  # ls -r コマンドでの../sampleディレクトリ内のファイルの出力
  OUTPUT_TEST3 = <<~OUTPUT3.freeze
    postcss.config.js       config                  Procfile#{'                '}
    package.json            bin                     Gemfile.lock#{'            '}
    log                     babel.config.js         Gemfile#{'                 '}
    config.ru               README.md#{'               '}
  OUTPUT3

  def test_ls1
    options = {}
    assert_output(OUTPUT_TEST1) { Command.new(options, ARGV[0]).show_list }
  end

  def test_ls3
    options = { 'r' => true }
    assert_output(OUTPUT_TEST3) { Command.new(options, ARGV[0]).show_list }
  end
end
