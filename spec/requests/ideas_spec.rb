require 'rails_helper'

RSpec.describe "Ideas", type: :request do
  before do
    @idea = FactoryBot.create(:idea)
    @another_idea = FactoryBot.create(:idea)
    @another_idea.update(category_id: @idea.category_id)
  end

  describe 'POST #create 1.アイデア登録API' do
    it 'リクエストのcategory_nameがcategoriesテーブルのnameに存在する場合、categoryのidをcategory_idとして、ideasテーブルに登録される' do 
      valid_params = { category_name: @idea.category.name , body: 'test'}
      # categorysテーブルにはデータが作成されない事を確認
      expect{ 
        post '/ideas', params: valid_params
      }.to change(Category, :count).by(0)
      # ideasテーブルにデータが作成されている事を確認
      expect{ 
        post '/ideas', params: valid_params
      }.to change(Idea, :count).by(+1)
      # HTTPステータスコード201が返却される
      expect(response.status).to eq 201
    end
    it 'リクエストのcategory_nameがcategoriesテーブルのnameに存在しない場合、新たなcategoryとしてcategoriesテーブルに登録し、ideasテーブルに登録される' do 
      valid_params = { category_name: 'ダミーカテゴリー' , body: 'test'}
      # categorysテーブルにデータが作成されている事を確認
      expect{ 
        post '/ideas', params: valid_params
      }.to change(Category, :count).by(+1)
      # ideasテーブルにデータが作成されている事を確認
      expect{ 
        post '/ideas', params: valid_params
      }.to change(Idea, :count).by(+1)
      # HTTPステータスコード201が返却される
      expect(response.status).to eq 201
    end
    it 'リクエストのcategory_nameが空の場合、ステータスコード422が返却される' do 
      valid_params = { category_name: '' , body: 'test'}
      # categorysテーブルにデータが作成されない事を確認
      expect{ 
        post '/ideas', params: valid_params
      }.to change(Category, :count).by(0)
      # ideasテーブルにデータが作成されない事を確認
      expect{ 
        post '/ideas', params: valid_params
      }.to change(Idea, :count).by(0)
      # HTTPステータスコード422が返却される
      expect(response.status).to eq 422
    end
    it 'リクエストのbodyが空の場合、ステータスコード422が返却される' do 
      valid_params = { category_name: @idea.category.name , body: ''}
      # categorysテーブルにデータが作成されない事を確認
      expect{ 
        post '/ideas', params: valid_params
      }.to change(Category, :count).by(0)
      # ideasテーブルにデータが作成されない事を確認
      expect{ 
        post '/ideas', params: valid_params
      }.to change(Idea, :count).by(0)
      # HTTPステータスコード422が返却される
      expect(response.status).to eq 422
    end
  end
end
