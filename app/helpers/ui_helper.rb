module UiHelper
  def card(title, actions: nil, &block)
    content_tag :div, class: "card" do
      concat header(title, actions)
      concat capture(&block)
    end
  end

  def alert(kind, message = nil, &block)
    content = block ? capture(&block) : message
    content_tag :div, content, class: "alert alert-#{kind}", role: "alert"
  end

  def btn(label, path, style: "primary", method: nil, confirm: nil)
    classes = "btn btn-#{style} btn-sm"

    if method
      button_to label, path, method: method, class: classes,
        form: { class: "d-inline" }, data: { turbo_confirm: confirm }.compact_blank
    else
      link_to label, path, class: classes
    end
  end

  private

  def header(title, actions)
    content_tag :div, class: "card-header d-flex align-items-center" do
      concat content_tag(:h1, title, class: "card-title")
      concat content_tag(:div, actions_body(actions), class: "ms-auto d-flex align-items-center") if actions
    end
  end

  def actions_body(actions)
    actions.is_a?(Array) ? safe_join(actions, " ") : actions
  end
end
