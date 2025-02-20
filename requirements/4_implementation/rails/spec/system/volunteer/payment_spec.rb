require 'rails_helper'

RSpec.describe 'Volunteer Payment Management', type: :system do
  let(:volunteer) { create(:user, :volunteer) }
  let(:member) { create(:user, :member) }

  before do
    sign_in volunteer
    visit new_volunteer_payment_path(user_id: member.id)
  end

  describe 'payment registration' do
    context 'with membership payment' do
      it 'registers basic membership payment' do
        select 'Adhésion Basic', from: 'Type'
        fill_in 'Montant', with: '1'
        select 'Espèces', from: 'Méthode de paiement'
        
        click_button 'Enregistrer'
        
        expect(page).to have_content('Paiement enregistré')
        expect(member.reload.memberships.basic).to be_present
      end

      it 'handles discounted circus membership' do
        select 'Adhésion Cirque', from: 'Type'
        select 'Étudiant', from: 'Raison de réduction'
        attach_file 'Justificatif', 'path/to/student_card.jpg'
        
        expect(page).to have_content('7.00 €')
        click_button 'Enregistrer'
        
        expect(page).to have_content('Paiement enregistré')
        expect(member.reload.memberships.circus).to be_present
      end
    end

    context 'with donation' do
      it 'handles additional donation' do
        select 'Adhésion Basic', from: 'Type'
        fill_in 'Montant', with: '1'
        fill_in 'Don', with: '5'
        
        click_button 'Enregistrer'
        
        expect(page).to have_content('Paiement et don enregistrés')
        expect(member.donations.last.amount).to eq(5)
      end
    end
  end
end 