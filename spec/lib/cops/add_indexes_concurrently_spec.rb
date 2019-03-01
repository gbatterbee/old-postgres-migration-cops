# require './lib/cops/add_indexes_concurrently'
# # frozen_string_literal: true

# RSpec.describe RuboCop::Cop::Trail::AddIndexesConcurrently do
#   subject(:cop) { described_class.new }

#   it 'does not register an offense when index added concurrently' do
#     expect_no_offenses(<<-RUBY)
#       add_index :table, :other_column, algorithm: :concurrently
#     RUBY
#   end

#   it 'registers an offense when index not added concurrently' do
#     expect_offense(<<-RUBY)
#         add_index :table, :other_column
#         ^^^^^^^^^ Consider adding indexes concurrently "algorithm: :concurrently" and "disable_ddl_transaction!" at the top of the class
#     RUBY
#   end

#   it 'autocorrects by adding `algorithm: :concurrently`' do
#     corrected_source = autocorrect_source('add_index :table, :other_column')

#     expected = 'add_index :table, :other_column, algorithm: :concurrently'
#     expect(corrected_source).to eq(expected)
#   end
# end
