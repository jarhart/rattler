# Rattler - Ruby Tool for Language Recognition

Parsing for Ruby that's so easy it feels like cheating.

Rattler is a parser generator for Ruby based on parsing expression grammars.
Rattler's purpose is to make language design and recognition as simple and fun
as possible. To that end, the normal parsing expression grammar syntax is
extended with simple features to overcome many of the limitations of pure
PEG grammars.

A language syntax is specified in a grammar using the Rattler syntax. Parser
classes and modules can be generated statically using the "rtlr" command or
dynamically from strings.

# Features

* Languages are described using readable PEG-based grammars
* Directly and indirectly left-recursive grammars can be parsed
* Whitespace can be specified in one place and skipped automatically
* Useful parse error messages are created automatically
* Custom parse error messages can be specified easily
* Generates efficient optimized pure-ruby parsers
* Works with MRI 1.8.7 and 1.9.2, JRuby and Rubinius
