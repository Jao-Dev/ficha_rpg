class ConvertCampaignMasterToUser < ActiveRecord::Migration[8.1]
  def up
    safety_assured do
      add_reference :campaigns, :master, foreign_key: { to_table: :users }
    end

    Campaign.find_each do |campaign|
      master = User.create!(
        name: campaign[:master],
        email: "mestre-#{campaign.id}@ficha_rpg.com",
        role: :mestre
      )
      campaign.update!(master_id: master.id)
    end

    safety_assured do
      remove_column :campaigns, :master
      change_column_null :campaigns, :master_id, false
    end
  end

  def down
    safety_assured do
      add_column :campaigns, :master, :string, null: false, default: 'Mestre'
      remove_reference :campaigns, :master
    end
  end
end
