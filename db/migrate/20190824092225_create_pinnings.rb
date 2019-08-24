class CreatePinnings < ActiveRecord::Migration[5.2]
  def change
    create_table :pinnings do |t|
      t.references :user, foreign_key: true
      t.references :pin, foreign_key: true
      t.timestamps
    end
    Pin.where("user_id IS NOT NULL").each do |pin|
      puts "got pin #{pin.id}"
      user = User.find(pin.user_id)
      if user.present?
        puts "user present: #{user.id}"
        pin.pinnings.create(user: user)
      end
    end    
  end
end
