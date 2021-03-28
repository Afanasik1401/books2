require 'dry-schema'

NewBookFormSchema = Dry::Schema.Params do

  required(:name).filled(:string)
  required(:date).filled(:string, format?: /\d{4}-\d{2}-\d{2}/)
  required(:author).filled(:string)

end