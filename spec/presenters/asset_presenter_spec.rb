require 'rails_helper'
require './app/presenters/asset/asset'
require 'timecop'

describe 'Presenter::AssetPresenter::Asset' do
  shared_examples 'shared behaviour' do
    let(:mock_type) do
      double('mock_type',
             name: 'Type',
             identifier_type: 'id',
             variable_samples: true)
    end
    let(:mock_workflow) { double('mock_wf', name: 'Work', has_comment: true, turn_around_days: 2) }
    let(:date) { DateTime.parse('01-02-2012 13:15') }
    let(:comment) { double('comment', comment: 'A comment') }

    let(:presenter) { Presenter::AssetPresenter::Asset.new(asset) }

    it 'returns the identifier type for identifier_type' do
      expect(presenter.identifier_type).to eq('id')
    end

    it 'returns the identifier for identifier' do
      expect(presenter.identifier).to eq('asset_1')
    end

    it 'returns the sample count for sample_count' do
      expect(presenter.sample_count).to eq(2)
    end

    it 'returns the study_name for study' do
      expect(presenter.study).to eq('study')
    end

    it 'returns the workflow for workflow' do
      expect(presenter.workflow).to eq('Work')
    end

    it 'returns the created at time as a formatted string for created_at' do
      expect(presenter.created_at).to eq('01/02/2012')
    end
  end

  context 'with an asset with comments' do
    let(:asset) do
      double('asset',
             identifier: 'asset_1',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study',
             sample_count: 2,
             begun_at: date,
             comment:)
    end

    include_examples 'shared behaviour'

    it 'returns the comment for comments' do
      expect(presenter.comments).to eq('A comment')
    end
  end

  context 'with an asset without comments' do
    let(:asset) do
      double('asset',
             identifier: 'asset_1',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study',
             sample_count: 2,
             begun_at: date,
             comment: nil)
    end

    include_examples 'shared behaviour'

    it 'returns an empty string for comments' do
      expect(presenter.comments).to eq('')
    end
  end

  context 'an unfinished asset' do
    let(:age) { date - DateTime.parse('01-02-2012 15:15') }
    let(:asset) do
      double('asset',
             identifier: 'asset_1',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study',
             sample_count: 2,
             begun_at: date,
             completed_at: nil,
             age:,
             time_without_completion: 0)
    end

    include_examples 'shared behaviour'

    context 'when no turn_around_days specified' do
      let(:mock_workflow) { double('mock_wf', name: 'Work', has_comment: true, turn_around_days: nil) }

      it "returns 'in progress' for completed_at" do
        expect(presenter.completed_at).to eq('In progress')
      end

      it 'has no styling' do
        expect(presenter.status_code).to eq('default')
      end
    end

    context 'when not due for a while' do
      # DateTime returns differences in rationals. However, to avoid making
      # assumptions about the performance of the standard library, we just use
      # it. That way, if its behaviour changes, out tests will fail.
      let(:age) { (DateTime.parse('01-02-2012 15:15') - date).to_i }

      it "returns 'in progress' for completed_at" do
        expect(presenter.completed_at).to eq('In progress (2 days left)')
      end

      it "has 'success' styling" do
        expect(presenter.status_code).to eq('success')
      end
    end

    context 'when due today' do
      let(:today) { DateTime.parse('03-02-2012 15:15') }
      let(:age) { today - date }
      let(:asset) do
        double('asset',
               identifier: 'asset_1',
               asset_type: mock_type,
               workflow: mock_workflow,
               study: 'study',
               sample_count: 2,
               begun_at: date,
               completed_at: nil,
               age:,
               time_without_completion: age)
      end

      it "returns 'Due today' for completed_at" do
        expect(presenter.completed_at).to eq('Due today')
      end

      it 'is warning' do
        expect(presenter.status_code).to eq('warning')
      end
    end

    context 'when overdue' do
      let(:today) { DateTime.parse('04-02-2012 15:15') }
      let(:asset) do
        double('asset',
               identifier: 'asset_1',
               asset_type: mock_type,
               workflow: mock_workflow,
               study: 'study',
               sample_count: 2,
               begun_at: date,
               completed_at: nil,
               age:,
               time_without_completion: age)
      end
      let(:age) { today - date }

      it "returns 'Overdue (1 day)' for completed_at" do
        expect(presenter.completed_at).to eq('Overdue (1 day)')
      end

      it 'is danger' do
        expect(presenter.status_code).to eq('danger')
      end
    end
  end

  context 'an completed asset' do
    let(:asset) do
      double('asset',
             identifier: 'asset_1',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study',
             sample_count: 2,
             begun_at: date,
             completed_at: date,
             time_without_completion: 0,
             age: 0)
    end

    include_examples 'shared behaviour'

    it 'returns its completed date for completed_at' do
      expect(presenter.completed_at).to eq('01/02/2012 (Early 2 days)')
    end
  end
end
