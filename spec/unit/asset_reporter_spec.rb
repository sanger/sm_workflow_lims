# require 'spec_helper'
# require './app/models/asset'

# describe Asset::Reporter do

#   context "with an array of reportable assets" do

#     let(:time)   { DateTime.parse('01-02-2012 13:15') }
#     let(:assets) { [asset1,asset2]}
#     let(:workflow) { double(:workflow,name:'test workflow')}
#     let(:asset1) { double(:asset1,identifier:'a',reportable?:true,completed?:true,workflow:workflow) }
#     let(:asset2) { double(:asset2,identifier:'b',reportable?:true,completed?:true,workflow:workflow) }
#     let(:message) {"a and b were marked as reported."}

#     it "should flag the assets as reported" do
#       asset1.should_receive(:update_attributes!).with(reported_at:time)
#       asset2.should_receive(:update_attributes!).with(reported_at:time)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time)
#     end

#     it "should have a success state if successful" do
#       asset1.should_receive(:update_attributes!).with(reported_at:time)
#       asset2.should_receive(:update_attributes!).with(reported_at:time)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time).state.should eq('success')
#     end

#     it "should summarise updated assets" do
#       asset1.should_receive(:update_attributes!).with(reported_at:time)
#       asset2.should_receive(:update_attributes!).with(reported_at:time)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time).message.should eq(message)
#     end

#   end

#   context "with an array of unreportable assets" do

#     let(:time)   { DateTime.parse('01-02-2012 13:15') }
#     let(:assets) { [asset1,asset2]}
#     let(:workflow) { double(:workflow,name:'test workflow')}
#     let(:asset1) { double(:asset1,identifier:'a',reportable?:false,completed?:true,workflow:workflow) }
#     let(:asset2) { double(:asset2,identifier:'b',reportable?:false,completed?:true,workflow:workflow) }
#     let(:message) {"a is in test workflow, which does not need a report.\nb is in test workflow, which does not need a report."}

#     it "should not flag the assets as reported" do
#       asset1.should_not_receive(:update_attributes!)
#       asset2.should_not_receive(:update_attributes!)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time)
#     end

#     it "should have a danger state" do
#       asset1.should_not_receive(:update_attributes!)
#       asset2.should_not_receive(:update_attributes!)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time).state.should eq('danger')
#     end

#     it "should summarise updated assets" do
#       asset1.should_not_receive(:update_attributes!)
#       asset2.should_not_receive(:update_attributes!)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time).message.should eq(message)
#     end

#   end

#   context "with an array of uncompletes assets" do

#     let(:time)   { DateTime.parse('01-02-2012 13:15') }
#     let(:assets) { [asset1,asset2]}
#     let(:workflow) { double(:workflow,name:'test workflow')}
#     let(:asset1) { double(:asset1,identifier:'a',reportable?:true,completed?:false,workflow:workflow) }
#     let(:asset2) { double(:asset2,identifier:'b',reportable?:true,completed?:false,workflow:workflow) }
#     let(:message) {"a can not be reported on before it is completed.\nb can not be reported on before it is completed."}

#     it "should not flag the assets as reported" do
#       asset1.should_not_receive(:update_attributes!)
#       asset2.should_not_receive(:update_attributes!)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time)
#     end

#     it "should have a danger state" do
#       asset1.should_not_receive(:update_attributes!)
#       asset2.should_not_receive(:update_attributes!)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time).state.should eq('danger')
#     end

#     it "should summarise updated assets" do
#       asset1.should_not_receive(:update_attributes!)
#       asset2.should_not_receive(:update_attributes!)
#       Asset::Reporter.create!(assets:[asset1,asset2],time:time).message.should eq(message)
#     end

#   end

# end
