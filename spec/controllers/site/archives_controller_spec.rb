require 'rails_helper'

RSpec.describe Site::ArchivesController, type: :controller do
  describe 'Consumes Archives API' do
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