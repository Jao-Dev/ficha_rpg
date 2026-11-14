class TrocaVinculosDePersonagens < ActiveRecord::Migration[8.1]
  def up
    create_table :campaign_characters do |t|
      t.bigint :campaign_id, null: false
      t.bigint :character_id, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :campaign_characters, [ :campaign_id, :character_id ], unique: true
    add_index :campaign_characters, :character_id

    safety_assured do
      remove_column :characters, :ativo
      drop_table :memberships
    end

    Character.where.not(campaign_id: nil).find_each do |character|
      CampaignCharacter.create!(campaign: character.campaign, character: character, status: :ativo)
    end
  end

  def down
    safety_assured do
      drop_table :campaign_characters
      add_column :characters, :ativo, :boolean, default: true, null: false
    end

    create_table :memberships do |t|
      t.bigint :campaign_id, null: false
      t.bigint :user_id, null: false
      t.integer :status, default: 0, null: false

      t.timestamps
    end

    add_index :memberships, [ :campaign_id, :user_id ], unique: true
    add_index :memberships, :user_id
  end
end
