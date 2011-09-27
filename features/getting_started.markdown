To demonstrate how to get started using Rattler, we'll walk through writing the
ubiquitous arithmetic expression parser.

### Install Rattler

    $ gem install rattler

### Write a grammar

We'll start by writing just enough to describe the syntax of simple arithmetic
expressions in a way that automatically honors the standard order of operations.

In a file called `arithmetic.rtlr` we'll write the following:

    require 'rattler'

    parser ArithmeticParser < Rattler::Runtime::ExtendedPackratParser

    %whitespace SPACE*

    expr    <-  expr "+" term
              / expr "-" term
              / term

    term    <-  term "*" primary
              / term "/" primary
              / primary

    primary <-  "(" expr ")"
              / @("-"? DIGIT+ ("." DIGIT+)?)


If you have experience with recursive descent parsing, you might think the
above grammar won't work because recursive descent parsers can't handle left
recursion. It's actually not true.
There is an [algorithm](http://www.cs.ucla.edu/~todd/research/pepm08.html) for
packrat parsing that handles left recursion. Rattler includes an implementation
of that algorithm, so left-recursive grammars are fine.

The first line of our grammar requires the Rattler library. Any `require`
statements in the grammar heading are placed at the top of the generated parser.

Next we declare our parser class and extend the ExtendedPackratParser base
class, which implements the packrat parsing algorithm, including the algorithm
to support left recursion. We can also use a `grammar` declaration here instead
to generate a module that can be mixed into a parser class.

After that the [`%whitespace`](/jarhart/rattler/docs/extended-matching-syntax/whitespace-skipping)
directive tells Rattler to generate a parser that automatically ignores any
whitespace characters. `SPACE` is a [POSIX character class](/jarhart/rattler/docs/extended-matching-syntax/posix-character-classes)
that matches any whitespace character.

The rest of the grammar is a standard Parsing Expression Grammar until we get
to the last line. In addition to the `DIGIT` character class we put the entire
expression in parentheses and prefix it with `@` which is the
[Token Operator](/jarhart/rattler/docs/extended-matching-syntax/token-operator).
This causes the entire expression to be matched as a single string instead of
producing a parse tree.

Now that we have a grammar, we need to generate the parser.

    $ rtlr arithmetic.rtlr
    arithmetic.rtlr -> arithmetic_parser.rb

This generates a file called `arithmetic_parser.rb`. We can test out the parser
by running the file as a script.

    $ echo "1 + 2 / 3" | ruby arithmetic_parser.rb

This will print out the parse tree:

    ["1", "+", ["2", "/", "3"]]

If you have GraphViz and the ruby-graphviz gem installed you can view the parse
tree with dotty:

    $ echo "1 + 2 / 3" | ruby arithmetic_parser.rb --graphviz

Let's try parentheses to see if the grouping works correctly:

    $ echo "(1 + 2) / 3" | ruby arithmetic_parser.rb
    [["(", ["1", "+", "2"], ")"], "/", "3"]

Well, the grouping does work, but we get the parentheses in the parse tree,
which we really don't need. Let's fix that by using the `~` operator to
[skip](/jarhart/rattler/docs/extended-matching-syntax/skip-operator) those:

    require 'rattler'

    parser ArithmeticParser < Rattler::Runtime::ExtendedPackratParser

    %whitespace SPACE*

    expr    <-  expr "+" term
              / expr "-" term
              / term

    term    <-  term "*" primary
              / term "/" primary
              / primary

    primary <-  ~"(" expr ~")"
              / @("-"? DIGIT+ ("." DIGIT+)?)


And regenerate the parser, using `-f` to force overwriting the file.

    $ rtlr arithmetic.rtlr -f
    arithmetic.rtlr -> arithmetic_parser.rb

Now when we try parsing the expression with parentheses:

    $ echo "(1 + 2) / 3" | ruby arithmetic_parser.rb
    [["1", "+", "2"], "/", "3"]

We get the correct grouping without the superflous parentheses in the result.
