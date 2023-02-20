class AddPointsToPollParticipants < ActiveRecord::Migration[7.0]
  def change
    add_column :poll_participants, :final_score, :integer
  end
end
