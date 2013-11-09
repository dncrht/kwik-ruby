module MainHelper

  def format_headings(headings_list)
    return if headings_list.length < 4

    content_tag(:ul, class: 'breadcrumb', id: 'jumpers') do
      headings_list.map do |heading|
        content_tag(:li) do
          heading.to_s
        end
      end.join.html_safe
    end
  end
end