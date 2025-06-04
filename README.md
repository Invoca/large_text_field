# LargeTextField

This gem allows any model to be associated with multiple named text fields. Each field can hold up to 5 million UTF8
characters. Defining new fields on models does not require database migrations. All text fields are stored in a
central table that is polymorphically associated with the model, but they act like a column on the same model.

## How do I use it?

In you Gemfile add:

```
  gem large_text_field
```

There will be database migration you need to run to define the table, so go ahead and run that...

Any class that wants to define a large text field should include **::LargeTextField::Owner**,
and then define text fields by calling the **large_text_field** macro.

For example the following is a `Library` class that has large text fields for `notes` and `description`.

```ruby
class Library < ApplicationRecord
  include ::LargeTextField::Owner

  large_text_field :notes
  large_text_field :description
end
```

That's it! You can then access `notes` and `description` as if they were columns on your class.

The `large_text_field` macro takes the following options...

- **maximum: number** - The maximum length of a large text field. By default this is 5,000,000 characters,
  but it can be set to less using this option.
- **singularize_errors: boolean** - should validation messages be singularized.

Large text fields defaults to an empty string. You cannot store `nil` in a large text field.

**Please note:** Large text field uses the _before_save_ callback on the class that is the owner for book-keeping.  
Callbacks are great, but if there are multiple handlers for the same callback the order in which they are called is
not predictable. If you want to make changes to large_text_field values in the before_save callback, use the
**large_text_field_save** callback instead. This will be called before the large text field book-keeping so your
changes will be saved. For example, this will call the `save_preprocess` method on your class before the large text
fields are saved...

```ruby
  set_callback(:large_text_field_save, :before, :save_preprocess)
```

Added class methods:

```ruby
  large_text_field_deprecated_class_name_override "LargeTextField::NamedTextValue"
  large_text_field_class_name_override "MyCustomLargeTextField"
```

You will not generally need this support; however, it can be helpful when trying to separate a model into a
different database.

This project rocks and uses MIT-LICENSE. You should too.
