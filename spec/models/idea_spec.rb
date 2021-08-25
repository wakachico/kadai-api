require 'rails_helper'

RSpec.describe Idea, type: :model do
  before do
    @idea = FactoryBot.create(:idea)
  end

  describe 'アイデア情報の保存' do
    context 'アイデア情報が保存できる場合' do
      it 'body,category_idカラムが存在すればカテゴリー情報を保存できる' do
        expect(@idea).to be_valid
      end
    end
    context 'アイデア情報が保存できない場合' do
      it 'bodyカラムが空ではカテゴリー情報を保存できない' do
        @idea.body = ""
        @idea.valid?
        expect(@idea.errors.full_messages).to include("Body can't be blank")
      end
      it 'category_idカラムが空ではカテゴリー情報を保存できない' do
        @idea.category_id = ""
        @idea.valid?
        expect(@idea.errors.full_messages).to include("Category can't be blank")
      end
      it 'categoryが紐付いていなければ投稿できない' do
        @idea.category = nil
        @idea.valid?
        expect(@idea.errors.full_messages).to include("Category must exist")
      end
    end
  end
end
