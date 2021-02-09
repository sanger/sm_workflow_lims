require 'rails_helper'

describe Presenter::AssetTypePresenter::AssetType do
  describe '#validates_with' do
    let(:asset_type) { create :asset_type, identifier_data_type: identifier_data_type }
    let(:presenter) { Presenter::AssetTypePresenter::AssetType.new(asset_type) }

    context 'when identifier_data_type is alphanumeric' do
      let(:identifier_data_type) { 'alphanumeric' }

      it 'returns the correct validation for the identifier data type' do
        expect(presenter.validates_with).to eq Presenter::AssetTypePresenter::AssetType::ALPHANUMERIC_REGEX
      end
    end

    context 'when identifier_data_type is numeric' do
      let(:identifier_data_type) { 'numeric' }

      it 'returns the correct validation for the identifier data type' do
        expect(presenter.validates_with).to eq Presenter::AssetTypePresenter::AssetType::NUMERIC_REGEX
      end
    end
  end
end
