# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_or_strong(name, options = {}, html_options = {}, *parameters_for_method_reference)
    link_to_unless_current(name, options, html_options, *parameters_for_method_reference) do |name|
      content_tag 'strong', name
    end
  end
end
