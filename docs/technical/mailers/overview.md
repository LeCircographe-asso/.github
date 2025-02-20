# Mailers et Notifications

## Configuration Email

### SMTP Setup
```ruby
# config/environments/production.rb
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  address: 'smtp.sendgrid.net',
  port: 587,
  domain: 'circographe.fr',
  user_name: ENV['SENDGRID_USERNAME'],
  password: ENV['SENDGRID_PASSWORD'],
  authentication: 'plain',
  enable_starttls_auto: true
}
```

### Layout Email
```erb
<%# app/views/layouts/mailer.html.erb %>
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style>
      /* Email styles */
      .email-container {
        max-width: 600px;
        margin: 0 auto;
        font-family: sans-serif;
      }
      .header {
        background: #4f46e5;
        color: white;
        padding: 20px;
        text-align: center;
      }
    </style>
  </head>

  <body>
    <div class="email-container">
      <div class="header">
        <%= image_tag attachments['logo.png'].url, alt: 'Le Circographe' if attachments['logo.png'] %>
      </div>
      <%= yield %>
      <%= render 'shared/mailer/footer' %>
    </div>
  </body>
</html>
```

### Configuration Email
```ruby
# config/initializers/email.rb
Rails.application.configure do
  config.action_mailer.delivery_method = Rails.env.development? ? :letter_opener : :smtp
  config.action_mailer.perform_deliveries = true
  
  # Premailer pour l'inline CSS
  config.premailer.strategies = [:premailer]
end

# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@circographe.fr'
  layout 'mailer'
  
  # Utilise premailer pour l'inline CSS
  before_action :set_premailer_options
end
```

## Mailers

### Membership Mailer
```ruby
# app/mailers/membership_mailer.rb
class MembershipMailer < ApplicationMailer
  def welcome_email(user)
    @user = user
    @membership = user.current_membership
    
    attachments.inline['logo.png'] = File.read('app/assets/images/logo.png')
    attachments['carte_membre.pdf'] = membership_card_pdf(@membership)
    
    mail(
      to: @user.email,
      subject: "Bienvenue au Circographe !"
    )
  end

  def renewal_reminder(membership)
    @user = membership.user
    @membership = membership
    @expiration_date = membership.end_date
    
    mail(
      to: @user.email,
      subject: "Votre adhésion expire bientôt"
    )
  end

  private

  def membership_card_pdf(membership)
    MembershipCardPdf.new(membership).render
  end
end
```

### Payment Mailer
```ruby
# app/mailers/payment_mailer.rb
class PaymentMailer < ApplicationMailer
  def payment_confirmation(payment)
    @payment = payment
    @user = payment.user
    
    attachments['recu.pdf'] = generate_receipt(@payment)
    
    mail(
      to: @user.email,
      subject: "Confirmation de paiement - #{payment.reference}"
    )
  end

  private

  def generate_receipt(payment)
    ReceiptPdf.new(payment).render
  end
end
```

## Notifications

### Notification Service
```ruby
# app/services/notification_service.rb
class NotificationService
  def self.notify(user:, type:, data: {})
    notification = user.notifications.create!(
      notification_type: type,
      data: data
    )

    broadcast_notification(notification)
    deliver_email(notification) if notification.email_required?
    
    notification
  end

  private

  def self.broadcast_notification(notification)
    Turbo::StreamsChannel.broadcast_append_to(
      "user_#{notification.user_id}_notifications",
      target: "notifications",
      partial: "notifications/notification",
      locals: { notification: notification }
    )
  end

  def self.deliver_email(notification)
    NotificationMailer.send(
      notification.email_method,
      notification
    ).deliver_later
  end
end
```

### Notification Types
```ruby
# app/models/notification.rb
class Notification < ApplicationRecord
  TYPES = {
    membership_expiring: {
      template: 'membership_expiring',
      email_required: true
    },
    payment_received: {
      template: 'payment_received',
      email_required: true
    },
    attendance_recorded: {
      template: 'attendance_recorded',
      email_required: false
    }
  }.freeze

  belongs_to :user
  
  validates :notification_type, inclusion: { in: TYPES.keys.map(&:to_s) }
  
  def email_required?
    TYPES[notification_type.to_sym][:email_required]
  end

  def email_method
    "#{notification_type}_email"
  end
end
```

### Système de Notifications
```ruby
# app/notifications/application_notification.rb
class ApplicationNotification < Noticed::Base
  deliver_by :database
  deliver_by :email, mailer: 'NotificationMailer'
  deliver_by :webpush, if: :push_enabled?
  
  private
  
  def push_enabled?
    recipient.push_notifications_enabled?
  end
end

# app/notifications/membership_expiration_notification.rb
class MembershipExpirationNotification < ApplicationNotification
  param :membership
  
  def message
    "Votre adhésion expire le #{membership.end_date.strftime('%d/%m/%Y')}"
  end
end
``` 