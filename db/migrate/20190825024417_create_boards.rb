class CreateBoards < ActiveRecord::Migration[5.2]
  def change
    create_table :boards do |t|
      t.string :name
      t.references :user, foreign_key: true
      t.timestamps
    end
    add_reference :pinnings, :board, index: true

    User.all.each do |user|
      board = user.boards.create(name: "My Pins!")
      user.pinnings.each do |pinning|
        board.pinnings << pinning
      end
    end
  end
end
