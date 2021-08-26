require 'rails_helper'

RSpec.describe 'Ideas', type: :request do
  before do
    @idea = FactoryBot.create(:idea)
    @another_idea = FactoryBot.create(:idea)
    @another_idea.update(category_id: @idea.category_id)
  end

  describe 'POST #create 1.アイデア登録API' do
    it 'リクエストのcategory_nameがcategoriesテーブルのnameに存在する場合、categoryのidをcategory_idとして、ideasテーブルに登録される' do
      valid_params = { category_name: @idea.category.name, body: 'test' }
      # categorysテーブルにはデータが作成されない事を確認
      expect do
        post '/ideas', params: valid_params
      end.to change(Category, :count).by(0)
      # ideasテーブルにデータが作成されている事を確認
      expect do
        post '/ideas', params: valid_params
      end.to change(Idea, :count).by(+1)
      # HTTPステータスコード201が返却される
      expect(response.status).to eq 201
    end
    it 'リクエストのcategory_nameがcategoriesテーブルのnameに存在しない場合、新たなcategoryとしてcategoriesテーブルに登録し、ideasテーブルに登録される' do
      valid_params = { category_name: 'ダミーカテゴリー', body: 'test' }
      # categorysテーブルにデータが作成されている事を確認
      expect do
        post '/ideas', params: valid_params
      end.to change(Category, :count).by(+1)
      # ideasテーブルにデータが作成されている事を確認
      expect do
        post '/ideas', params: valid_params
      end.to change(Idea, :count).by(+1)
      # HTTPステータスコード201が返却される
      expect(response.status).to eq 201
    end
    it 'リクエストのcategory_nameが空の場合、ステータスコード422が返却される' do
      valid_params = { category_name: '', body: 'test' }
      # categorysテーブルにデータが作成されない事を確認
      expect do
        post '/ideas', params: valid_params
      end.to change(Category, :count).by(0)
      # ideasテーブルにデータが作成されない事を確認
      expect do
        post '/ideas', params: valid_params
      end.to change(Idea, :count).by(0)
      # HTTPステータスコード422が返却される
      expect(response.status).to eq 422
    end
    it 'リクエストのbodyが空の場合、ステータスコード422が返却される' do
      valid_params = { category_name: @idea.category.name, body: '' }
      # categorysテーブルにデータが作成されない事を確認
      expect do
        post '/ideas', params: valid_params
      end.to change(Category, :count).by(0)
      # ideasテーブルにデータが作成されない事を確認
      expect do
        post '/ideas', params: valid_params
      end.to change(Idea, :count).by(0)
      # HTTPステータスコード422が返却される
      expect(response.status).to eq 422
    end
  end

  describe 'GET #index 2.アイデア取得API' do
    it 'indexアクションにcategory_nameをリクエストで指定しないとと全てのideasが返却される' do
      FactoryBot.create_list(:idea, 5)
      valid_params = { category_name: '' }
      get ideas_path, params: valid_params
      json = JSON.parse(response.body)
      # 正常にレスポンスが返ってくる
      expect(response.status).to eq 200
      # 全てのideasの一覧が返却される(@idea,another_idea,5件のダミーデータ計：7件)
      expect(json['data'].length).to eq(7)
    end
    it 'indexアクションに既に保存されているcategory_nameをリクエストで指定すると該当するcategoryのideasの一覧が返却される' do
      FactoryBot.create_list(:idea, 5)
      valid_params = { category_name: @idea.category.name }
      get ideas_path, params: valid_params
      json = JSON.parse(response.body)
      # 正常にレスポンスが返ってくる
      expect(response.status).to eq 200
      # リクエストで送信した「category_name」に該当するcategoryのideasの一覧が返却される(@idea,another_idea)
      expect(json['data'].length).to eq(2)
      # 返却された一覧のcategoryは全てリクエストで送信した「category_name」である
      json['data'].length.times do |i|
        expect(json['data'][i]['category']).to eq(@idea.category.name)
      end
    end
    it 'indexアクションに登録されていないカテゴリーのリクエストで指定するとステータスコード404が返却される' do
      dummy_params = 'ダミーデータ'
      valid_params = { category_name: dummy_params }
      get ideas_path, params: valid_params
      # ステータスコード404でレスポンスが返却される
      expect(response.status).to eq 404
    end
  end
end
