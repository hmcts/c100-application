class SpecialArrangements < ValueObject
  VALUES = [
    SEPARATE_WAITING_ROOMS = new(:separate_waiting_rooms),
    SEPARATE_ENTRANCE_EXIT = new(:separate_entrance_exit),
    PROTECTIVE_SCREENS     = new(:protective_screens),
    VIDEO_LINK             = new(:video_link),
  ].freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:
end
