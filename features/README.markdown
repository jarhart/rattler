# Rattler - Ruby Tool for Language Recognition

Parsing for Ruby that's so easy it feels like cheating.

Rattler is a parser generator for Ruby based on parsing expression grammars.
Rattler's purpose is to make language design and recognition as simple and fun
as possible. To that end, the normal parsing expression grammar syntax is
extended with simple features to overcome some of the limitations of pure
PEG grammars.

A language syntax is specified in a grammar using the Rattler syntax. Parser
classes and modules can be generated statically using the "rtlr" command or
dynamically from strings.

# Grammar Syntax

Standard Parsing Expression Grammar Syntax

* [String Literals](http://www.relishapp.com/jarhart/rattler/docs/grammar/string-literals)
* [Character Classes](http://www.relishapp.com/jarhart/rattler/docs/grammar/character-classes)
* ["Any Character" Symbol](http://www.relishapp.com/jarhart/rattler/docs/grammar/any-character-symbol)
* [Nonterminals](http://www.relishapp.com/jarhart/rattler/docs/grammar/nonterminals)
* [Ordered Choice](http://www.relishapp.com/jarhart/rattler/docs/grammar/ordered-choice)
* [Sequences](http://www.relishapp.com/jarhart/rattler/docs/grammar/sequences)
* [Zero-Or-More](http://www.relishapp.com/jarhart/rattler/docs/grammar/zero-or-more)
* [One-Or-More](http://www.relishapp.com/jarhart/rattler/docs/grammar/one-or-more)
* [Optional Expressions](http://www.relishapp.com/jarhart/rattler/docs/grammar/optional-operator)
* [Positive Lookahead](http://www.relishapp.com/jarhart/rattler/docs/grammar/positive-lookahead-operator)
* [Negative Lookahead](http://www.relishapp.com/jarhart/rattler/docs/grammar/negative-lookahead-operator)
* [Comments](http://www.relishapp.com/jarhart/rattler/docs/grammar/comments)

Rattler Extended Matching Syntax

* [Whitespace Skipping](http://www.relishapp.com/jarhart/rattler/docs/grammar/whitespace-skipping)
* [POSIX Character Classes](http://www.relishapp.com/jarhart/rattler/docs/grammar/posix-character-classes)
* [Skip Operator](http://www.relishapp.com/jarhart/rattler/docs/grammar/skip-operator)
* [Token Operator](http://www.relishapp.com/jarhart/rattler/docs/grammar/token-operator)
* [Word Literals](http://www.relishapp.com/jarhart/rattler/docs/grammar/word-literal-expressions)
* [Generalized Repeat](http://www.relishapp.com/jarhart/rattler/docs/grammar/generalized-repeat)
* [List Matching](http://www.relishapp.com/jarhart/rattler/docs/grammar/list-matching)
* [Back References](http://www.relishapp.com/jarhart/rattler/docs/grammar/back-references)
* [EOF Symbol](http://www.relishapp.com/jarhart/rattler/docs/grammar/eof-symbol)
* ["Empty" Symbol](http://www.relishapp.com/jarhart/rattler/docs/grammar/e-symbol)
* [Fail Expressions](http://www.relishapp.com/jarhart/rattler/docs/grammar/fail-expressions)
* [Include Another Grammar](http://www.relishapp.com/jarhart/rattler/docs/grammar/include)
* ["super" Keyword](http://www.relishapp.com/jarhart/rattler/docs/grammar/super-keyword)

Semantics

* [Semantic Actions](http://www.relishapp.com/jarhart/rattler/docs/grammar/semantic-actions)
* [Node Actions](http://www.relishapp.com/jarhart/rattler/docs/grammar/node-actions)
* [Semantic Results](http://relishapp.com/jarhart/rattler/docs/grammar/semantic-results)
* [Positive Semantic Predicates](http://www.relishapp.com/jarhart/rattler/docs/grammar/positive-semantic-predicates)
* [Negative Semantic Predicates](http://www.relishapp.com/jarhart/rattler/docs/grammar/negative-semantic-predicates)
* [Semantic side-effects](http://www.relishapp.com/jarhart/rattler/docs/grammar/semantic-side-effects)
* [Labels](http://www.relishapp.com/jarhart/rattler/docs/grammar/labels)
