module HexpUI
  class Handlebars
    class Value
      def initialize(name)
        @name = name
      end

      def to_hexp
        Hexp::TextNode.new(to_s)
      end

      def to_s
        "{{#{@name}}}"
      end

      def map(&blk)
        collector = Collector.new(&blk)
        Hexp::List[
          "{{#each #{@name}}}",
          collector.call(collector),
          "{{/each}}"
        ]
      end
      alias each map
    end

    class Collector < BasicObject
      def initialize(&blk)
        @blk = blk
      end

      def method_missing(name)
        Value.new(name)
      end

      def call(*args)
        instance_exec(*args, &@blk)
      end
    end
  end
end
