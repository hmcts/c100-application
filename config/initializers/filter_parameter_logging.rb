# Note: no need to specify the whole exact parameter name, as this works like
# wildcards, so for example, entering here `details` will filter parameters
# with names like `substance_abuse_details`.
#
Rails.application.config.filter_parameters += [
  :email,
  :password,
  :details,
  :description,
  :reference,
  :solicitor_account_number,
  :current_location,
  :children_names,
  :case_number,
  :order_types,
  :first_name,
  :last_name,
  :full_name,
  :previous_name,
  :postcode,
  :address_data,
  :address_line,
  :selected_address,
  :phone,
  :fax_number,
  :residence_history,
  :recipient,
  :to,
  :declaration_signee,
]
