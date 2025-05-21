class ApplicationAction
  include ActiveModel::Model

  def save
    return false unless valid?

    ApplicationRecord.transaction { run }

    true
  end

  def save!
    raise errors.full_messages.join(", ") unless save
  end

  def run
    raise I18n.t("errors.messages.not_implemented")
  end
end
