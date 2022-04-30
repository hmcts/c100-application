class ChangeLanguageFields < ActiveRecord::Migration[5.2]
  def up
    CourtArrangement.update_all(language_interpreter: nil)

    remove_column :court_arrangements, :sign_language_interpreter
    remove_column :court_arrangements, :welsh_language

    rename_column :court_arrangements, :language_interpreter, :language_options

    # 2-steps change because otherwise cast will fail even tho we don't care about data being lost
    change_column :court_arrangements, :language_options, :string
    change_column :court_arrangements, :language_options, :string, array: true, default: [], using: "string_to_array(language_options, ',')"

    # Remove the empty array defaults as otherwise we do not know when
    # a step (form object) has been reached or not yet (important for CYA)
    #
    change_column_default :court_arrangements, :language_options, nil
    change_column_default :court_arrangements, :special_arrangements, nil
    change_column_default :court_arrangements, :special_assistance, nil
  end
end
