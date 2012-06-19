To demonstrate how to get started using Rattler, we'll walk through writing the
ubiquitous arithmetic expression parser. This tutorial assumes that your are
familiar with parsing expression grammars. If you are not, you may wish to read
the [Wikipedia article](http://en.wikipedia.org/wiki/Parsing_expression_grammar)
on them to familiarize yourself.

### Install Rattler

    $ gem install rattler

### Write a grammar

We'll start by writing just enough to describe the syntax of simple arithmetic
expressions in a way that automatically honors the standard order of operations.

We'll write the following and save it to a file called "`arithmetic.rtlr`":

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
recursion. Actually, there is an
[algorithm](http://www.cs.ucla.edu/~todd/research/pepm08.html) for packrat
parsing that handles left recursion. Rattler includes an implementation of that
algorithm, so left-recursive grammars are fine.

Our grammar starts with a [require](/jarhart/rattler/docs/grammar-heading/require)
statement to require the Rattler library. Any `require` statements in the
grammar heading are placed at the top of the generated parser.

Next we declare our parser class with a
[grammar declaration](/jarhart/rattler/docs/grammar-heading/grammar-declaration).
We extend the ExtendedPackratParser base class, which implements the packrat
parsing algorithm that supports left recursion.

After the declaring our parser class, we use the
[`%whitespace`](/jarhart/rattler/docs/extended-matching-syntax/whitespace-skipping)
directive to tell Rattler to generate a parser that automatically ignores any
whitespace characters. `SPACE` is a
[POSIX character class](/jarhart/rattler/docs/extended-matching-syntax/posix-character-classes)
that matches any whitespace character.

The rest of the grammar is a standard parsing expression grammar until we get
to the last line. The expression "`@("-"? DIGIT+ ("." DIGIT+)?)`" will match a
decimal number. The `@` is the 
[Token Operator](/jarhart/rattler/docs/extended-matching-syntax/token-operator)
which causes the expression to be matched as a single string instead of
producing a parse tree. The `DIGIT` character class matches decimal digits.

### Generate the parser

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

You can use the `--help` option to see all of the available command-line
options:

    $ arithmetic_parser.rb --help
    Usage: arithmetic_parser.rb [filenames] [options]

        -g, --graphviz                   Display the parse tree using GraphViz dotty
            --jpg FILENAME               Output the parse tree as a JPG file using GraphViz
            --png FILENAME               Output the parse tree as a PNG file using GraphViz
            --svg FILENAME               Output the parse tree as an SVG file using GraphViz
            --pdf FILENAME               Output the parse tree as a PDF file using GraphViz
            --ps FILENAME                Output the parse tree as a PS file using GraphViz
            --ps2 FILENAME               Output the parse tree as a PS2 file using GraphViz
            --eps FILENAME               Output the parse tree as an EPS file using GraphViz
        -f, --file FILENAME              Output the parse tree as a GraphViz DOT language file
        -d, --dot                        Output the parse tree in the GraphViz DOT language

        -h, --help                       Show this message

### Iterate

Let's try parentheses to see if the parser groups the operations correctly:

    $ echo "(1 + 2) / 3" | ruby arithmetic_parser.rb
    [["(", ["1", "+", "2"], ")"], "/", "3"]

The grouping works, but we get the parentheses in the parse tree, which we
really don't need. Let's fix that by using the `~` operator to
[skip](/jarhart/rattler/docs/extended-matching-syntax/skip-operator) those:

Change the line

    primary <-  "(" expr ")"

To read:

    primary <-  ~"(" expr ~")"


And regenerate the parser, using `-f` to force overwriting the file.

    $ rtlr arithmetic.rtlr -f
    arithmetic.rtlr -> arithmetic_parser.rb

Now when we try parsing the expression with parentheses:

    $ echo "(1 + 2) / 3" | ruby arithmetic_parser.rb
    [["1", "+", "2"], "/", "3"]

We get the correct grouping without the superflous parentheses in the result.

We're still just getting arrays of tokens, and while that makes it easy to see
the parse tree in this case, it doesn't help much when we want to add semantics.
Each type of operation is matched by a separate sequence expression, but that
information is partially lost by making everything an array. We can add
[semantic attributes](/jarhart/rattler/docs/semantics/node-actions) to capture
the different operations.

We'll start by just using generic parse nodes and giving them mnemonic names.
We can also discard the matched operator tokens themselves at this point.

Change the `expr` and `term` rules to look like this:

    expr    <-  expr ~"+" term      <"ADD">
              / expr ~"-" term      <"SUB">
              / term

    term    <-  term ~"*" primary   <"MUL">
              / term ~"/" primary   <"DIV">
              / primary

Don't forget the `~` in front of the operators to omit them from the parse
results.

Using parse nodes like this makes it very easy to see the parse tree with
graphviz, especially with more complex expressions.

    $ rtlr arithmetic.rtlr -f
    arithmetic.rtlr -> arithmetic_parser.rb
    $ echo "1+2*3/4-5+6-7*8/9" | ruby arithmetic_parser.rb -g

This feature is useful for debugging more complex grammars, but we can see that
our parser is parsing correctly, so let's finish by replacing the parse node
attributes with
[semantic actions](/jarhart/rattler/docs/semantics/semantic-actions) to perform
the arithmetic operations as it parses.

Change the `expr` and `term` rules to look like this:

    expr    <-  expr ~"+" term                  {|a, b| a + b }
              / expr ~"-" term                  {|a, b| a - b }
              / term

    term    <-  term ~"*" primary               {|a, b| a * b }
              / term ~"/" primary               {|a, b| a / b }
              / primary

Semantic actions look like ruby blocks and, for the most part, act like them
too. The parse results are bound to the parameters and the actions are
performed as soon as the parsing expression matches. The special `_` variable
can be used to refer to the entire parse results.

    $ echo "1+2*3/4-5+6-7*8/9" | bundle exec ruby arithmetic_parser.rb
    -2.7222222222222223

Success! Of course we could have accomplished the same thing with
"`eval ARGV.join`" but it's just a tutorial.

### Finish

There's one last finishing touch to add. As it is now, the parser will accept
any input the starts with a valid expression no matter what comes after it.
We'll add a new rule at the top so that it only matches if the entire input is
a valid expression:

    start   <-  expr EOF

The [`EOF`](/jarhart/rattler/docs/extended-matching-syntax/eof-symbol) symbol
matches only if there is no more input to parse.

Our final grammar looks like this:

    require 'rattler'

    parser ArithmeticParser < Rattler::Runtime::ExtendedPackratParser

    %whitespace SPACE*

    start   <-  expr EOF

    expr    <-  expr ~"+" term                  {|a, b| a + b }
              / expr ~"-" term                  {|a, b| a - b }
              / term

    term    <-  term ~"*" primary               {|a, b| a * b }
              / term ~"/" primary               {|a, b| a / b }
              / primary

    primary <-  ~"(" expr ~")"
              / @("-"? DIGIT+ ("." DIGIT+)?)    { _.to_f }
