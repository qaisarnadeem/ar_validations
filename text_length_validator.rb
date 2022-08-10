def no_length_validation?(column,model)
  model._validators[column.name.to_sym].map(&:class).exclude?(ActiveRecord::Validations::LengthValidator)
end

Rails.application.eager_load!
exceptions = ['ClockingCard']

models =  ActiveRecord::Base.descendants.select {|m| m.table_name && exceptions.exclude?(m.name.to_s)}
(models - exceptions).each do |model|
  text_columns = model.columns.select do |c|
    c.type == :text && no_length_validation?(c,model)
  end

  if text_columns.length > 0
    puts "No length validation for model: #{model.name} and columns: #{text_columns.map(&:name)}"
  end
end
true
