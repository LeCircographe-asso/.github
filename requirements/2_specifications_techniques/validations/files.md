# Validations des Fichiers

## Images
```ruby
class ImageValidator < ActiveModel::Validator
  def validate(record)
    return unless record.image.attached?

    unless record.image.blob.content_type.in?(%w[image/jpeg image/png image/gif])
      record.errors.add(:image, 'doit être un fichier JPEG, PNG ou GIF')
    end

    if record.image.blob.byte_size > 5.megabytes
      record.errors.add(:image, 'ne doit pas dépasser 5MB')
    end
  end
end
```

## Documents
```ruby
class DocumentValidator < ActiveModel::Validator
  VALID_TYPES = %w[
    application/pdf
    application/msword
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
  ]

  def validate(record)
    return unless record.document.attached?

    unless record.document.blob.content_type.in?(VALID_TYPES)
      record.errors.add(:document, 'doit être un fichier PDF ou DOC(X)')
    end

    if record.document.blob.byte_size > 5.megabytes
      record.errors.add(:document, 'ne doit pas dépasser 5MB')
    end
  end
end 