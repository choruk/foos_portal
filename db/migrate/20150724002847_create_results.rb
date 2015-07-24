class CreateResults < ActiveRecord::Migration
  def up
    create_table :results do |t|
      t.integer :game_id, null: false
      t.integer :user_id, null: false
      t.boolean :win, null: false, default: false

      t.timestamps
    end

    add_foreign_key_constraint :results, :game_id, :games
    add_foreign_key_constraint :results, :user_id, :users
  end

  private

  def add_foreign_key_constraint(from_table, from_column, to_table, fk_constraint_name_override = nil)
    execute %{
          alter table #{from_table}
          add constraint #{fk_constraint_name(from_table, from_column, to_table, fk_constraint_name_override)}
          foreign key (#{from_column})
          references #{to_table}(id)
        }
  end

  def remove_foreign_key_constraint(from_table, from_column, to_table, fk_constraint_name_override = nil)
    execute %{
          alter table #{from_table}
          drop foreign key #{fk_constraint_name(from_table, from_column, to_table, fk_constraint_name_override)}
            }
  end

  def fk_constraint_name(from_table, from_column, to_table, fk_constraint_name_override)
    #Note: MySQL constraint names are length limited to 64 char.
    (fk_constraint_name_override || "fk_#{from_table}_#{from_column}_#{to_table}")[0,64]
  end
end
