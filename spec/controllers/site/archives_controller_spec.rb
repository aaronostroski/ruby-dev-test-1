require 'rails_helper'

RSpec.describe Site::ArchivesController, type: :controller do
  describe 'Happy path' do
    it 'Create new archives'do
      params = {
        archive: {
            description: FFaker::Lorem.sentence,
            files: [
              Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf'),
            ]
        }
      }
      
      post :create, params: params

      expect(response).to have_http_status(302)

      archive = Archive.last

      expect(archive).to be_present      
      expect(archive.description).to eql(params[:archive][:description])
      expect(archive.file).to be_attached
    end


    it 'Updates archive'do
      archive = FactoryBot.create(:archive, :csv)
      params = {
        id: archive.id,
        archive: {
          name: FFaker::Lorem.word,
          description: FFaker::Lorem.sentence,
          file: Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'test.pdf'), 'application/pdf')
        }
      }
            
      patch :update, params: params

      expect(response).to have_http_status(302)
      archive.reload

      expect(archive).to be_present      
      expect(archive.name).to eql(params[:archive][:name])
      expect(archive.description).to eql(params[:archive][:description])
      expect(archive.filename).to eql('test.pdf')
      expect(archive.file).to be_attached
    end

    it 'Destroy Archive' do
      archive = FactoryBot.create(:archive)
      params = {
        id: archive.id 
      }

      delete :destroy, params: params

      expect(response).to have_http_status(302)      
      expect(Archive.count).to be 0
    end
  end

  describe 'Validations' do
    it 'Create archive but with invalid params' do
      params = {
        archive: {
          description: FFaker::Lorem.sentence,
          files: []
        }
      }
      
      post :create, params: params

      expect(response).to have_http_status(:unprocessable_entity)

      archive = Archive.last
      expect(archive).to be_nil      
    end
  end
end