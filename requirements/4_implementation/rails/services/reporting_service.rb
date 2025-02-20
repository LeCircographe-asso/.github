class ReportingService
  class << self
    def generate_monthly_report(month = Date.current.beginning_of_month)
      {
        memberships: membership_stats(month),
        attendance: attendance_stats(month),
        financial: financial_stats(month),
        summary: generate_summary(month)
      }
    end

    private

    def membership_stats(month)
      {
        new_members: Membership.where(created_at: month.all_month).count,
        active_members: Membership.active.count,
        expiring_soon: Membership.where(expires_at: month.all_month).count,
        renewals: Membership.where(renewal: true, created_at: month.all_month).count,
        by_type: {
          basic: Membership.basic.where(created_at: month.all_month).count,
          circus: Membership.circus.where(created_at: month.all_month).count
        }
      }
    end

    def attendance_stats(month)
      lists = DailyAttendanceList.where(date: month.all_month)
      attendances = Attendance.joins(:daily_attendance_list)
                            .where(daily_attendance_lists: { date: month.all_month })

      {
        total_sessions: lists.count,
        total_attendees: attendances.count,
        average_per_day: attendances.group('daily_attendance_lists.date').count.values.average,
        peak_day: find_peak_day(attendances),
        by_type: attendance_by_type(attendances),
        capacity_stats: calculate_capacity_stats(lists)
      }
    end

    def financial_stats(month)
      payments = Payment.where(created_at: month.all_month)
      
      {
        total_revenue: payments.sum(:amount),
        by_category: {
          memberships: payments.membership_payments.sum(:amount),
          subscriptions: payments.subscription_payments.sum(:amount),
          donations: payments.donations.sum(:amount)
        },
        by_method: payments.group(:payment_method).sum(:amount),
        discounts_applied: calculate_discounts(payments),
        average_transaction: payments.average(:amount)
      }
    end

    def generate_summary(month)
      {
        month: month.strftime("%B %Y"),
        key_metrics: {
          new_members_growth: calculate_growth(:new_members, month),
          revenue_growth: calculate_growth(:revenue, month),
          attendance_growth: calculate_growth(:attendance, month)
        },
        alerts: generate_alerts(month),
        recommendations: generate_recommendations(month)
      }
    end

    def find_peak_day(attendances)
      peak = attendances.group('daily_attendance_lists.date')
                       .count
                       .max_by { |_, count| count }
      
      peak ? { date: peak[0], count: peak[1] } : nil
    end

    def attendance_by_type(attendances)
      attendances.joins(:daily_attendance_list)
                .group('daily_attendance_lists.list_type')
                .count
    end

    def calculate_capacity_stats(lists)
      {
        average_capacity: lists.average(:capacity_percentage),
        full_sessions: lists.where(capacity_percentage: 90..100).count,
        low_attendance: lists.where(capacity_percentage: 0..30).count
      }
    end

    def calculate_discounts(payments)
      {
        total_amount: payments.sum(:discount_amount),
        count: payments.where.not(discount_amount: nil).count,
        average: payments.average(:discount_amount)
      }
    end

    def calculate_growth(metric, month)
      current = send("#{metric}_for_month", month)
      previous = send("#{metric}_for_month", month.prev_month)
      
      return 0 if previous.zero?
      ((current - previous) / previous.to_f * 100).round(2)
    end

    def new_members_for_month(month)
      Membership.where(created_at: month.all_month).count
    end

    def revenue_for_month(month)
      Payment.where(created_at: month.all_month).sum(:amount)
    end

    def attendance_for_month(month)
      Attendance.joins(:daily_attendance_list)
               .where(daily_attendance_lists: { date: month.all_month })
               .count
    end

    def generate_alerts(month)
      alerts = []
      
      stats = attendance_stats(month)
      if stats[:average_per_day] < 10
        alerts << "Faible fréquentation moyenne (#{stats[:average_per_day]} personnes/jour)"
      end

      financial = financial_stats(month)
      if financial[:total_revenue] < 1000
        alerts << "Revenu mensuel bas (#{financial[:total_revenue]}€)"
      end

      alerts
    end

    def generate_recommendations(month)
      recommendations = []
      stats = attendance_stats(month)
      
      if stats[:low_attendance] > 5
        recommendations << "Envisager une campagne de promotion pour les créneaux peu fréquentés"
      end

      if stats[:full_sessions] > stats[:total_sessions] * 0.5
        recommendations << "Considérer l'augmentation de la capacité ou l'ajout de créneaux"
      end

      recommendations
    end
  end
end 