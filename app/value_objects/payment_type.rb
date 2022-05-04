class PaymentType < ValueObject
  VALUES = [
    ONLINE = new(:online),
    HELP_WITH_FEES = new(:help_with_fees),
    SOLICITOR = new(:solicitor),
    SELF_PAYMENT_CARD = new(:self_payment_card),
    SELF_PAYMENT_CHEQUE = new(:self_payment_cheque),
  ].freeze

  def self.values
    VALUES
  end
end
