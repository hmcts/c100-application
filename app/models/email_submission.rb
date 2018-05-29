class EmailSubmission < ApplicationRecord
  belongs_to :c100_application

  def initialize(params = {})
    @email_copy_to = params[:email_copy_to]
    @c100_application = params[:c100_application]
    @to_address = @c100_application.try(:court_from_screener_answers).try(:email)
    @from = ENV['SUBMISSION_EMAIL_FROM']
    super
  end

  def send!(pdf_file_path)
    # if the court case worker hits reply, it should go to either
    # the email given by the user (if present),
    # or the default submission email address
    # (in case it bounces, and the bounce-back includes the
    # submitted user data)
    response = EmailSubmissionMailer.submission_to_court(
      c100_application: c100_application,
      from: @from,
      to: @to_address,
      reply_to: (@email_copy_to || @from),
      attachment: pdf_file_path
    ).deliver_now!
    self.sent_at = Time.now.utc
    self.message_id = response.message_id

    if self.email_me_a_copy.to_s.eql? GenericYesNo::YES
      # if the user hits reply, it should go to the court
      response = EmailSubmissionMailer.copy_to_user(
        c100_application: c100_application,
        from: @from,
        to: @email_copy_to,
        reply_to: @to_address,
        attachment: pdf_file_path
      ).deliver_now!
      self.sent_at = Time.now.utc
      self.message_id = response.message_id
    end

    # save the timestamp & message id
    save!
  end
end
