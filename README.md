# rouge-lexers-wenyan

[Rouge] lexer for [Wenyan], programming language for the ancient Chinese. [Example]

[Rouge]: https://github.com/rouge-ruby/rouge
[Wenyan]: https://wy-lang.org/
[Example]: https://dgck81lnn.github.io/blog/posts/220118_wenyan_stdin

## Installation

Add this line to your Gemfile:

~~~ruby
gem 'rouge-lexers-wenyan'
~~~

Or run:

~~~sh
$ gem install rouge-lexers-wenyan
~~~

## Usage

For [Jekyll]:

~~~liquid
{% highlight wenyan %}
吾有一言。曰「「問天地好在」」。書之。
{% endhighlight %}
~~~

or use fenced code blocks in Markdown / [Kramdown]:

~~~markdown
```wenyan
吾有一言。曰「「問天地好在」」。書之。
```
~~~

[Jekyll]: https://github.com/jekyll/jekyll
[Kramdown]: https://github.com/gettalong/kramdown

For Rouge CLI:

~~~sh
$ rougify highlight -r rouge-lexers-wenyan [...]
~~~

Besides `wenyan`, this lexer also supports `wy` and `文言` as aliases. `.wy`, `.文言`, `.經`, `.篇`, `.章` and `.書` are valid file extensions for Wenyan.

## Features

  * Supports latest grammar (as of 2022)

  * Highlights JavaScript expressions in “identifiers”

  * Consistent with compiler behavior

      * namely, it handles quotation marks the same way as the compiler does

      * except for the [`注曰*/` hack](https://github.com/akira-cn/script-wy/blob/master/%E5%BA%8F.wy), which is too evil to support

## Testing

After cloning the repository, run `bundle exec rake` to run the test *(not “tests” as there is literally only one test, lmao)*, or run `ruby bin/visual.rb` (optionally followed by a theme name which defaults to `thankful_eyes`) to write a visual test to `tmp/visual.html`.
