require 'spec_helper'
require './app/presenters/asset/asset'
require 'timecop'

describe Presenter::AssetPresenter::Asset do

  shared_examples "shared behaviour" do
    let(:mock_type) { double('mock_type',name:'Type',identifier_type:'id',variable_samples:true)}
    let(:mock_workflow)  { double('mock_wf',  name:'Work',has_comment:true,turn_around_days:2)}
    let(:date) { DateTime.parse('01-02-2012 13:15') }
    let(:comment) { double('comment',:comment=>'A comment')}

    let(:presenter) { Presenter::AssetPresenter::Asset.new(asset)}


    it "should return the identifier type for identifier_type" do
      presenter.identifier_type.should eq('id')
    end

    it "should return the identifier for identifier" do
      presenter.identifier.should eq('asset_1')
    end

    it "should return the sample count for sample_count" do
      presenter.sample_count.should eq(2)
    end

    it "should return the study_name for study" do
      presenter.study.should eq('study')
    end

    it "should return the workflow for workflow" do
      presenter.workflow.should eq('Work')
    end

    it "should return the created at time as a formatted string for created_at" do
      presenter.created_at.should eq('01/02/2012')
    end
  end

  context "with an asset with comments" do
    let(:asset) { double('asset',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study',sample_count:2,begun_at:date,comment:comment) }

    include_examples "shared behaviour"

    it "should return the comment for comments" do
      presenter.comments.should eq('A comment')
    end
  end

  context "with an asset without comments" do
    let(:asset) { double('asset',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study',sample_count:2,begun_at:date,comment:nil) }

    include_examples "shared behaviour"

    it "should return an empty string for comments"do
      presenter.comments.should eq('')
    end
  end

  context "an unfinished asset" do

    let(:age) { date - DateTime.parse('01-02-2012 15:15') }
    let(:asset) { double('asset',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study',sample_count:2,begun_at:date,completed_at:nil,age:age, time_without_completion: 0) }

    include_examples "shared behaviour"

    context 'when no turn_around_days specified' do
      let(:mock_workflow)  { double('mock_wf',  name:'Work',has_comment:true,turn_around_days:nil)}

      it "should return 'in progress' for completed_at" do
        presenter.completed_at.should eq('In progress')
      end

      it "should have no styling" do
        expect(presenter.status_code).to eq('default')
      end
    end

    context 'when not due for a while' do
      # DateTime returns differences in rationals. However, to avoid making assumptions about the performance of the standard
      # library, we just use it. That way, if its behaviour changes, out tests will fail.
      let(:age) { (DateTime.parse('01-02-2012 15:15') - date).to_i }

      it "should return 'in progress' for completed_at" do
        presenter.completed_at.should eq('In progress (2 weekdays left)')
      end

      it "should have 'success' styling" do
        expect(presenter.status_code).to eq('success')
      end
    end

    context 'when due today' do
      let(:today) { DateTime.parse('03-02-2012 15:15') }
      let(:age) { today - date }
      let(:asset) { double('asset',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study',sample_count:2,begun_at:date,completed_at:nil,age:age, time_without_completion: age) }
      it "should return 'Due today' for completed_at" do
        presenter.completed_at.should eq('Due today')
      end
      it "should be warning" do
        expect(presenter.status_code).to eq('warning')
      end
    end

    context 'when overdue' do
      let(:today) { DateTime.parse('04-02-2012 15:15') }
      let(:asset) { double('asset',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study',sample_count:2,begun_at:date,completed_at:nil,age:age, time_without_completion: age) }
      let(:age) { today - date }
      it "should return 'Overdue (1 weekday)' for completed_at" do
        presenter.completed_at.should eq('Overdue (1 weekday)')
      end
      it "should be danger" do
        expect(presenter.status_code).to eq('danger')
      end
    end
  end

  context "an completed asset" do
    include_examples "shared behaviour"
    let(:asset) { double('asset',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study',sample_count:2,begun_at:date,completed_at:date, time_without_completion: 0, age: 0) }
    it "should return its completed date for completed_at" do
      presenter.completed_at.should eq('01/02/2012 (Early 2 weekdays)')
    end
  end

end
