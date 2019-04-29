module ApplicationHelper
  def human_errors_for(entity)
    entity.errors.full_messages.to_sentence
  end
end
