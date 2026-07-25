require 'rails_helper'

describe Character do
  describe 'Validacoes' do
      it { is_expected.not_to have_valid(:name).when(nil, '')}
      it { is_expected.not_to have_valid(:race).when(nil, '')}
      it { is_expected.not_to have_valid(:ativo).when(nil, '')}
  end
end

