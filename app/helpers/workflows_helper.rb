module WorkflowsHelper
  def workflow_type_choices(object_type = 'workflow')
    tag.div(class: 'workflow-type-choices') do
      radio_button(object_type, 'type', 'nr') +
        label_tag("#{object_type}_type_nr", 'Nation to Raisely') +
        radio_button(object_type, 'type', 'rn') +
        label_tag("#{object_type}_type_rn", 'Raisely to Nation')
    end
  end
end
