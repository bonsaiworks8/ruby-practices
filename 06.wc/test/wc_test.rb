#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc'

class WcTest < Minitest::Test
  WC_TEST_NO_OPTIONS = "       3       9     136 sample/sample.txt\n"
  WC_TEST_L_OPTIONS = "       3 sample/sample.txt\n"

  def test_wc_no_options
    options = {}
    assert_output(WC_TEST_NO_OPTIONS) { WcCommand.new(options, ARGV[0]).execute }
  end

  def test_wc_l_options
    options = { 'l' => true }
    assert_output(WC_TEST_L_OPTIONS) { WcCommand.new(options, ARGV[0]).execute }
  end
end
