# -*- coding: utf-8 -*- #

require 'spec_helper'

require 'rouge/lexers/wenyan'

describe Rouge::Lexers::Wenyan do
  let(:subject) { Rouge::Lexers::Wenyan.new }

  describe 'guessing' do
    include Support::Guessing

    it 'guesses by filename' do
      assert_guess :filename => '問天地好在.wy'
      assert_guess :filename => '問天地好在.文言'
      assert_guess :filename => '問天地好在.經'
    end
  end
end
