RSpec.describe Membership, type: :model do
  describe "validations" do
    describe "#validate_renewal_dates" do
      let(:user) { create(:user) }
      let!(:current_membership) do
        create(:membership, 
          user: user,
          start_date: Date.current,
          end_date: Date.current + 1.year
        )
      end

      context "when renewing membership" do
        let(:renewal) { build(:membership, user: user) }

        it "rejects start date before current end date" do
          renewal.start_date = current_membership.end_date - 1.day
          expect(renewal).not_to be_valid
          expect(renewal.errors[:start_date]).to include(
            "doit être postérieure à la fin de l'adhésion actuelle"
          )
        end

        it "rejects start date too far in the future" do
          renewal.start_date = current_membership.end_date + 31.days
          expect(renewal).not_to be_valid
          expect(renewal.errors[:start_date]).to include(
            "doit être dans les 30 jours suivant la fin de l'adhésion actuelle"
          )
        end

        it "accepts valid renewal date" do
          renewal.start_date = current_membership.end_date + 1.day
          expect(renewal).to be_valid
        end
      end
    end
  end
end 