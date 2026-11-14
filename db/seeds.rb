# Seeds do ambiente de desenvolvimento: bin/rails db:seed
# Quantidade de usuários Faker configurável: QUANTIDADE_USUARIOS=10 bin/rails db:seed
# O usuário desenv é fixo; os demais são gerados com Faker a cada execução.
# Bloqueado fora de desenvolvimento: em produção o seed não deve criar dados.

unless Rails.env.development?
  puts "Seed disponível apenas em desenvolvimento."
  return
end

senha = "password"
agora = Time.current
racas = [ "Anão", "Elfo", "Humano", "Halfling", "Orc", "Draconato" ].freeze

desenv = User.find_or_create_by!(email: "desenv@ficha.com") do |user|
  user.name = "desenv"
  user.password = senha
  user.confirmed_at = agora
end
desenv.update!(name: "desenv") if desenv.name != "desenv"

quantidade = ENV.fetch("QUANTIDADE_USUARIOS", "5").to_i
roles = Array.new(quantidade) { |i| [ :mestre, :mestre, :admin, :jogador ][i] || :jogador }

users = roles.map do |role|
  User.create!(name: Faker::Name.name, email: Faker::Internet.unique.email,
    password: senha, role: role, confirmed_at: agora)
end

mestre = users.find(&:mestre?)
jogadores = users.select(&:jogador?)

if mestre
  campanha = Campaign.create!(master: mestre)
  users.select(&:mestre?).drop(1).each { |outro_mestre| Campaign.create!(master: outro_mestre) }

  jogadores.each_with_index do |jogador, indice|
    2.times { Character.create!(user: jogador, name: Faker::Name.name, race: racas.sample) }
    personagens = jogador.characters.order(:id)

    if indice.zero?
      personagens.each { |personagem| personagem.update!(campaign: campanha) }
      primeiro = personagens.first
      Aviso.create!(user: jogador,
        content: "Seu personagem #{primeiro.name} foi inserido na campanha de #{mestre.name}.",
        read_at: agora)
      Aviso.create!(user: mestre,
        content: "#{jogador.name} confirmou o personagem #{primeiro.name} na sua campanha.")
    elsif indice == 1
      pendente = personagens.first
      CampaignCharacter.create!(campaign: campanha, character: pendente, status: :pendente)
      pendente.update!(campaign: campanha)
      Aviso.create!(user: jogador,
        content: "Seu personagem #{pendente.name} foi inserido na campanha de #{mestre.name}.")
    end
  end

  if jogadores.size > 2
    terceiro = jogadores[2].characters.first
    Aviso.create!(user: jogadores[2],
      content: "Seu personagem #{terceiro.name} foi removido da campanha de #{mestre.name}.")
  end
end

puts "#{User.count} usuários, #{Character.count} personagens, #{Campaign.count} campanhas, #{Aviso.count} avisos."
