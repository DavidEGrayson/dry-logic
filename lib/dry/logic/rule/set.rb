module Dry
  module Logic
    class Rule::Set < Rule::Value
      alias_method :rules, :predicate

      def type
        :set
      end

      def apply(input)
        rules.map { |rule| rule.(input) }
      end

      def at(*args)
        new(rules.values_at(*args))
      end

      def to_ary
        [type, rules.map { |rule| rule.to_ary }]
      end
    end
  end
end
