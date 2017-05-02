class AddForeignKeyConstraints < ActiveRecord::Migration

  require './lib/foreign_key_constraint'
  include ForeignKeyConstraint

  def up
    add_constraint('assets','batches')
    add_constraint('assets','asset_types')
    add_constraint('assets','workflows')
    add_constraint('assets','comments')
  end

  def down
    drop_constraint('assets','batches')
    drop_constraint('assets','asset_types')
    drop_constraint('assets','workflows')
    drop_constraint('assets','comments')
  end
end
