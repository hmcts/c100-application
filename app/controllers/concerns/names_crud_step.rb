module NamesCrudStep
  extend ActiveSupport::Concern

  included do
    before_action :set_existing_records
  end

  def edit
    @form_object = names_form_class.new(
      c100_application: current_c100_application
    )
  end

  def update
    if params.key?(:remove_name)
      destroy(params[:remove_name]) && return
    end

    update_and_advance(
      names_form_class,
      as: params.fetch(:button, :names_finished)
    )
  end

  private

  def destroy(uuid)
    @existing_records.destroy(uuid)
    redirect_to action: :edit, id: nil
  end

  def additional_permitted_params
    [names_attributes: [:id, :first_name, :last_name]]
  end
end
