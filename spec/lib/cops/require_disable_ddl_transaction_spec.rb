require './lib/cops/require_disable_ddl_transaction'

# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Trail::RequireDisableDdlTransaction do
  subject(:cop) { described_class.new }

  subject(:cop) { described_class.new }

  context 'when disable_ddl_transaction! is not declared' do
    context 'and it is not a migration' do
      it 'does not register an ignore ddl offence' do
        expect_no_offenses(<<-RUBY)
        class AddLockableToDevise
            def change
              add_column :users, :failed_attempts, :integer, default: 0, null: false
              add_column :users, :unlock_token, :string
              add_column :users, :locked_at, :datetime
              add_index  :users,
                         :unlock_token,
                         unique: true,
                         algorithm: :concurrently
            end
          end
        RUBY
      end
    end

    context 'and an index is not created concurrently' do
      it 'registers an concurrent index offence' do
        expect_offense(<<-RUBY)
        class AddLockableToDevise < ActiveRecord::Migration
            def change
              add_column :users, :failed_attempts, :integer, default: 0, null: false
              add_column :users, :unlock_token, :string
              add_column :users, :locked_at, :datetime
              add_index  :users,
              ^^^^^^^^^^^^^^^^^^ Indexes should be added with 'algorithm: :concurrently'
                         :unlock_token,
                         unique: true
            end
          end
        RUBY
      end
    end

    context 'and an index is created concurrently' do
      it 'registers an ignore ddl offence' do
        expect_offense(<<-RUBY)
        class AddLockableToDevise < ActiveRecord::Migration
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Concurrent indexes require "disable_ddl_transaction!"
            def change
              add_column :users, :failed_attempts, :integer, default: 0, null: false
              add_column :users, :unlock_token, :string
              add_column :users, :locked_at, :datetime
              add_index  :users,
                         :unlock_token,
                         unique: true,
                         algorithm: :concurrently
            end
          end
        RUBY
      end
    end
  end

  context 'when disable_ddl_transaction! is declared' do
    context 'when not a migration' do
      it 'does not register an offense ' do
        expect_no_offenses(<<-RUBY)
          class AddLockableToDevise
            disable_ddl_transaction!
            def change
              add_column :users, :locked_at, :datetime, :index
              add_index  :users,
                         :unlock_token,
                         unique: true,
                         algorithm: :concurrently
            end
          end
        RUBY
      end
    end

    context 'and an index is registered concurrently' do
      it 'does not register an offense' do
        expect_no_offenses(<<-RUBY)
          class AddLockableToDevise < ActiveRecord::Migration
            disable_ddl_transaction!
            def change
              add_column :users, :locked_at, :datetime
              add_index  :users,
                         :unlock_token,
                         unique: true,
                         algorithm: :concurrently
            end
          end
        RUBY
      end
    end

    context 'and an index is not registered concurrently' do
      it 'registers an concurrency offense' do
        expect_offense(<<-RUBY)
          class AddLockableToDevise < ActiveRecord::Migration
            disable_ddl_transaction!
            def change
              add_column :users, :locked_at, :datetime, :index
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Indexes should be added with 'algorithm: :concurrently'
              add_index  :users,
              ^^^^^^^^^^^^^^^^^^ Indexes should be added with 'algorithm: :concurrently'
                         :unlock_token,
                         unique: true
            end
          end
        RUBY
      end
    end
  end
end

# code = '!something.empty?'
# source = RuboCop::ProcessedSource.new(code, RUBY_VERSION.to_f)
# node = source.ast
# # => s(:send, s(:send, s(:send, nil, :something), :empty?), :!)
# The node has a few attributes that can be useful in the journey:

# node.type # => :send
# node.children # => [s(:send, s(:send, nil, :something), :empty?), :!]
# node.source # => "!something.empty?"

# xit 'registers an offense when index is added concurrently' do
#   expect_offense(<<-RUBY)
#   class AddLockableToDevise < ActiveRecord::Migration
#   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Concurrent indexes require "disable_ddl_transaction!" at the top of the class
#     disable_ddl_transaction!
#     def change
#       add_column :users, :failed_attempts, :integer, default: 0, null: false
#       add_column :users, :unlock_token, :string
#       add_column :users, :locked_at, :datetime
#       add_index  :users,
#                 :unlock_token,
#                 unique: true,
#                 algorithm: :concurrently
#     end
#   end
#   RUBY
# # end

# xit 'xxxregisters an offense when index not added concurrently' do
#   expect_offense(<<-RUBY)
#   class AddLockableToDevise < ActiveRecord::Migration
#     disable_ddl_transaction!
#     ^^^^^^^^^^^^^^^^^^^^^^^^ Concurrent indexes require "disable_ddl_transaction!" at the top of the class

#     def change
#       add_column :users, :failed_attempts, :integer, default: 0, null: false
#       add_column :users, :unlock_token, :string
#       add_column :users, :locked_at, :datetime
#       add_index  :users,
#                 :unlock_token,
#                 unique: true,
#                 algorithm: :concurrently
#     end
#   end
#   RUBY
# end
# xit 'does not register an offense when index not added concurrently' do
#   expect_no_offenses(<<-RUBY)
#   class AddLockableToDevise < ActiveRecord::Migration
#       disable_ddl_transaction!
#       def change
#         add_column :users, :failed_attempts, :integer, default: 0, null: false
#         add_column :users, :unlock_token, :string
#         add_column :users, :locked_at, :datetime
#         add_index  :users,
#                   :unlock_token,
#                   unique: true
#       end
#     end
#   RUBY
# end

# xit 'does not register an offense when index not a migration' do
#   expect_no_offenses(<<-RUBY)
#   class AddLockableToDevise < ActiveRecord::Migration
#       disable_ddl_transaction!
#       def change
#         add_column :users, :failed_attempts, :integer, default: 0, null: false
#         add_column :users, :unlock_token, :string
#         add_column :users, :locked_at, :datetime
#         add_index  :users,
#                   :unlock_token,
#                   unique: true
#       end
#     end
#   RUBY
# end

# xit 'does not register an offense when not a migration' do
#   expect_no_offenses(<<-RUBY)
#   class AddLockableToDevise
#       def change
#         add_column :users, :locked_at, :datetime, :index
#         add_index  :users,
#                   :unlock_token,
#                   unique: true
#       end
#     end
#   RUBY
# end
# end
