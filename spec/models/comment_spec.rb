require 'rails_helper'

describe Comment do

  context 'with valid parameters' do

    let(:comment_text) { 'This is a comment.' }

    it 'has many assets' do
      comment = Comment.new
      comment.assets.new(:identifier=>'test')
      expect(comment.assets.size).to eq(1)
      expect(comment.assets.first.identifier).to eq('test')
    end

    it 'can have text' do
      com = Comment.new(:comment=>comment_text)
      expect(com.comment).to eq(comment_text)
    end

  end


end
