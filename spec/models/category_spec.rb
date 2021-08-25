require 'rails_helper'

RSpec.describe Category, type: :model do
  before do
    @category = FactoryBot.build(:category)
  end

  describe 'カテゴリー情報の保存' do
    context 'カテゴリー情報が保存できる場合' do
      it 'nameカラムが存在すればカテゴリー情報を保存できる' do
        expect(@category).to be_valid
      end
    end
    context 'カテゴリー情報が保存できない場合' do
      it 'nameカラムが空ではカテゴリー情報を保存できない' do
        @category.name = ''
        @category.valid?
        expect(@category.errors.full_messages).to include("Name can't be blank")
      end
      it '重複したnameカラムが存在する場合登録できない' do
        @category.save
        another_category = FactoryBot.build(:category)
        another_category.name = @category.name
        another_category.valid?
        expect(another_category.errors.full_messages).to include("Name has already been taken")
      end
    end
  end
end
