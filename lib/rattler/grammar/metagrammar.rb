require 'rattler/grammar'

module Rattler
  module Grammar
    # @private
    module Metagrammar #:nodoc:
      
      include Rattler::Parsers
      
      # @private
      def match_grammar #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = match(:heading)) &&
          (r0_1 = match(:rules)) &&
          begin
            p1 = @scanner.pos
            begin
              @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
              @scanner.eos? &&
              true
            end || begin
              @scanner.pos = p1
              false
            end
          end &&
          Grammar.parsed(select_captures([r0_0, r0_1]))
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_heading #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = match(:requires)) &&
          (r0_1 = ((r = match(:module_decl)) ? [r] : [])) &&
          (r0_2 = match(:includes)) &&
          (heading r0_0, r0_1, r0_2)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_requires #:nodoc:
        a0 = []
        while r = match(:require_decl)
          a0 << r
        end
        ({:requires => select_captures(a0)})
      end
      
      # @private
      def match_module_decl #:nodoc:
        match(:parser_decl) ||
        match(:grammar_decl)
      end
      
      # @private
      def match_includes #:nodoc:
        a0 = []
        while r = match(:include_decl)
          a0 << r
        end
        ({:includes => select_captures(a0)})
      end
      
      # @private
      def match_require_decl #:nodoc:
        p0 = @scanner.pos
        begin
          match(:require_word) &&
          (r0_0 = match(:literal)) &&
          match(:eol) &&
          r0_0
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_parser_decl #:nodoc:
        p0 = @scanner.pos
        begin
          match(:parser_word) &&
          (r0_0 = match(:constant)) &&
          (r0_1 = ((r = begin
            p1 = @scanner.pos
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><)/) &&
              match(:constant)
            end || begin
              @scanner.pos = p1
              false
            end
          end) ? [r] : [])) &&
          match(:eol) &&
          (parser_decl r0_0, r0_1)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_grammar_decl #:nodoc:
        p0 = @scanner.pos
        begin
          match(:grammar_word) &&
          (r0_0 = match(:constant)) &&
          match(:eol) &&
          ({:grammar_name => r0_0})
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_include_decl #:nodoc:
        p0 = @scanner.pos
        begin
          match(:include_word) &&
          (r0_0 = match(:constant)) &&
          match(:eol) &&
          r0_0
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_require_word #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(?>require)(?>(?![[:alnum:]]|_))/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_parser_word #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(?>parser)(?>(?![[:alnum:]]|_))/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_grammar_word #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(?>grammar)(?>(?![[:alnum:]]|_))/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_include_word #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(?>include)(?>(?![[:alnum:]]|_))/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_rules #:nodoc:
        a0 = []
        while r = match(:ws_directive) ||
        match(:rule) ||
        match(:ws_block_close)
          a0 << r
        end
        Rules.parsed(select_captures(a0)) unless a0.empty?
      end
      
      # @private
      def match_ws_directive #:nodoc:
        ((r = match(:ws_block_open)) && (start_ws r)) ||
        ((r = match(:ws_decl)) && (set_ws r))
      end
      
      # @private
      def match_ws_block_open #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = match(:ws_decl)) &&
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
          r0_0
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_ws_decl #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>%whitespace)/) &&
          match(:ws_expr)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_ws_block_close #:nodoc:
        @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\})/) &&
        (end_ws )
      end
      
      # @private
      def match_ws_expr #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:ws_expr)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\|)/) &&
            (r0_1 = match(:terms)) &&
            Choice.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:terms)
      end
      
      # @private
      def match_rule #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = match(:identifier)) &&
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><\-)/) &&
          (r0_1 = match(:expression)) &&
          (rule r0_0, r0_1)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_expression #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:expression)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\|)/) &&
            (r0_1 = match(:attributed)) &&
            Choice.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:attributed)
      end
      
      # @private
      def match_attributed #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:attributed)) &&
            (r0_1 = match(:attribute)) &&
            DispatchAction.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:attributed)) &&
            (r0_1 = match(:action)) &&
            DirectAction.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:terms)
      end
      
      # @private
      def match_attribute #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><)/) &&
          (r0_0 = ((r = match(:option)) ? [r] : [])) &&
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>>)/) &&
          r0_0
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_option #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          begin
            p1 = @scanner.pos
            begin
              match(:name) &&
              begin
                match(:method)
                true
              end &&
              @scanner.string[p1...(@scanner.pos)]
            end || begin
              @scanner.pos = p1
              false
            end
          end
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_method #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.)/) &&
          match(:var_name)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_action #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
            (r0_0 = begin
              p1 = @scanner.pos
              begin
                @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
                @scanner.scan(/(?>(?>\{)(?>(?>[^}])*)(?>\})|[^{}])*/)
              end || begin
                @scanner.pos = p1
                false
              end
            end) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\})/) &&
            r0_0
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><)/) &&
            (r0_0 = match(:method)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>>)/) &&
            ("|_| _.#{r0_0}")
          end || begin
            @scanner.pos = p0
            false
          end
        end
      end
      
      # @private
      def match_terms #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:terms)) &&
            (r0_1 = match(:term)) &&
            Sequence.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:term)
      end
      
      # @private
      def match_term #:nodoc:
        match(:fail_expr) ||
        match(:labeled) ||
        match(:prefixed) ||
        match(:suffixed) ||
        match(:primary)
      end
      
      # @private
      def match_fail_expr #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = match(:fail_word)) &&
          (r0_1 = match(:fail_arg)) &&
          Fail.parsed(select_captures([r0_0, r0_1]))
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_fail_word #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(?>fail)(?>(?>_rule|_parse)?)(?>(?![[:alnum:]]|_))/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_fail_arg #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\()/) &&
            (r0_0 = match(:literal)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\))/) &&
            r0_0
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:literal)
      end
      
      # @private
      def match_labeled #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = match(:label)) &&
          (r0_1 = begin
            match(:prefixed) ||
            match(:prefixable)
          end) &&
          Label.parsed(select_captures([r0_0, r0_1]))
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_label #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = match(:var_name)) &&
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>:)/) &&
          r0_0
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_prefixed #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>&)/) &&
            (r0_0 = match(:prefixable)) &&
            Assert.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>!)/) &&
            (r0_0 = match(:prefixable)) &&
            Disallow.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>~)/) &&
            (r0_0 = match(:prefixable)) &&
            Skip.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>@)/) &&
            (r0_0 = match(:prefixable)) &&
            Token.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end
      end
      
      # @private
      def match_prefixable #:nodoc:
        match(:suffixed) ||
        match(:primary)
      end
      
      # @private
      def match_suffixed #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:primary)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\?)/) &&
            Optional.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:primary)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\*)/) &&
            ZeroOrMore.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:primary)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\+)/) &&
            OneOrMore.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end
      end
      
      # @private
      def match_primary #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\()/) &&
            (r0_0 = match(:expression)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\))/) &&
            r0_0
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:atom)
      end
      
      # @private
      def match_atom #:nodoc:
        ((r = match(:eof_symbol)) && Eof.parsed([r])) ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
            (r0_0 = begin
              tp = @scanner.pos
              match(:posix_name) &&
              @scanner.string[tp...(@scanner.pos)]
            end) &&
            (posix_class r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:identifier)) &&
            begin
              p1 = @scanner.pos
              r = !begin
                @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
                @scanner.skip(/<\-/)
              end
              @scanner.pos = p1
              r
            end &&
            Apply.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        ((r = match(:literal)) && (literal r)) ||
        ((r = match(:class)) && (char_class r)) ||
        ((r = match(:regexp)) && Match.parsed([r])) ||
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.)/) &&
          (Match[/./] )
        end
      end
      
      # @private
      def match_literal #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(["'])(?:\\.|(?:(?!\1).))*\1/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_class #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          begin
            p1 = @scanner.pos
            begin
              @scanner.skip(/\[/) &&
              begin
                r = false
                while begin
                  p2 = @scanner.pos
                  begin
                    @scanner.skip(/(?!\])/) &&
                    match(:range) &&
                    true
                  end || begin
                    @scanner.pos = p2
                    false
                  end
                end
                  r = true
                end
                r
              end &&
              @scanner.skip(/\]/) &&
              @scanner.string[p1...(@scanner.pos)]
            end || begin
              @scanner.pos = p1
              false
            end
          end
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_regexp #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/\/(?:\\.|[^\/])+\/(?:[iomx]+(?!\w))?/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_name #:nodoc:
        match(:var_name) ||
        match(:constant)
      end
      
      # @private
      def match_identifier #:nodoc:
        p0 = @scanner.pos
        begin
          begin
            p0 = @scanner.pos
            r = !match(:eof_symbol)
            @scanner.pos = p0
            r
          end &&
          begin
            p1 = @scanner.pos
            begin
              @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
              @scanner.scan(/(?>[[:alnum:]]|_)+/)
            end || begin
              @scanner.pos = p1
              false
            end
          end
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_var_name #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(?>[[:lower:]])(?>(?>[[:alnum:]]|_)*)/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_constant #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          begin
            p1 = @scanner.pos
            begin
              begin
                while begin
                  p2 = @scanner.pos
                  begin
                    match(:const_name) &&
                    @scanner.skip(/::/) &&
                    true
                  end || begin
                    @scanner.pos = p2
                    false
                  end
                end; end
                true
              end &&
              match(:const_name) &&
              @scanner.string[p1...(@scanner.pos)]
            end || begin
              @scanner.pos = p1
              false
            end
          end
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_const_name #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(?>[[:upper:]])(?>(?>[[:alnum:]]|_)*)/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_eof_symbol #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
          @scanner.scan(/(?>EOF)(?>(?![[:alnum:]]|_))/)
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_range #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/\[:/) &&
            match(:posix_name) &&
            @scanner.skip(/:\]/) &&
            @scanner.string[p0...(@scanner.pos)]
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            match(:class_char) &&
            begin
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/\-/) &&
                  match(:class_char) &&
                  true
                end || begin
                  @scanner.pos = p1
                  false
                end
              end
              true
            end &&
            @scanner.string[p0...(@scanner.pos)]
          end || begin
            @scanner.pos = p0
            false
          end
        end
      end
      
      # @private
      def match_posix_name #:nodoc:
        @scanner.scan(/(?>alnum|alpha|ascii|blank|cntrl|digit|graph|lower|print|punct|space|upper|xdigit|word)(?>(?![[:alnum:]]|_))/)
      end
      
      # @private
      def match_class_char #:nodoc:
        @scanner.scan(/(?>\\)(?>[0-3])(?>[0-7])(?>[0-7])|(?>\\x)(?>[[:xdigit:]])(?>[[:xdigit:]])|(?>\\)(?>.)|[^\\\]]/)
      end
      
      # @private
      def match_eol #:nodoc:
        p0 = @scanner.pos
        begin
          @scanner.skip(/(?>[[:blank:]])*/) &&
          begin
            @scanner.eos? ||
            @scanner.skip(/;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)/)
          end &&
          true
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
    end
  end
end
