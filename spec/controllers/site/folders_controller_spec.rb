require 'rails_helper'

RSpec.describe Site::FoldersController, type: :controller do
  describe 'Happy Path' do
    it 'Create new folder'do
      params = {
        folder: {
            name: FFaker::Lorem.word,
            description: FFaker::Lorem.sentence
        }
      }
      
      post :create, params: params

      expect(response).to have_http_status(302)

      folder = Folder.last

      expect(folder).to be_present      
      expect(folder.name).to eql(params[:folder][:name])
      expect(folder.description).to eql(params[:folder][:description])
    end

    it 'Destroy folder' do
      folder = FactoryBot.create(:folder)
      params = {
        id: folder.id 
      }

      delete :destroy, params: params

      expect(response).to have_http_status(302)      
      expect(Folder.count).to be 0
    end
  end

  describe 'Validations' do
    it 'Create folder but with invalid params' do
      params = {
        folder: {
            name: '',
            description: FFaker::Lorem.sentence
        }
      }
      
      post :create, params: params

      expect(response).to have_http_status(:unprocessable_entity)

      folder = Folder.last
      expect(folder).to be_nil      
    end
  end
end