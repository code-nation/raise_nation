class AddWebhookRefToWorkflow < ActiveRecord::Migration[6.0]
  def change
    add_column :workflows, :webhook_ref, :string
  end
end
