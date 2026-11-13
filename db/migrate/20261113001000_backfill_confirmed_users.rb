class BackfillConfirmedUsers < ActiveRecord::Migration[8.1]
  def up
    confirmed_time = Time.current

    User.find_each do |user|
      user.update!(confirmed_at: confirmed_time)
    end
  end

  def down
    User.find_each do |user|
      user.update!(confirmed_at: nil)
    end
  end
end
