class Workflow < ApplicationRecord
  belongs_to :source, polymorphic: true
  belongs_to :target, polymorphic: true
  belongs_to :account

  DEFAULT_SOURCE_TYPE = 'Nation'.freeze
  DEFAULT_TARGET_TYPE = 'RaiselyCampaign'.freeze

  CHOICES_WORKFLOW_HASH = {
    "nr" => {
      "source" => Nation.name,
      "target" => RaiselyCampaign.name
    },
    "rn" => {
      "source" => RaiselyCampaign.name,
      "target" => Nation.name
    }
  }

  attr_accessor :type

  before_save :cleanup_tags

  validates :source_id, uniqueness: { scope: [:source_type, :target_id, :target_type] }

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

  def save_and_process_webhook!(url)
    Workflow.transaction do
      save
      process_webhook!(url)
    end
  rescue
    false
  end

  def process_webhook!(url)
    return if webhook_ref.present?

    webhook_ref = source.create_webhook(url)
    update(webhook_ref: webhook_ref) if webhook_ref.present?
  rescue
    puts "Cannot process workflow due to invalid api key or token, skipping..."
    false
  end

  private

  def cleanup_tags
    self.donor_tags = donor_tags.select(&:present?)
    self.recurring_donor_tags = recurring_donor_tags.select(&:present?)
  end
end
