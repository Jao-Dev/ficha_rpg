require 'rails_helper'

describe Character do
  describe 'Validacoes' do
      it { is_expected.not_to have_valid(:name).when(nil, '') }
      it { is_expected.not_to have_valid(:race).when(nil, '') }
  end

  describe 'extras' do
    it 'aceita mochila, armas e efeitos válidos' do
      character = build(:character, extras: {
        "mochila" => [ { "nome" => "Poção", "quantidade" => 2 } ],
        "armas" => [ { "nome" => "Machado", "dano" => "2d6 de dano" } ],
        "efeitos" => [ "+4d8 de armadura por 2 rodadas" ]
      })

      expect(character).to be_valid
    end

    it 'aceita quantidade zero na mochila' do
      character = build(:character, extras: { "mochila" => [ { "nome" => "Flecha", "quantidade" => 0 } ] })

      expect(character).to be_valid
    end

    it { is_expected.not_to have_valid(:extras).when({ "mochila" => [ { "nome" => "", "quantidade" => 1 } ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "mochila" => [ { "nome" => "Poção", "quantidade" => -1 } ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "mochila" => [ { "nome" => "Poção", "quantidade" => "2" } ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "mochila" => [ "Poção" ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "armas" => [ { "nome" => "", "dano" => "2d6" } ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "armas" => [ { "nome" => "Machado", "dano" => "" } ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "armas" => [ "Machado" ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "efeitos" => [ "" ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "efeitos" => [ 4 ] }) }
    it { is_expected.not_to have_valid(:extras).when({ "outro" => 1 }) }
    it { is_expected.not_to have_valid(:extras).when("texto") }
    it { is_expected.not_to have_valid(:extras).when({ "mochila" => "lista" }) }
    it { is_expected.not_to have_valid(:extras).when({ "armas" => 5 }) }
    it { is_expected.not_to have_valid(:extras).when({ "efeitos" => "texto" }) }
  end

  describe 'validar o avatar no banco' do
    it 'sendo imagem PNG' do
      character = build(:character)
      character.avatar.attach(
        io: Rails.root.join('spec/resources/dummies/dummy.png').open,
        filename: 'dummy.png'
      )
      expect(character).to be_valid
      expect(character.avatar).not_to be_nil
    end
  end

  describe 'validar imagem do avatar' do
    it 'sendo imagem HEIC' do
      character = build(:character)
      character.avatar.attach(
        io: Rails.root.join('spec/resources/dummies/dummy.heic').open,
        filename: 'dummy.png'
      )
      expect(character).not_to be_valid
    end

    it 'arquivo inválido sem extensão' do
      character = build(:character)
      character.avatar.attach(
        io: Rails.root.join('spec/resources/pdf-sem-extensao').open,
        filename: 'pdf-sem-extensao'
      )
      expect(character).not_to be_valid
    end
  end
end
