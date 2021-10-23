#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class LsTest < Minitest::Test
  # ../sampleディレクトリ内のファイルの出力
  OUTPUT_TEST1 = <<~OUTPUT1.freeze
    Gemfile                 babel.config.js         log#{'                     '}
    Gemfile.lock            bin                     package.json#{'            '}
    Procfile                config                  postcss.config.js#{'       '}
    README.md               config.ru#{'               '}
  OUTPUT1

  def test_ls
    assert_output(OUTPUT_TEST1) { Command.new(ARGV[0]).show_list }
  end
end
