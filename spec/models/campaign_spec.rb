require 'rails_helper'

describe Campaign do
  describe 'Validacoes' do
      it { is_expected.not_to have_valid(:master).when(nil, '') }
      it { is_expected.not_to have_valid(:ativo).when(nil, '') }
  end
end
