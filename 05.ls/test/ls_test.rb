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

  # ls -a コマンドでの../sampleディレクトリ内のファイルの出力
  OUTPUT_TEST2 = <<~OUTPUT2.freeze
    .                       Procfile                config.ru#{'               '}
    ..                      README.md               log#{'                     '}
    .DS_Store               babel.config.js         package.json#{'            '}
    Gemfile                 bin                     postcss.config.js#{'       '}
    Gemfile.lock            config#{'                  '}
  OUTPUT2

  def test_ls1
    options = {}
    assert_output(OUTPUT_TEST1) { Command.new(options, ARGV[0]).show_list }
  end

  def test_ls2
    options = { 'a' => true }
    assert_output(OUTPUT_TEST2) { Command.new(options, ARGV[0]).show_list }
  end
end
