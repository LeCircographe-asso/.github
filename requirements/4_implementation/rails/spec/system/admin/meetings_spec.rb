require 'rails_helper'

RSpec.describe 'Admin Meeting Management', type: :system do
  let(:admin) { create(:user, :admin) }
  
  before do
    sign_in admin
    visit admin_meetings_path
  end

  describe 'meeting management' do
    it 'creates a new meeting' do
      click_link 'Nouvelle Réunion'
      
      fill_in 'Titre', with: 'Réunion CA'
      fill_in 'Date', with: Date.current
      fill_in 'Description', with: 'Réunion mensuelle'
      
      click_button 'Créer'
      
      expect(page).to have_content('Réunion créée')
      expect(page).to have_content('Réunion CA')
    end

    it 'manages attendees' do
      meeting = create(:daily_attendance_list, :meeting)
      visit admin_meeting_path(meeting)
      
      # Test d'ajout de participants
      # Test de suppression de participants
      # Test des permissions
    end
  end
end 