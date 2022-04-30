class ReportsMailer < NotifyMailer
  #
  # Internal reports to be sent by email. Triggered by `daily_tasks`.
  #
  def failed_emails_report(report_content, to_address:)
    set_template(:failed_emails_report)
    set_personalisation(report_content: report_content)

    mail to: to_address
  end

  def payment_types_report(report_csv, to_address:, cc_address:)
    set_template(:payment_types_report)
    set_personalisation(
      link_to_report: Notifications.prepare_upload(
        StringIO.new(report_csv),
        true
      )
    )

    mail(to: to_address, cc: cc_address)
  end
end
