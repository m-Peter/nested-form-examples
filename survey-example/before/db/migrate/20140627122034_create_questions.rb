class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :content
      t.references :survey, index: true

      t.timestamps
    end
  end
end
