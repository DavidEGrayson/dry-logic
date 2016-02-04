require 'dry/logic/rule'

module Dry
  module Logic
    class RuleCompiler
      attr_reader :predicates

      def initialize(predicates)
        @predicates = predicates
      end

      def call(ast)
        ast.to_ary.map { |node| visit(node) }
      end

      def visit(node)
        name, nodes = node
        send(:"visit_#{name}", nodes)
      end

      def visit_check(node)
        name, predicate, keys = node
        Rule::Check.new(name, visit(predicate), keys || [name])
      end

      def visit_not(node)
        visit(node).negation
      end

      def visit_key(node)
        name, predicate = node
        Rule::Key.new(name, visit(predicate))
      end

      def visit_attr(node)
        name, predicate = node
        Rule::Attr.new(name, visit(predicate))
      end

      def visit_val(node)
        name, predicate = node
        Rule::Value.new(name, visit(predicate))
      end

      def visit_set(node)
        name, rules = node
        Rule::Set.new(name, call(rules))
      end

      def visit_each(node)
        name, rule = node
        Rule::Each.new(name, visit(rule))
      end

      def visit_predicate(node)
        name, args = node
        predicates[name].curry(*args)
      end

      def visit_and(node)
        left, right = node
        visit(left) & visit(right)
      end

      def visit_or(node)
        left, right = node
        visit(left) | visit(right)
      end

      def visit_xor(node)
        left, right = node
        visit(left) ^ visit(right)
      end

      def visit_implication(node)
        left, right = node
        visit(left) > visit(right)
      end
    end
  end
end
