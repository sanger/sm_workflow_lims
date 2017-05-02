require 'rails_helper'

describe Comment do

  context 'with valid parameters' do

    let(:comment_text) { 'This is a comment.' }

    it 'has many assets' do
      comment = Comment.new
      comment.assets.new(:identifier=>'test')
      comment.assets.size.should eq(1)
      comment.assets.first.identifier.should eq('test')
    end

    it 'can have text' do
      com = Comment.new(:comment=>comment_text)
      com.comment.should eq(comment_text)
    end

  end


end
