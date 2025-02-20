RSpec.describe DailyAttendanceList, type: :model do
  describe "validations" do
    let(:list) { build(:daily_attendance_list, :training) }

    context "when creating on a holiday" do
      before do
        allow(HolidayService).to receive(:holiday?).and_return(true)
      end

      it "marks as cancelled" do
        list.save
        expect(list).to be_cancelled
        expect(list).to be_holiday
      end
    end

    context "when creating during exceptional closing" do
      before do
        allow(ClosingService).to receive(:closed_on?).and_return(true)
      end

      it "marks as cancelled" do
        list.save
        expect(list).to be_cancelled
        expect(list).to be_exceptional_closing
      end
    end

    context "with duplicate list" do
      before do
        create(:daily_attendance_list, :training, date: Date.current)
      end

      it "prevents duplicate creation" do
        list.date = Date.current
        expect(list).not_to be_valid
        expect(list.errors[:base]).to include(
          "Une liste de ce type existe déjà pour cette date"
        )
      end
    end
  end

  describe "#can_be_attended_by?" do
    let(:list) { create(:daily_attendance_list, :training) }
    let(:user) { create(:user) }

    context "when list is cancelled" do
      before { list.update(status: :cancelled) }

      it "denies access" do
        expect(list.can_be_attended_by?(user)).to be false
      end
    end

    context "when list is active" do
      before { list.update(status: :active) }

      it "checks user permissions" do
        expect(user).to receive(:can_access_training?).and_return(true)
        expect(list.can_be_attended_by?(user)).to be true
      end
    end
  end
end 