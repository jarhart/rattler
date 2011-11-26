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
        apply :match_grammar!
      end
      
      # @private
      def match_grammar! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:heading)) &&
            (r0_1 = match(:rules)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)\z/) &&
            Grammar.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :grammar }
      end
      
      # @private
      def match_heading #:nodoc:
        apply :match_heading!
      end
      
      # @private
      def match_heading! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:requires)) &&
            (r0_1 = ((r = match(:module_decl)) ? [r] : [])) &&
            (r0_2 = match(:includes)) &&
            (r0_3 = ((r = match(:start_directive)) ? [r] : [])) &&
            (heading r0_0, r0_1, r0_2, r0_3)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :heading }
      end
      
      # @private
      def match_requires #:nodoc:
        apply :match_requires!
      end
      
      # @private
      def match_requires! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              a0 = []
              while r = match(:require_statement)
                a0 << r
              end
              select_captures(a0)
            end) &&
            ({ :requires => r0_0 })
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :requires }
      end
      
      # @private
      def match_require_statement #:nodoc:
        apply :match_require_statement!
      end
      
      # @private
      def match_require_statement! #:nodoc:
        begin
          @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>require)(?![[:alnum:]_])))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?!(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))(?>.))+))(?>(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))/) &&
          @scanner[1]
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>require_relative)(?![[:alnum:]_]))/) &&
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?!(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))(?>.))+)/) &&
              @scanner[1]
            end) &&
            @scanner.skip(/(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*))/) &&
            (expand_relative r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :require_statement }
      end
      
      # @private
      def match_module_decl #:nodoc:
        apply :match_module_decl!
      end
      
      # @private
      def match_module_decl! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>parser)(?![[:alnum:]_]))/) &&
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*))/) &&
              @scanner[1]
            end) &&
            (r0_1 = ((r = begin
              @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*)))/) &&
              @scanner[1]
            end) ? [r] : [])) &&
            @scanner.skip(/(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*))/) &&
            (parser_decl r0_0, r0_1)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>grammar)(?![[:alnum:]_]))/) &&
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*))/) &&
              @scanner[1]
            end) &&
            @scanner.skip(/(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*))/) &&
            ({ :grammar_name => r0_0 })
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :module_decl }
      end
      
      # @private
      def match_includes #:nodoc:
        apply :match_includes!
      end
      
      # @private
      def match_includes! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              a0 = []
              while r = begin
                @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>include)(?![[:alnum:]_])))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*)))(?>(?>(?>[[:blank:]])*)(?>\z|;|(?>(?>\r)?)(?>\n)|(?>\#)(?>(?>[^\n])*)))/) &&
                @scanner[1]
              end
                a0 << r
              end
              a0
            end) &&
            ({ :includes => r0_0 })
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :includes }
      end
      
      # @private
      def match_start_directive #:nodoc:
        apply :match_start_directive!
      end
      
      # @private
      def match_start_directive! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%start)(?![[:alnum:]_]))/) &&
            (r0_0 = begin
              p1 = @scanner.pos
              begin
                @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>EOF)(?![[:alnum:]_])))/) &&
                begin
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:alpha:]])(?>(?>[[:alnum:]_])*))/) &&
                  @scanner[1]
                end
              end || begin
                @scanner.pos = p1
                false
              end
            end) &&
            ({ :start_rule => r0_0 })
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :start_directive }
      end
      
      # @private
      def match_rules #:nodoc:
        apply :match_rules!
      end
      
      # @private
      def match_rules! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              a0 = []
              while r = begin
                match(:directive) ||
                match(:rule) ||
                match(:block_close)
              end
                a0 << r
              end
              select_captures(a0)
            end) &&
            RuleSet.parsed([r0_0])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :rules }
      end
      
      # @private
      def match_directive #:nodoc:
        apply :match_directive!
      end
      
      # @private
      def match_directive! #:nodoc:
        match(:ws_directive) ||
        match(:wc_directive) ||
        match(:inline_directive) ||
        match(:fragments) ||
        fail! { :directive }
      end
      
      # @private
      def match_ws_directive #:nodoc:
        apply :match_ws_directive!
      end
      
      # @private
      def match_ws_directive! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:ws_decl)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
            (start_ws r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:ws_decl)) &&
            (set_ws r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :ws_directive }
      end
      
      # @private
      def match_ws_decl #:nodoc:
        apply :match_ws_decl!
      end
      
      # @private
      def match_ws_decl! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%whitespace)(?![[:alnum:]_]))/) &&
            match(:unattributed)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :ws_decl }
      end
      
      # @private
      def match_wc_directive #:nodoc:
        apply :match_wc_directive!
      end
      
      # @private
      def match_wc_directive! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:wc_decl)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
            (start_wc r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = match(:wc_decl)) &&
            (set_wc r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :wc_directive }
      end
      
      # @private
      def match_wc_decl #:nodoc:
        apply :match_wc_decl!
      end
      
      # @private
      def match_wc_decl! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%word_character)(?![[:alnum:]_]))/) &&
            match(:unattributed)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :wc_decl }
      end
      
      # @private
      def match_inline_directive #:nodoc:
        apply :match_inline_directive!
      end
      
      # @private
      def match_inline_directive! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%inline)(?![[:alnum:]_]))/) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
            (start_inline)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%inline)(?![[:alnum:]_]))/) &&
            (set_inline)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :inline_directive }
      end
      
      # @private
      def match_fragments #:nodoc:
        apply :match_fragments!
      end
      
      # @private
      def match_fragments! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%fragments)(?![[:alnum:]_]))/) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
            (start_fragments)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>%fragments)(?![[:alnum:]_]))/) &&
            (set_fragments)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :fragments }
      end
      
      # @private
      def match_block_close #:nodoc:
        apply :match_block_close!
      end
      
      # @private
      def match_block_close! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\})/) &&
            (end_block)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :block_close }
      end
      
      # @private
      def match_rule #:nodoc:
        apply :match_rule!
      end
      
      # @private
      def match_rule! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              p1 = @scanner.pos
              begin
                @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>EOF)(?![[:alnum:]_])))/) &&
                begin
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:alpha:]])(?>(?>[[:alnum:]_])*))/) &&
                  @scanner[1]
                end
              end || begin
                @scanner.pos = p1
                false
              end
            end) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><\-)/) &&
            (r0_1 = match(:expression)) &&
            (rule r0_0, r0_1)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :rule }
      end
      
      # @private
      def match_unattributed #:nodoc:
        apply :match_unattributed!
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
        match(:terms) ||
        fail! { :unattributed }
      end
      
      # @private
      def match_expression #:nodoc:
        apply :match_expression!
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
        match(:attributed) ||
        fail! { :expression }
      end
      
      # @private
      def match_attributed #:nodoc:
        apply :match_attributed!
      end
      
      # @private
      def match_attributed! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = ((r = match(:attributed)) ? [r] : [])) &&
            (r0_1 = begin
              match(:semantic_action) ||
              match(:node_action)
            end) &&
            AttributedSequence.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        match(:attributed_terms) ||
        fail! { :attributed }
      end
      
      # @private
      def match_old_node_action #:nodoc:
        apply :match_old_node_action!
      end
      
      # @private
      def match_old_node_action! #:nodoc:
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>[[:lower:]])(?>(?>[[:alnum:]_])*))|(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*)))(?>(?>(?>\.)(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>[[:lower:]])(?>(?>[[:alnum:]_])*))))?))/) &&
          @scanner[1]
        end ||
        fail { :old_node_action }
      end
      
      # @private
      def match_semantic_action #:nodoc:
        apply :match_semantic_action!
      end
      
      # @private
      def match_semantic_action! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\{)/) &&
            (r0_0 = match(:action_code)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\})/) &&
            SemanticAction.parsed(select_captures([r0_0]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :semantic_action }
      end
      
      # @private
      def match_action_code #:nodoc:
        apply :match_action_code!
      end
      
      # @private
      def match_action_code! #:nodoc:
        begin
          @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>\{)(?>(?>[^}])*)(?>\})|[^{}])*)/) &&
          @scanner[1]
        end ||
        fail { :action_code }
      end
      
      # @private
      def match_node_action #:nodoc:
        apply :match_node_action!
      end
      
      # @private
      def match_node_action! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><)/) &&
            (r0_0 = ((r = begin
              p1 = @scanner.pos
              begin
                (r1_0 = begin
                  begin
                    @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:lower:]])(?>(?>[[:alnum:]_])*))/) &&
                    @scanner[1]
                  end ||
                  begin
                    @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>(?>(?>[[:upper:]])(?>(?>[[:alnum:]_])*)(?>::))*)(?>[[:upper:]])(?>(?>[[:alnum:]_])*))/) &&
                    @scanner[1]
                  end
                end) &&
                (r1_1 = ((r = begin
                  @scanner.skip(/(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.))(?>(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:lower:]])(?>(?>[[:alnum:]_])*)))/) &&
                  @scanner[1]
                end) ? [r] : [])) &&
                [r1_0, r1_1]
              end || begin
                @scanner.pos = p1
                false
              end
            end) ? [r] : [])) &&
            (r0_1 = ((r = begin
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
            NodeAction.parsed([r0_0, r0_1])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :node_action }
      end
      
      # @private
      def match_attributed_terms #:nodoc:
        apply :match_attributed_terms!
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
        match(:terms) ||
        fail! { :attributed_terms }
      end
      
      # @private
      def match_terms #:nodoc:
        apply :match_terms!
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
        match(:term) ||
        fail! { :terms }
      end
      
      # @private
      def match_term #:nodoc:
        apply :match_term!
      end
      
      # @private
      def match_term! #:nodoc:
        match(:fail_expr) ||
        match(:labeled) ||
        match(:labelable) ||
        fail! { :term }
      end
      
      # @private
      def match_fail_expr #:nodoc:
        apply :match_fail_expr!
      end
      
      # @private
      def match_fail_expr! #:nodoc:
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
            (r0_1 = match(:fail_arg)) &&
            Fail.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :fail_expr }
      end
      
      # @private
      def match_fail_arg #:nodoc:
        apply :match_fail_arg!
      end
      
      # @private
      def match_fail_arg! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\()/) &&
            (r0_0 = begin
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
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\))/) &&
            r0_0
          end || begin
            @scanner.pos = p0
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
        end ||
        fail { :fail_arg }
      end
      
      # @private
      def match_labeled #:nodoc:
        apply :match_labeled!
      end
      
      # @private
      def match_labeled! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:lower:]])(?>(?>[[:alnum:]_])*))/) &&
              @scanner[1]
            end) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>:)/) &&
            (r0_1 = match(:labelable)) &&
            Label.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :labeled }
      end
      
      # @private
      def match_labelable #:nodoc:
        apply :match_labelable!
      end
      
      # @private
      def match_labelable! #:nodoc:
        match(:semantic_term) ||
        match(:list) ||
        match(:list_term) ||
        fail! { :labelable }
      end
      
      # @private
      def match_semantic_term #:nodoc:
        apply :match_semantic_term!
      end
      
      # @private
      def match_semantic_term! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\^)/) &&
            match(:semantic_action)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>&)/) &&
            (r0_0 = match(:semantic_action)) &&
            (Assert[r0_0])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>!)/) &&
            (r0_0 = match(:semantic_action)) &&
            (Disallow[r0_0])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>~)/) &&
            (r0_0 = match(:semantic_action)) &&
            (Skip[r0_0])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :semantic_term }
      end
      
      # @private
      def match_list #:nodoc:
        apply :match_list!
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
            (r0_1 = match(:repeat_count)) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,)/) &&
            (r0_2 = match(:list_term)) &&
            ListParser.parsed(select_captures([r0_0, r0_1, r0_2]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :list }
      end
      
      # @private
      def match_list_term #:nodoc:
        apply :match_list_term!
      end
      
      # @private
      def match_list_term! #:nodoc:
        match(:prefixed) ||
        match(:prefixable) ||
        (fail! { "term expected" })
      end
      
      # @private
      def match_prefixed #:nodoc:
        apply :match_prefixed!
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
        end ||
        fail { :prefixed }
      end
      
      # @private
      def match_prefixable #:nodoc:
        apply :match_prefixable!
      end
      
      # @private
      def match_prefixable! #:nodoc:
        match(:suffixed) ||
        match(:primary) ||
        (fail! { "primary expected" })
      end
      
      # @private
      def match_suffixed #:nodoc:
        apply :match_suffixed!
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
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\*)/) &&
            @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,))/) &&
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
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\+)/) &&
            @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,))/) &&
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
            (r0_1 = match(:repeat_count)) &&
            @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>,))/) &&
            Repeat.parsed(select_captures([r0_0, r0_1]))
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :suffixed }
      end
      
      # @private
      def match_repeat_count #:nodoc:
        apply :match_repeat_count!
      end
      
      # @private
      def match_repeat_count! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+)/) &&
              @scanner[1]
            end) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.\.)/) &&
            (r0_1 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+)/) &&
              @scanner[1]
            end) &&
            ([r0_0, r0_1].map {|s| s.to_i })
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+)/) &&
              @scanner[1]
            end) &&
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.\.)/) &&
            ([r0_0.to_i, nil])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:digit:]])+)/) &&
              @scanner[1]
            end) &&
            ([r0_0.to_i] * 2)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :repeat_count }
      end
      
      # @private
      def match_primary #:nodoc:
        apply :match_primary!
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
        match(:atom) ||
        fail! { :primary }
      end
      
      # @private
      def match_atom #:nodoc:
        apply :match_atom!
      end
      
      # @private
      def match_atom! #:nodoc:
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>EOF)(?![[:alnum:]_]))/) &&
            Eof.parsed([])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>E)(?![[:alnum:]_]))/) &&
            ESymbol.parsed([])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>super)(?![[:alnum:]_]))/) &&
            (Super[:pending])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
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
              end
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
            (r0_0 = begin
              p1 = @scanner.pos
              begin
                @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>(?>EOF)(?![[:alnum:]_])))/) &&
                begin
                  @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>[[:alpha:]])(?>(?>[[:alnum:]_])*))/) &&
                  @scanner[1]
                end
              end || begin
                @scanner.pos = p1
                false
              end
            end) &&
            @scanner.skip(/(?!(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?><\-))/) &&
            Apply.parsed([r0_0])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
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
            (literal r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>`)(?>(?>(?>\\)(?>.)|[^`])*)(?>`))/) &&
              @scanner[1]
            end) &&
            (word_literal r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>\[)(?>(?>(?!\])(?>(?>\[:)(?>(?>alnum)(?![[:alnum:]_])|(?>alpha)(?![[:alnum:]_])|(?>ascii)(?![[:alnum:]_])|(?>blank)(?![[:alnum:]_])|(?>cntrl)(?![[:alnum:]_])|(?>digit)(?![[:alnum:]_])|(?>graph)(?![[:alnum:]_])|(?>lower)(?![[:alnum:]_])|(?>print)(?![[:alnum:]_])|(?>punct)(?![[:alnum:]_])|(?>space)(?![[:alnum:]_])|(?>upper)(?![[:alnum:]_])|(?>xdigit)(?![[:alnum:]_]))(?>:\])|(?>(?>\\)(?>[0-3])(?>[0-7])(?>[0-7])|(?>\\x)(?>[[:xdigit:]])(?>[[:xdigit:]])|(?>\\)(?>.)|[^\\\]])(?>(?>(?>\-)(?>(?>\\)(?>[0-3])(?>[0-7])(?>[0-7])|(?>\\x)(?>[[:xdigit:]])(?>[[:xdigit:]])|(?>\\)(?>.)|[^\\\]]))?)))+)(?>\]))/) &&
              @scanner[1]
            end) &&
            (char_class r0_0)
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            (r0_0 = begin
              @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)((?>\$)(?>[[:lower:]])(?>(?>[[:alnum:]_])*))/) &&
              @scanner[1]
            end) &&
            BackReference.parsed([r0_0])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        begin
          p0 = @scanner.pos
          begin
            @scanner.skip(/(?>(?>(?>[[:space:]])+|(?>\#)(?>(?>[^\n])*))*)(?>\.)/) &&
            (Match[/./])
          end || begin
            @scanner.pos = p0
            false
          end
        end ||
        fail { :atom }
      end
      
    end
  end
end

if __FILE__ == $0
  require 'rubygems'
  require 'rattler'
  Rattler::Util::GrammarCLI.run(Rattler::Grammar::Metagrammar)
end
