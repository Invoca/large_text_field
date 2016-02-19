# LargeTextField

Large text fields on any model without migrations.

# What can Large Text Fields do for me?

This gem allows any model to be associated with multiple named text fields.  Each field can hold up to 5 million UTF8
characters.  Defining new fields on models does not require a database migrations. All text fields are stored in a
central table that is polymorphically associated with the model, but they act like a column on on the same model.

# How do I use it?

In you gemfile add:

  gem large_text_fields

There will be database migration you need to run to define the table, so go ahead and define that.

Any class that wants to define a large text field should include LargeTextField::Owner

class Library < ActiveRecord::Base
  include LargeTextField::Owner
  large_text_field :notes
  large_text_field :description
end

That is it.  You can then access notes and description as if they were columns on your class.

The large_text_field macro takes the following options...

  maximum: - The maximum length of a large text field. By default this is 5,000,000 characters, but it can be set to less using this option.
  singularize_errors: - should validation messages be signularized.


Large text field uses the before_save callback to process the changes.  If you need to make updates to large_text_field
values during a before_save callback, hook the large_text_field_save instead.  Using before_save may work, but the order
callback processing is not deterministic.



This project rocks and uses MIT-LICENSE.

TODO:

Add test: reload behavior when updates come from somewhere else.
Add test: cascading delete behavior.
Add test for singularize_errors