# Shared rules for the public lead forms (stock alerts, sell requests): a way to reach the person,
# explicit privacy consent, and a hidden "website" field that only bots fill in.
module LeadForm
  extend ActiveSupport::Concern

  included do
    attr_accessor :website
    attribute :privacy_accepted, :boolean

    validates :name, presence: { message: "es obligatorio" }, length: { maximum: 120, message: "es demasiado largo" }
    validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "no parece válido" }, allow_blank: true
    validates :privacy_accepted, acceptance: { accept: true, message: "debe aceptarse para enviar el formulario" }, on: :create
    validate :email_or_phone_present
  end

  def spam?
    website.present?
  end

  def whatsapp_number
    digits = phone.to_s.delete("^0-9")
    return if digits.length < 9

    digits.length == 9 ? "34#{digits}" : digits
  end

  private

  def email_or_phone_present
    errors.add(:base, "Indica un email o un teléfono para poder contactarte") if email.blank? && phone.blank?
  end
end
