
module WikisHelper
    def markdown(text)
    extensions = {
      fenced_code_blocks: true
    }
    renderer = Redcarpet::Render::HTML.new()
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
    end

end
