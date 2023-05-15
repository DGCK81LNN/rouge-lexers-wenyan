Gem::Specification.new do |s|
  s.name     = "rouge-lexers-wenyan"
  s.version  = "1.4.2"
  s.summary  =
    "Rouge lexer for Wenyan, programming language for the ancient Chinese"
  s.description = <<~END
    == Rouge::Lexers::Wenyan
    {Rouge}[https://github.com/rouge-ruby/rouge] lexer for
    {Wenyan}[https://wy-lang.org/], programming language for the ancient Chinese.
  END
  s.authors  = ["DGCK81LNN"]
  s.email    = "triluolnn@163.com"
  s.files    = Dir[
    "Gemfile",
    "LICENSE",
    "rouge-lexers-wenyan.gemspec",
    "lib/**/*",
  ]
  s.homepage = "https://github.com/DGCK81LNN/rouge-lexers-wenyan"
  s.license  = "MIT"
  s.metadata = {
    "bug_tracker_uri"   => "https://github.com/DGCK81LNN/rouge-lexers-wenyan/issues",
    "source_code_uri"   => "https://github.com/DGCK81LNN/rouge-lexers-wenyan",
  }

  s.add_runtime_dependency "rouge", ">=3.0", "<5.0"
  s.add_development_dependency "rake", "~>13.0"
  s.add_development_dependency "minitest", "~>5.16"
  s.add_development_dependency "minitest-power_assert", "~>0.3"
end
