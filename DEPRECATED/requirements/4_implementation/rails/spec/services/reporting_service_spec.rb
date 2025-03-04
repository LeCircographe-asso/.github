RSpec.describe ReportingService do
  describe '.generate_monthly_report' do
    let(:month) { Date.current.beginning_of_month }
    let(:user) { create(:user) }
    
    before do
      # Création des données de test
      create_list(:membership, 3, :basic, created_at: month + 1.day)
      create_list(:membership, 2, :circus, created_at: month + 2.days)
      create(:membership, :basic, created_at: month - 1.month, expires_at: month + 15.days)

      create_list(:daily_attendance_list, 5, date: month + 1.day, capacity_percentage: 95)
      create_list(:daily_attendance_list, 3, date: month + 2.days, capacity_percentage: 25)

      create_list(:payment, 2, :membership_payment, amount: 100, created_at: month + 1.day)
      create(:payment, :subscription_payment, amount: 50, created_at: month + 2.days)
      create(:payment, :donation, amount: 25, created_at: month + 3.days)
    end

    it 'generates a complete monthly report' do
      report = ReportingService.generate_monthly_report(month)

      expect(report).to include(:memberships, :attendance, :financial, :summary)
    end

    describe 'membership stats' do
      it 'calculates correct membership statistics' do
        stats = ReportingService.generate_monthly_report(month)[:memberships]

        expect(stats[:new_members]).to eq(5) # 3 basic + 2 circus
        expect(stats[:expiring_soon]).to eq(1)
        expect(stats[:by_type]).to include(
          basic: 3,
          circus: 2
        )
      end
    end

    describe 'attendance stats' do
      it 'calculates correct attendance statistics' do
        stats = ReportingService.generate_monthly_report(month)[:attendance]

        expect(stats[:total_sessions]).to eq(8) # 5 + 3 sessions
        expect(stats[:capacity_stats]).to include(
          full_sessions: 5,
          low_attendance: 3
        )
      end
    end

    describe 'financial stats' do
      it 'calculates correct financial statistics' do
        stats = ReportingService.generate_monthly_report(month)[:financial]

        expect(stats[:total_revenue]).to eq(275) # 2*100 + 50 + 25
        expect(stats[:by_category]).to include(
          memberships: 200,
          subscriptions: 50,
          donations: 25
        )
      end
    end

    describe 'summary' do
      it 'includes growth metrics and recommendations' do
        summary = ReportingService.generate_monthly_report(month)[:summary]

        expect(summary).to include(:key_metrics, :alerts, :recommendations)
        expect(summary[:month]).to eq(month.strftime("%B %Y"))
      end

      context 'with low attendance' do
        before do
          allow_any_instance_of(Hash).to receive(:[]).with(:average_per_day).and_return(5)
        end

        it 'generates appropriate alerts' do
          summary = ReportingService.generate_monthly_report(month)[:summary]
          expect(summary[:alerts]).to include(match(/Faible fréquentation/))
        end
      end

      context 'with high capacity usage' do
        before do
          create_list(:daily_attendance_list, 10, capacity_percentage: 95)
        end

        it 'suggests capacity increase' do
          summary = ReportingService.generate_monthly_report(month)[:summary]
          expect(summary[:recommendations]).to include(match(/augmentation de la capacité/))
        end
      end
    end
  end
end 