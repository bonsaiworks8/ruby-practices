#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/ls'

class LsTest < Minitest::Test
  # ../sampleディレクトリ内のファイル
  TEST_FILES1 = ['Gemfile', 'Gemfile.lock', 'Procfile', 'README.md', 'babel.config.js', 'bin', 'config', 'config.ru', 'log', 'package.json',
                 'postcss.config.js'].freeze

  def test_ls
    assert_equal TEST_FILES1, MyFile.new(ARGV[0]).list_up
  end
end
