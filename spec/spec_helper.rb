require 'rubygems'
require 'bundler'
Bundler.require
require 'rouge'
require 'minitest/spec'
require 'minitest/autorun'
require 'minitest/power_assert'

Token = Rouge::Token

require_relative 'support/guessing'
