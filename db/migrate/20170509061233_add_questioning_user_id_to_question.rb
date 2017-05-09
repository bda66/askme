class AddQuestioningUserIdToQuestion < ActiveRecord::Migration[5.0]
  def change
    add_column :questions, :questioning_user_id, :integer
  end
end
