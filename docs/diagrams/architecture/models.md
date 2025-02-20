classDiagram
    class User {
        +String email
        +String name
        +has_many roles
        +has_many memberships
        +has_many subscriptions
        +has_many attendances
        +boolean member?()
        +boolean volunteer?()
        +boolean admin?()
    }

    class DailyAttendanceList {
        +Date date
        +String list_type
        +String title
        +Text description
        +Boolean automatic
        +has_many attendances
        +belongs_to created_by
        +generate_daily_training()
        +can_be_managed_by?(user)
        +can_checkin?(user)
    }

    class Attendance {
        +belongs_to daily_attendance_list
        +belongs_to user
        +belongs_to recorded_by
        +belongs_to subscription
        +validate_user_membership()
        +decrement_subscription()
    }

    class Membership {
        +Date start_date
        +Date end_date
        +String type
        +belongs_to user
        +has_many payments
        +boolean active?()
    }

    class Subscription {
        +Date start_date
        +Date end_date
        +Integer entries_count
        +Integer entries_left
        +belongs_to user
        +has_many attendances
        +boolean active?()
    }

    User "1" -- "*" Membership
    User "1" -- "*" Subscription
    User "1" -- "*" Attendance
    DailyAttendanceList "1" -- "*" Attendance
    Subscription "1" -- "*" Attendance 