require 'rails_helper'

describe TablerFormBuilder, type: :helper do
  it 'adiciona a classe padrão e mantém a classe extra' do
    builder = described_class.new(:character, build(:character), helper, {})

    expect(builder.text_field(:name, class: 'extra')).to include('form-control extra')
    expect(builder.text_field(:name)).to include('form-control')
    expect(builder.label(:name, class: 'extra')).to include('form-label extra')
    expect(builder.label(:name)).to include('form-label')
    expect(builder.submit('Salvar', class: 'extra')).to include('btn btn-primary extra')
    expect(builder.submit('Salvar')).to include('btn btn-primary')
    expect(builder.collection_select(:campaign_id, [], :id, :name, {}, class: 'extra')).to include('form-select extra')
  end
end
