require 'rails_helper'

RSpec.describe 'Volunteer Event Management', type: :system do
  let(:volunteer) { create(:user, :volunteer) }
  let!(:event_list) { create(:daily_attendance_list, :event) }
  let(:member) { create(:user, :member) }
  let!(:membership) { create(:membership, :active, user: member) }

  before do
    sign_in volunteer
    visit volunteer_daily_attendance_list_path(event_list)
  end

  describe 'event check-in' do
    it 'allows checking in members to events' do
      fill_in 'member_search', with: member.name
      click_button 'Rechercher'
      
      within '.member-card' do
        click_button 'Pointer'
      end

      expect(page).to have_content('Présence enregistrée')
      expect(page).to have_content(member.name)
    end

    it 'shows event specific information' do
      expect(page).to have_content(event_list.title)
      expect(page).to have_content('Événement spécial')
    end
  end
end 