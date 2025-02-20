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

  describe "statistics" do
    let(:list) { create(:daily_attendance_list, :training, max_capacity: 20) }
    
    before do
      create_list(:attendance, 3, daily_attendance_list: list)
      create(:attendance, :with_subscription, daily_attendance_list: list)
      create(:attendance, :with_volunteer, daily_attendance_list: list)
    end

    describe "#attendance_stats" do
      it "returns complete statistics" do
        stats = list.attendance_stats
        
        expect(stats[:total_attendees]).to eq(5)
        expect(stats[:subscription_users]).to eq(1)
        expect(stats[:volunteers]).to eq(1)
        expect(stats[:capacity_percentage]).to eq(25.0)
        expect(stats[:peak_hours]).to be_a(Hash)
      end
    end

    describe "#daily_report" do
      it "includes all necessary information" do
        report = list.daily_report
        
        expect(report[:date]).to eq(list.date)
        expect(report[:type]).to eq(list.list_type)
        expect(report[:status]).to eq(list.status)
        expect(report[:stats]).to be_present
        expect(report[:exceptions]).to include(
          holiday: be_in([true, false]),
          exceptional_closing: be_in([true, false])
        )
      end
    end
  end
end 