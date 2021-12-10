#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/wc_command'

class WcTest < Minitest::Test
  WC_TEST_NO_OPTIONS = "       3       9     136 test/sample/sample.txt\n"
  WC_TEST_L_OPTIONS = "       3 test/sample/sample.txt\n"
  SAMPLE_FILE_PATHS = ['test/sample/sample.txt'].freeze

  def test_wc_no_options
    options = {}
    assert_output(WC_TEST_NO_OPTIONS) { WcCommand.new(options, SAMPLE_FILE_PATHS).execute }
  end

  def test_wc_l_options
    options = { 'l' => true }
    assert_output(WC_TEST_L_OPTIONS) { WcCommand.new(options, SAMPLE_FILE_PATHS).execute }
  end
end
