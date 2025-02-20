require 'rails_helper'

RSpec.describe 'Volunteer Check-in', type: :system do
  let(:volunteer) { create(:user, :volunteer) }
  let(:member) { create(:user, :member) }
  let!(:membership) { create(:membership, :active, user: member) }
  let!(:daily_list) { create(:daily_attendance_list, :training) }

  before do
    sign_in volunteer
    visit volunteer_daily_attendance_list_path(daily_list)
  end

  describe 'check-in process' do
    it 'allows checking in a valid member' do
      fill_in 'member_search', with: member.name
      click_button 'Rechercher'
      
      within '.member-card' do
        expect(page).to have_content(member.name)
        expect(page).to have_content('Adhésion valide')
        click_button 'Pointer'
      end

      expect(page).to have_content('Présence enregistrée')
      within '.attendees-list' do
        expect(page).to have_content(member.name)
      end
    end

    it 'shows error for expired membership' do
      membership.update!(end_date: 1.day.ago)
      
      fill_in 'member_search', with: member.name
      click_button 'Rechercher'
      
      within '.member-card' do
        expect(page).to have_content('Adhésion expirée')
        expect(page).not_to have_button('Pointer')
      end
    end
  end
end 