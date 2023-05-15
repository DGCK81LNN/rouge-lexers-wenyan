# -*- coding: utf-8 -*- #

module Rouge
  module Lexers
    class Wenyan < RegexLexer
      title 'Wenyan'
      desc 'Programming language for the ancient Chinese (wy-lang.org)'
      tag 'wenyan'
      aliases 'wy', '文言'
      filenames '*.wy', '*.文言', '*.經', '*.篇', '*.章', '*.書'

      private
      def comment_or(token)
        if in_state?(:comment_start) || in_state?(:comment_string) then Comment
        else token
        end
      end

      id_regex = Javascript.id_regex

      state :root do
        mixin :whitespace
        mixin :simple_literals
        mixin :keywords
        mixin :string
        mixin :identifier

        # unrecognized, may be macros
        rule %r/./, Text
      end

      state :whitespace do # mixin
        rule %r/\s+/, Text::Whitespace
        rule %r/[。、]/ do
          token comment_or(Punctuation)
        end
      end

      state :simple_literals do # mixin
        rule %r/[零一二三四五六七八九十百千萬億兆京垓秭穣穰溝澗正載極又分釐毫絲忽微纖沙塵埃渺漠〇]+/, \
          Literal::Number
        rule %r/[陰陽]/, Literal
      end

      state :keywords do # mixin
        # special handling for some keywords
        rule %r/([吾今]有)(\s*)(一)(\s*)(術)/ do
          groups Keyword::Declaration, Text, Literal::Number, Text, \
            Keyword::Type
          push do
            mixin :whitespace
            rule %r/(名之曰)(\s*)(「)(\s*)(#{id_regex})(\s*)(」)/ do
              groups Keyword::Declaration, Text, Punctuation, Text, \
                Name::Function, Text, Punctuation
            end
            rule %r//, Text, :pop!
          end
        end
        rule %r/(是謂)(\s*)(「)(\s*)(#{id_regex})(\s*)(」)(\s*)(之術也)/ do
          groups Keyword::Declaration, Text, Punctuation, Text, \
            Name::Function, Text, Punctuation, Text, Keyword::Declaration
        end
        rule %r/(施|以施)(\s*)(「)(\s*)(#{id_regex})(\s*)(」)/ do
          groups Operator::Word, Text, Punctuation, Text, Name::Function, \
            Text, Punctuation
        end
        mixin :macro_definition
        rule %r/[注疏批]曰/, Comment, :comment_start

        # other keywords and operators
        keywords1  = %w[ 若 也 遍 凡 豈 ]
        keywords2  = %w[ 云云 若非 或若 為是 乃止 乃得 之書 方悟 之義 嗚呼 之禍 ]
        keywords3  = %w[ 恆為是 是術曰 必先得 乃得矣 吾嘗觀 之禍歟 乃作罷 ]
        keywords4  = %w[ 若其然者 乃止是遍 乃歸空無 姑妄行此 如事不諧 ]
        keywords5  = %w[ 若其不然者 不知何禍歟 ]
        declare1   = %w[ 夫 曰 有 今 噫 ]
        declare2   = %w[ 吾有 昔之 是矣 今有 物之 是謂 ]
        declare3   = %w[ 名之曰 之術也 之物也 ]
        declare4   = %w[ 欲行是術 其物如是 ]
        declare5   = %w[ 乃行是術曰 今不復存矣 ]
        types      = %w[ 數 言 爻 列 術 物 元 ]
        operators1 = %w[ 以 於 加 減 乘 除 變 充 銜 之 施 取 ]
        operators2 = %w[ 書之 等於 大於 小於 之長 中之 以施 ]
        operators3 = %w[ 不等於 不大於 不小於 之其餘 ]
        operators4 = %w[ 所餘幾何 中有陽乎 中無陰乎 ]

        rule Regexp.new(keywords5.join('|')), Keyword
        rule Regexp.new(declare5.join('|')), Keyword::Declaration
        rule Regexp.new(keywords4.join('|')), Keyword
        rule Regexp.new(declare4.join('|')), Keyword::Declaration
        rule Regexp.new(operators4.join('|')), Operator::Word
        rule Regexp.new(keywords3.join('|')), Keyword
        rule Regexp.new(declare3.join('|')), Keyword::Declaration
        rule Regexp.new(operators3.join('|')), Operator::Word
        rule Regexp.new(keywords2.join('|')), Keyword
        rule Regexp.new(declare2.join('|')), Keyword::Declaration
        rule Regexp.new(operators2.join('|')), Operator::Word
        rule Regexp.new(keywords1.join('|')), Keyword
        rule Regexp.new(declare1.join('|')), Keyword::Declaration
        rule Regexp.new(types.join('|')), Keyword::Type
        rule Regexp.new(operators1.join('|')), Operator::Word
        rule %r/其/, Keyword::Constant
        rule %r/者/, Keyword::Pseudo
      end

      state :identifier do # mixin
        rule %r/(「)(\s*)(#{id_regex})(\s*)(」)/ do
          groups Punctuation, Text, Name::Variable, Text, Punctuation
        end
        rule %r/「/ do
          token Punctuation
          # not actually an identifier, use Javascript lexer to lex it
          @javascript ||= Javascript.new
          @javascript.reset!
          @javascript.push(:expr_start)
          push do
            rule %r/[^」]+/ do
              delegate @javascript
            end
            rule %r/」/, Punctuation, :pop!
          end
        end
      end

      state :macro_definition do # mixin
        rule %r/或云|蓋謂/ do
          token Keyword
          push do
            rule %r/「「|『/ do
              token Str
              push :macro_definition_content
              push :macro_definition_content
            end
            rule %r//, Text, :pop!
          end
        end
      end

      state :macro_definition_content do
        rule %r/[^『』「」]+/, Str
        rule %r/「[甲乙丙丁戊己庚辛壬癸]」/, Str::Escape
        rule %r/「/, Str, :macro_definition_content
        rule %r/」/, Str, :pop!
        rule %r/『/ do
          token Str
          push :macro_definition_content
          push :macro_definition_content
        end
        rule %r/』/ do
          pop!
          if state?(:macro_definition_content)
            pop!
            token Str
          else
            token Error
          end
        end
        rule %r/./m, Str
      end

      state :comment_start do
        mixin :whitespace
        rule %r/「「|『/ do
          token Comment
          goto :comment_string
          push :string_content
        end

        # Strictly speaking, comments without quotation marks is not valid
        # syntax, and therefore the behavior is undefined (and in fact very
        # confusing in the actual compiler); but for the purpose of this lexer
        # we'll just pretend they are single line comments. Which they are not.
        rule %r/.*?$/, Comment, :pop!
      end

      state :comment_string do
        rule %r//, Text, :pop!
      end

      state :string do # mixin
        rule %r/「「|『/ do
          token comment_or(Str)
          push :string_content
        end
      end

      state :string_content do
        rule %r/[^『』「」]+/ do
          token comment_or(Str)
        end
        rule %r/「「|『/ do
          token comment_or(Str::Escape)
          push :string_nested
        end
        rule %r/」{2,3}|』/ do
          token comment_or(Str)
          pop!
        end
        rule %r/./m do
          token comment_or(Str)
        end
      end

      state :string_nested do
        rule %r/[^『』「」]+/ do
          token comment_or(Str)
        end
        rule %r/「「|『/ do
          token comment_or(Str::Escape)
          push :string_nested
        end
        rule %r/」」|』/ do
          token comment_or(Str::Escape)
          pop!
        end
        rule %r/./m do
          token comment_or(Str)
        end
      end
    end
  end
end
