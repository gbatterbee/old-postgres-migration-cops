# frozen_string_literal: true

module RuboCop
  module Cop
    module Trail
      # Check that indexes are added concurrently
      # @example
      #  # bad
      #    add_index :table, :column, unique: true
      #
      #  # good
      #     add_index :table, :column, unique: true, algorithm: :concurrently
      class AddIndexesConcurrently < Cop
        MSG = 'Consider adding indexes concurrently "algorithm: ' \
              ':concurrently" and "disable_ddl_transaction!" at the ' \
              'top of the class'

        def on_send(send_node)
          return unless send_node.method?(:add_index)
          return if send_node.arguments.any? { |a| concurrent?(a) }

          add_offense(send_node, location: :selector)
        end

        def on_class(class_node)
          puts 'on_class-------------------'
          puts concurrent? class_node
          add_offense(class_node)
        end

        def on_block(_class_node)
          puts 'on_block-------------------'
        end

        def_node_matcher :concurrent?, <<-PATTERN
        (hash
          ...
          (pair
            (sym :algorithm)
            (sym :concurrently)))
        PATTERN

        def autocorrect(node)
          lambda do |corrector|
            corrector.insert_after(node.loc.expression,
                                   ', algorithm: :concurrently')
          end
        end
      end
    end
  end
end
