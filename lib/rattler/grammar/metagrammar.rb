require 'rattler/grammar'

module Rattler
  module Grammar
    # @private
    module Metagrammar #:nodoc:
      
      include Rattler::Parsers
      
      # @private
      def start_rule #:nodoc:
        :grammar
      end
      
      # @private
      def match_grammar #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = begin
            p1 = @scanner.pos
            begin
              (r1_0 = begin
                a0 = []
                while r = begin
                  @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>require)(?![[:alnum:]_])))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?!(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))(?>.))+))(?>(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))/) &&
                  @scanner[1]
                end
                  a0 << r
                end
                ({ :requires => select_captures(a0) })
              end) &&
              (r1_1 = ((r = begin
                begin
                  p2 = @scanner.pos
                  begin
                    (r2_0 = begin
                      @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>parser)(?![[:alnum:]_])))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*)))/) &&
                      @scanner[1]
                    end) &&
                    (r2_1 = ((r = begin
                      @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*)))/) &&
                      @scanner[1]
                    end) ? [r] : [])) &&
                    @scanner.skip(/(?>(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))/) &&
                    (parser_decl r2_0, r2_1)
                  end || begin
                    @scanner.pos = p2
                    false
                  end
                end ||
                begin
                  @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>grammar)(?![[:alnum:]_])))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*)))(?>(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))/) &&
                  ({ :grammar_name => @scanner[1] })
                end
              end) ? [r] : [])) &&
              (r1_2 = begin
                a0 = []
                while r = begin
                  @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>include)(?![[:alnum:]_])))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*)))(?>(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))/) &&
                  @scanner[1]
                end
                  a0 << r
                end
                ({ :includes => select_captures(a0) })
              end) &&
              (heading r1_0, r1_1, r1_2)
            end || begin
              @scanner.pos = p1
              false
            end
          end) &&
          (r0_1 = begin
            a0 = []
            while r = begin
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%whitespace)(?![[:alnum:]_]))/) &&
                  (r1_0 = match(:unattributed)) &&
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
                  (start_ws r1_0)
                end || begin
                  @scanner.pos = p1
                  false
                end
              end ||
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%whitespace)(?![[:alnum:]_]))/) &&
                  (r1_0 = match(:unattributed)) &&
                  (set_ws r1_0)
                end || begin
                  @scanner.pos = p1
                  false
                end
              end ||
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%word_character)(?![[:alnum:]_]))/) &&
                  (r1_0 = match(:unattributed)) &&
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
                  (start_wc r1_0)
                end || begin
                  @scanner.pos = p1
                  false
                end
              end ||
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%word_character)(?![[:alnum:]_]))/) &&
                  (r1_0 = match(:unattributed)) &&
                  (set_wc r1_0)
                end || begin
                  @scanner.pos = p1
                  false
                end
              end ||
              begin
                @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%inline)(?![[:alnum:]_])))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{))/) &&
                (start_inline)
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%inline)(?![[:alnum:]_]))/) &&
                (set_inline)
              end ||
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>EOF)(?![[:alnum:]_])))/) &&
                  (r1_0 = begin
                    @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:alpha:]])(?>(?>[[:alnum:]_])*)))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><\-))/) &&
                    @scanner[1]
                  end) &&
                  (r1_1 = match(:expression)) &&
                  (rule r1_0, r1_1)
                end || begin
                  @scanner.pos = p1
                  false
                end
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\})/) &&
                (end_block)
              end
            end
              a0 << r
            end
            RuleSet.parsed(select_captures(a0)) unless a0.empty?
          end) &&
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)\z/) &&
          Grammar.parsed([r0_0, r0_1])
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_unattributed #:nodoc:
        memoize_lr :match_unattributed!
      end
      
      # @private
      def match_unattributed! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:unattributed)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\/)/) &&
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
      def match_expression #:nodoc:
        memoize_lr :match_expression!
      end
      
      # @private
      def match_expression! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:expression)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\/)/) &&
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
        memoize_lr :match_attributed!
      end
      
      # @private
      def match_attributed! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = ((r = match(:attributed)) ? [r] : [])) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><)/) &&
            (r0_1 = ((r = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>[[:lower:]])(?>(?>[[:alnum:]_])*))|(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*)))(?>(?>(?>\.)(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>[[:lower:]])(?>(?>[[:alnum:]_])*))))?))/) &&
              @scanner[1]
            end) ? [r] : [])) &&
            (r0_2 = ((r = begin
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>"))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>')(?>(?>(?>\\)(?>.)|[^'])*)(?>'))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\()(?>(?>(?>\\)(?>.)|[^)])*)(?>\)))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\{)(?>(?>(?>\\)(?>.)|[^}])*)(?>\}))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\[)(?>(?>(?>\\)(?>.)|[^\]])*)(?>\]))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%<)(?>(?>(?>\\)(?>.)|[^>])*)(?>>))/) &&
                @scanner[1]
              end ||
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
                  begin
                    p2 = @scanner.pos
                    begin
                      @scanner.skip(/%/) &&
                      (r2_0 = @scanner.scan(/[[:punct:]]/)) &&
                      begin
                        while begin
                          @scanner.skip(/(?>\\)(?>.)/) ||
                          begin
                            p3 = @scanner.pos
                            begin
                              @scanner.skip(/(?!#{r2_0})/) &&
                              @scanner.skip(/./) &&
                              true
                            end || begin
                              @scanner.pos = p3
                              false
                            end
                          end
                        end; end
                        true
                      end &&
                      @scanner.skip(/#{r2_0}/) &&
                      @scanner.string[p2...(@scanner.pos)]
                    end || begin
                      @scanner.pos = p2
                      false
                    end
                  end
                end || begin
                  @scanner.pos = p1
                  false
                end
              end
            end) ? [r] : [])) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>>)/) &&
            DispatchAction.parsed([r0_0, r0_1, r0_2])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = ((r = match(:attributed)) ? [r] : [])) &&
            (r0_1 = begin
              @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>\{)(?>(?>[^}])*)(?>\})|[^{}])*))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\}))/) &&
              @scanner[1]
            end) &&
            DirectAction.parsed([r0_0, r0_1])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = ((r = match(:attributed)) ? [r] : [])) &&
            (r0_1 = begin
              @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>~))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>\{)(?>(?>[^}])*)(?>\})|[^{}])*))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\}))/) &&
              @scanner[1]
            end) &&
            SideEffect.parsed([r0_0, r0_1])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = ((r = match(:attributed)) ? [r] : [])) &&
            (r0_1 = begin
              @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>&))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>\{)(?>(?>[^}])*)(?>\})|[^{}])*))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\}))/) &&
              @scanner[1]
            end) &&
            SemanticAssert.parsed([r0_0, r0_1])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = ((r = match(:attributed)) ? [r] : [])) &&
            (r0_1 = begin
              @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>!))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>\{)(?>(?>[^}])*)(?>\})|[^{}])*))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\}))/) &&
              @scanner[1]
            end) &&
            SemanticDisallow.parsed([r0_0, r0_1])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:attributed_terms)
      end
      
      # @private
      def match_attributed_terms #:nodoc:
        memoize_lr :match_attributed_terms!
      end
      
      # @private
      def match_attributed_terms! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:attributed)) &&
            (r0_1 = match(:term)) &&
            Sequence.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:terms)
      end
      
      # @private
      def match_terms #:nodoc:
        memoize_lr :match_terms!
      end
      
      # @private
      def match_terms! #:nodoc:
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
        memoize :match_term!
      end
      
      # @private
      def match_term! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>fail)(?![[:alnum:]_]))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>fail_rule)(?![[:alnum:]_]))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>fail_parse)(?![[:alnum:]_]))/) &&
                @scanner[1]
              end
            end) &&
            (r0_1 = begin
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\()/) &&
                  (r1_0 = begin
                    begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>"))/) &&
                      @scanner[1]
                    end ||
                    begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>')(?>(?>(?>\\)(?>.)|[^'])*)(?>'))/) &&
                      @scanner[1]
                    end ||
                    begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\()(?>(?>(?>\\)(?>.)|[^)])*)(?>\)))/) &&
                      @scanner[1]
                    end ||
                    begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\{)(?>(?>(?>\\)(?>.)|[^}])*)(?>\}))/) &&
                      @scanner[1]
                    end ||
                    begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\[)(?>(?>(?>\\)(?>.)|[^\]])*)(?>\]))/) &&
                      @scanner[1]
                    end ||
                    begin
                      @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%<)(?>(?>(?>\\)(?>.)|[^>])*)(?>>))/) &&
                      @scanner[1]
                    end ||
                    begin
                      p2 = @scanner.pos
                      begin
                        @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
                        begin
                          p3 = @scanner.pos
                          begin
                            @scanner.skip(/%/) &&
                            (r3_0 = @scanner.scan(/[[:punct:]]/)) &&
                            begin
                              while begin
                                @scanner.skip(/(?>\\)(?>.)/) ||
                                begin
                                  p4 = @scanner.pos
                                  begin
                                    @scanner.skip(/(?!#{r3_0})/) &&
                                    @scanner.skip(/./) &&
                                    true
                                  end || begin
                                    @scanner.pos = p4
                                    false
                                  end
                                end
                              end; end
                              true
                            end &&
                            @scanner.skip(/#{r3_0}/) &&
                            @scanner.string[p3...(@scanner.pos)]
                          end || begin
                            @scanner.pos = p3
                            false
                          end
                        end
                      end || begin
                        @scanner.pos = p2
                        false
                      end
                    end
                  end) &&
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\))/) &&
                  r1_0
                end || begin
                  @scanner.pos = p1
                  false
                end
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>"))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>')(?>(?>(?>\\)(?>.)|[^'])*)(?>'))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\()(?>(?>(?>\\)(?>.)|[^)])*)(?>\)))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\{)(?>(?>(?>\\)(?>.)|[^}])*)(?>\}))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\[)(?>(?>(?>\\)(?>.)|[^\]])*)(?>\]))/) &&
                @scanner[1]
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%<)(?>(?>(?>\\)(?>.)|[^>])*)(?>>))/) &&
                @scanner[1]
              end ||
              begin
                p1 = @scanner.pos
                begin
                  @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
                  begin
                    p2 = @scanner.pos
                    begin
                      @scanner.skip(/%/) &&
                      (r2_0 = @scanner.scan(/[[:punct:]]/)) &&
                      begin
                        while begin
                          @scanner.skip(/(?>\\)(?>.)/) ||
                          begin
                            p3 = @scanner.pos
                            begin
                              @scanner.skip(/(?!#{r2_0})/) &&
                              @scanner.skip(/./) &&
                              true
                            end || begin
                              @scanner.pos = p3
                              false
                            end
                          end
                        end; end
                        true
                      end &&
                      @scanner.skip(/#{r2_0}/) &&
                      @scanner.string[p2...(@scanner.pos)]
                    end || begin
                      @scanner.pos = p2
                      false
                    end
                  end
                end || begin
                  @scanner.pos = p1
                  false
                end
              end
            end) &&
            Fail.parsed([r0_0, r0_1])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:labeled) ||
        match(:labelable)
      end
      
      # @private
      def match_labeled #:nodoc:
        memoize :match_labeled!
      end
      
      # @private
      def match_labeled! #:nodoc:
        p0 = @scanner.pos
        begin
          (r0_0 = begin
            @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:lower:]])(?>(?>[[:alnum:]_])*)))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>:))/) &&
            @scanner[1]
          end) &&
          (r0_1 = match(:labelable)) &&
          Label.parsed(select_captures([r0_0, r0_1]))
        end || begin
          @scanner.pos = p0
          false
        end
      end
      
      # @private
      def match_labelable #:nodoc:
        memoize :match_labelable!
      end
      
      # @private
      def match_labelable! #:nodoc:
        match(:list) ||
        match(:list_term)
      end
      
      # @private
      def match_list #:nodoc:
        memoize :match_list!
      end
      
      # @private
      def match_list! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:list_term)) &&
            @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\*))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,))/) &&
            (r0_1 = match(:list_term)) &&
            (list0 r0_0, r0_1)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:list_term)) &&
            @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\+))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,))/) &&
            (r0_1 = match(:list_term)) &&
            (list1 r0_0, r0_1)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:list_term)) &&
            (r0_1 = begin
              begin
                @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.\.))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+))/) &&
                ([@scanner[1], @scanner[2]].map {|s| s.to_i })
              end ||
              begin
                @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.\.))/) &&
                ([@scanner[1].to_i, nil])
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+)/) &&
                ([@scanner[1].to_i] * 2)
              end
            end) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,)/) &&
            (r0_2 = match(:list_term)) &&
            ListParser.parsed(select_captures([r0_0, r0_1, r0_2]))
          end || begin
            @scanner.pos = p0
            false
          end
        end
      end
      
      # @private
      def match_list_term #:nodoc:
        memoize :match_list_term!
      end
      
      # @private
      def match_list_term! #:nodoc:
        match(:prefixed) ||
        match(:prefixable) ||
        (fail! { "term expected" })
      end
      
      # @private
      def match_prefixed #:nodoc:
        memoize :match_prefixed!
      end
      
      # @private
      def match_prefixed! #:nodoc:
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
        memoize :match_prefixable!
      end
      
      # @private
      def match_prefixable! #:nodoc:
        match(:suffixed) ||
        match(:primary)
      end
      
      # @private
      def match_suffixed #:nodoc:
        memoize :match_suffixed!
      end
      
      # @private
      def match_suffixed! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:primary)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\?)/) &&
            (optional r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:primary)) &&
            @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\*))(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,))/) &&
            (zero_or_more r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:primary)) &&
            @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\+))(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,))/) &&
            (one_or_more r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:primary)) &&
            (r0_1 = begin
              begin
                @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.\.))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+))/) &&
                ([@scanner[1], @scanner[2]].map {|s| s.to_i })
              end ||
              begin
                @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.\.))/) &&
                ([@scanner[1].to_i, nil])
              end ||
              begin
                @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+)/) &&
                ([@scanner[1].to_i] * 2)
              end
            end) &&
            @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,))/) &&
            Repeat.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end
      end
      
      # @private
      def match_primary #:nodoc:
        memoize :match_primary!
      end
      
      # @private
      def match_primary! #:nodoc:
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
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>EOF)(?![[:alnum:]_]))/) &&
          Eof.parsed([])
        end ||
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>E)(?![[:alnum:]_]))/) &&
          ESymbol.parsed([])
        end ||
        begin
          (r = begin
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>ALNUM)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>ALPHA)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>ASCII)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>BLANK)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>CNTRL)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>DIGIT)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>GRAPH)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>LOWER)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>PRINT)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>PUNCT)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>SPACE)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>UPPER)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>XDIGIT)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>WORD)(?![[:alnum:]_]))/) &&
              @scanner[1]
            end ||
            (fail! { "posix_class expected" })
          end) && (posix_class r)
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>EOF)(?![[:alnum:]_])))/) &&
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:alpha:]])(?>(?>[[:alnum:]_])*))/) &&
              @scanner[1]
            end) &&
            @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><\-))/) &&
            Apply.parsed([r0_0])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          (r = begin
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>")(?>(?>(?>\\)(?>.)|[^"])*)(?>"))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>')(?>(?>(?>\\)(?>.)|[^'])*)(?>'))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\()(?>(?>(?>\\)(?>.)|[^)])*)(?>\)))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\{)(?>(?>(?>\\)(?>.)|[^}])*)(?>\}))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%\[)(?>(?>(?>\\)(?>.)|[^\]])*)(?>\]))/) &&
              @scanner[1]
            end ||
            begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>%<)(?>(?>(?>\\)(?>.)|[^>])*)(?>>))/) &&
              @scanner[1]
            end ||
            begin
              p0 = @scanner.pos
              begin
                @scanner.skip(/(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*/) &&
                begin
                  p1 = @scanner.pos
                  begin
                    @scanner.skip(/%/) &&
                    (r1_0 = @scanner.scan(/[[:punct:]]/)) &&
                    begin
                      while begin
                        @scanner.skip(/(?>\\)(?>.)/) ||
                        begin
                          p2 = @scanner.pos
                          begin
                            @scanner.skip(/(?!#{r1_0})/) &&
                            @scanner.skip(/./) &&
                            true
                          end || begin
                            @scanner.pos = p2
                            false
                          end
                        end
                      end; end
                      true
                    end &&
                    @scanner.skip(/#{r1_0}/) &&
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
          end) && (literal r)
        end ||
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>`)(?>(?>(?>\\)(?>.)|[^`])*)(?>`))/) &&
          (word_literal @scanner[1])
        end ||
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>\[)(?>(?>(?!\])(?>(?>\[:)(?>(?>alnum)(?![[:alnum:]_])|(?>alpha)(?![[:alnum:]_])|(?>ascii)(?![[:alnum:]_])|(?>blank)(?![[:alnum:]_])|(?>cntrl)(?![[:alnum:]_])|(?>digit)(?![[:alnum:]_])|(?>graph)(?![[:alnum:]_])|(?>lower)(?![[:alnum:]_])|(?>print)(?![[:alnum:]_])|(?>punct)(?![[:alnum:]_])|(?>space)(?![[:alnum:]_])|(?>upper)(?![[:alnum:]_])|(?>xdigit)(?![[:alnum:]_]))(?>:\])|(?>(?>\\)(?>[0-3])(?>[0-7])(?>[0-7])|(?>\\x)(?>[[:xdigit:]])(?>[[:xdigit:]])|(?>\\)(?>.)|[^\\\]])(?>(?>(?>\-)(?>(?>\\)(?>[0-3])(?>[0-7])(?>[0-7])|(?>\\x)(?>[[:xdigit:]])(?>[[:xdigit:]])|(?>\\)(?>.)|[^\\\]]))?)))+)(?>\]))/) &&
          (char_class @scanner[1])
        end ||
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>\$)(?>[[:lower:]])(?>(?>[[:alnum:]_])*))/) &&
          BackReference.parsed([@scanner[1]])
        end ||
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.)/) &&
          (Match[/./])
        end ||
        (fail! { "atom expected" })
      end
      
    end
  end
end
