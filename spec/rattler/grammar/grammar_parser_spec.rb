require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

include Rattler::Parsers

describe Rattler::Grammar::GrammarParser do
  include Rattler::Util::ParserSpecHelper
  
  it 'skips normal whitespace' do
    parsing("  \n\t foo").as(:identifier).should result_in('foo').at(8)
  end
  
  it 'skips comments' do
    parsing("\n# a comment\n\t foo").as(:identifier).
    should result_in('foo').at(18)
  end
  
  describe '#match(:identifier)' do
    it 'recognizes identifiers' do
      parsing(' fooBar ').as(:identifier).should result_in('fooBar').at(7)
      parsing(' FooBar ').as(:identifier).should result_in('FooBar').at(7)
      parsing(' EO ').as(:identifier).should result_in('EO').at(3)
      parsing(' EOFA ').as(:identifier).should result_in('EOFA').at(5)
    end
    
    it 'does not recognize EOF as identifier' do
      parsing('EOF').as(:identifier).should fail
    end
  end
  
  describe '#match(:eol)' do
    it 'recognizes end-of-line before end-of-file' do
      parsing("foo\nbar").from(3).as(:eol).should result_in(true).at(4)
      parsing("foobar").from(3).as(:eol).should fail
    end
    
    it 'recognizes end-of-file as end-of-line' do
      parsing("foo\nbar").from(7).as(:eol).should result_in(true).at(7)
    end
  end
  
  describe '#match(:eof_symbol)' do
    it 'recognizes the EOF symbol' do
      parsing(' EOF ').as(:eof_symbol).should result_in('EOF').at(4)
      parsing('EO').as(:eof_symbol).should fail
      parsing('EOF_').as(:eof_symbol).should fail
    end
  end
  
  describe '#match(:var_name)' do
    it 'recognizes variable names' do
      parsing(' fooBar ').as(:var_name).should result_in('fooBar').at(7)
      parsing(' FooBar ').as(:var_name).should fail
    end
  end
  
  describe '#match(:const_name)' do
    it 'recognizes constant names' do
      parsing(' FooBar ').as(:const_name).should result_in('FooBar').at(7)
      parsing(' Foo::Bar ').as(:const_name).should result_in('Foo').at(4)
      parsing(' fooBar ').as(:const_name).should fail
    end
  end
  
  describe '#match(:constant)' do
    it 'recognizes constants' do
      parsing(' Foo::Bar ').as(:constant).should result_in('Foo::Bar').at(9)
      parsing(' FooBar ').as(:constant).should result_in('FooBar').at(7)
    end
  end
  
  describe '#match(:literal)' do
    it 'recognizes string literals' do
      parsing(%{ "a string" }).as(:literal).should result_in(%{"a string"}).at(11)
      parsing(%{ 'a string' }).as(:literal).should result_in(%{'a string'}).at(11)
      parsing(%q{ "a \"string\"" }).as(:literal).
        should result_in(%q{"a \"string\""}).at(15)
    end
  end
  
  describe '#match(:class_char)' do
    it 'recognizes normal characters as class characters' do
      parsing('ab').as(:class_char).should result_in('a').at(1)
    end
    
    it 'recognizes octal codes as class characters' do
      parsing('\\247').as(:class_char).should result_in('\\247').at(4)
      parsing('\\2474').as(:class_char).should result_in('\\247').at(4)
    end
    
    it 'recognizes hex codes as class characters' do
      parsing('\\x7e').as(:class_char).should result_in('\\x7e').at(4)
      parsing('\\x7ee').as(:class_char).should result_in('\\x7e').at(4)
    end
    
    it 'recognizes the "any" character as a class character' do
      parsing('.').as(:class_char).should result_in('.').at(1)
    end
    
    it 'recognizes escaped characters as class characters' do
      parsing('\\]').as(:class_char).should result_in('\\]').at(2)
      parsing('\\\\').as(:class_char).should result_in('\\\\').at(2)
    end
  end
  
  describe '#match(:posix_name)' do
    it 'recognizes posix names' do
      for name in %w{alnum alpha blank cntrl digit graph lower print punct space upper xdigit}
        parsing(name).as(:posix_name).should result_in(name).at(name.length)
        parsing(name + 'a').as(:posix_name).should fail
        parsing(name + '0').as(:posix_name).should fail
        parsing(name + '_').as(:posix_name).should fail
      end
    end
  end
  
  describe '#match(:range)' do
    it 'recognizes posix character classes as class ranges' do
      for name in %w{alnum alpha blank cntrl digit graph lower print punct space upper xdigit}
        parsing("[:#{name}:] ").as(:range).should result_in("[:#{name}:]").
          at(name.length + 4)
      end
      parsing('[:foo:]').as(:range).should result_in('[').at(1)
    end
    
    it 'recognizes normal character ranges as class ranges' do
      parsing('A-Z ').as(:range).should result_in('A-Z').at(3)
    end
    
    it 'recognizes class characters as class ranges' do
      parsing('ab').as(:range).should result_in('a').at(1)
    end
  end
  
  describe '#match(:class)' do
    it 'recognizes character classes' do
      parsing(' [A-Za-z_] ').as(:class).should result_in('[A-Za-z_]').at(10)
    end
  end
  
  describe '#match(:regexp)' do
    it 'recognizes regexps' do
      parsing(' /\\d+(?:\\.\\d+)?/ ').as(:regexp).
        should result_in('/\\d+(?:\\.\\d+)?/').at(16)
    end
  end
  
  describe '#match(:atom)' do
    it 'recognizes EOF as an eof atom' do
      parsing(' EOF ').as(:atom).should result_in(Eof[]).at(4)
    end
    
    it 'recognizes "." as a regexp atom' do
      parsing(' . ').as(:atom).should result_in(Match[/./]).at(2)
    end
    
    it 'recognizes posix character class names as regexp atoms' do
      for name in %w{alnum alpha blank cntrl digit graph lower print punct space upper xdigit}
        parsing(" #{name} ").as(:atom).
        should result_in(Match[Regexp.compile("[[:#{name}:]]")]).
        at(name.length + 1)
      end
    end
    
    it 'recognizes identifiers as apply atoms' do
      parsing(' expr ').as(:atom).should result_in(Apply[:expr]).at(5)
    end
    
    it 'recognizes string literals as match atoms' do
      parsing(%{ "a string" }).as(:atom).should result_in(Match[/a\ string/]).at(11)
    end
    
    it 'recognizes character classes as match atoms' do
      parsing(' [A-Za-z_] ').as(:atom).should result_in(Match[/[A-Za-z_]/]).at(10)
    end
  end
  
  describe '#match(:term)' do
    it 'recognizes optional terms' do
      parsing(' expr? ').as(:term).should result_in(Optional[Apply[:expr]]).at(6)
    end
    
    it 'recognizes zero-or-more terms' do
      parsing(' expr* ').as(:term).should result_in(ZeroOrMore[Apply[:expr]]).at(6)
    end
    
    it 'recognizes one-or-more terms' do
      parsing(' expr+ ').as(:term).should result_in(OneOrMore[Apply[:expr]]).at(6)
    end
    
    it 'recognizes assert terms' do
      parsing(' &expr ').as(:term).should result_in(Assert[Apply[:expr]]).at(6)
    end
    
    it 'recognizes disallow terms' do
      parsing(' !expr ').as(:term).should result_in(Disallow[Apply[:expr]]).at(6)
    end
    
    it 'recognizes skip terms' do
      parsing(' ~expr ').as(:term).should result_in(Skip[Apply[:expr]]).at(6)
    end
    
    it 'recognizes token terms' do
      parsing(' @expr ').as(:term).should result_in(Token[Apply[:expr]]).at(6)
    end
    
    it 'recognizes labeled terms' do
      parsing(' val:expr ').as(:term).should result_in(Label[:val, Apply[:expr]]).at(9)
    end
    
    it 'recognizes fail expressions' do
      parsing(' fail("bad!") ').as(:term).
        should result_in(Fail[:expr, 'bad!']).at(13)
      parsing(' fail "bad!" ').as(:term).
        should result_in(Fail[:expr, 'bad!']).at(12)
    end
    
    it 'recognizes fail_rule expressions' do
      parsing(' fail_rule("bad!") ').as(:term).
        should result_in(Fail[:rule, 'bad!']).at(18)
      parsing(' fail_rule "bad!" ').as(:term).
        should result_in(Fail[:rule, 'bad!']).at(17)
    end
    
    it 'recognizes fail_parse expressions' do
      parsing(' fail_parse("bad!") ').as(:term).
        should result_in(Fail[:parse, 'bad!']).at(19)
      parsing(' fail_parse "bad!" ').as(:term).
        should result_in(Fail[:parse, 'bad!']).at(18)
    end
  end
  
  describe '#match(:attribute)' do
    it 'recognizes dispatch-action attributes with variables as targets' do
      parsing(' <expr> ').as(:attribute).should result_in(['expr']).at(7)
    end
    
    it 'recognizes dispatch-action attributes with constants as targets' do
      parsing(' <Foo::Bar> ').as(:attribute).should result_in(['Foo::Bar']).at(11)
    end
    
    it 'recognizes dispatch-action attributes with empty targets' do
      parsing(' <> ').as(:attribute).should result_in([]).at(3)
    end
  end
  
  describe '#match(:action)' do
    it 'recognizes symantic actions' do
      parsing(' {|_| _.to_f } ').as(:action).should result_in('|_| _.to_f ').at(14)
    end
    
    it 'recognizes shorcut symantic attributes' do
		  parsing(' <.expr> ').as(:action).should result_in('|_| _.expr').at(8)
    end
  end
  
  describe '#match(:expression)' do
    it 'recognizes dispatch-action-attributed term expressions' do
      parsing(' expr <Expr> ').as(:expression).
        should result_in(DispatchAction[Apply[:expr], {:target => 'Expr', :method => 'parsed'}]).
        at(12)
    end
    
    it 'recognizes direct-action-attributed term expressions' do
      parsing(' digits {|_| _.to_i} ').as(:expression).
        should result_in(DirectAction[Apply[:digits], '|_| _.to_i']).at(20)
    end
    
    it 'recognizes sequence expressions' do
      parsing(' name "=" value ').as(:expression).
        should result_in(Sequence[Apply[:name], Match[/=/], Apply[:value]]).at(15)
    end
    
    it 'recognizes attributed sequence expressions' do
      parsing(' name "=" value <Assign>').as(:expression).
        should result_in(DispatchAction[
                          Sequence[Apply[:name], Match[/=/], Apply[:value]],
                          {:target => 'Assign', :method => 'parsed'}]).
                at(24)
    end
    
    it 'recognizes choice expressions' do
      parsing(' string | number ').as(:expression).
        should result_in(Choice[Apply[:string], Apply[:number]]).at(16)
    end
  end
  
end
