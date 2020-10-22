module CampaignNameWithTypeConcern
  extend ActiveSupport::Concern

  included do
    def name_with_type
      "#{name} (#{self.class.name})"
    end
  end
end
