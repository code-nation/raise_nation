class Workflow < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true
  belongs_to :account

  DEFAULT_SOURCE_TYPE = 'Nation'.freeze
  DEFAULT_TARGET_TYPE = 'RaiselyCampaign'.freeze

  attr_accessor :type

  def source_type
    return DEFAULT_SOURCE_TYPE if type.blank?

    case type
    when 'nr'
      DEFAULT_SOURCE_TYPE
    when 'rn'
      DEFAULT_TARGET_TYPE
    end
  end

  def target_type
    return DEFAULT_TARGET_TYPE if type.blank?

    case type
    when 'nr'
      DEFAULT_TARGET_TYPE
    when 'rn'
      DEFAULT_SOURCE_TYPE
    end
  end
end
