module WorkflowsHelper
  def workflow_type_choices(object_type = "workflow")
    tag.div(class: 'workflow-type-choices') do
      radio_button(object_type, "type", "nr") +
        label_tag("Nation to Raisely") +
        radio_button(object_type, "type", "rn") +
        label_tag("Raisely to Nation")
    end
  end
end
