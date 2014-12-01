class AtLeastOneValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.detect {|x| x.valid? && !x.marked_for_destruction? }
      # found at least 1 child valid and NOT marked_for_destruction
    else
      record.errors.add(attribute, options[:message] || I18n.t('errors.messages.blank')) # need error on self to halt :save
    end
  end
end
