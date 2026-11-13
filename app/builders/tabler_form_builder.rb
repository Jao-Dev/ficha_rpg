class TablerFormBuilder < ActionView::Helpers::FormBuilder
  FIELD_HELPERS = %i[text_field email_field password_field file_field].freeze

  FIELD_HELPERS.each do |helper|
    define_method(helper) do |attribute, options = {}|
      super(attribute, **options, class: append_class("form-control", options[:class]))
    end
  end

  def label(attribute, text = nil, options = {})
    text, options = nil, text if text.is_a?(Hash)
    options[:class] = append_class("form-label", options[:class])

    super(attribute, text, options)
  end

  def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
    super(method, collection, value_method, text_method, options,
      html_options.merge(class: append_class("form-select", html_options[:class])))
  end

  def submit(value = nil, options = {})
    super(value, **options, class: append_class("btn btn-primary", options[:class]))
  end

  private

  def append_class(base, extra)
    extra ? "#{base} #{extra}" : base
  end
end
