module ApplicationHelper
  include Pagy::Frontend

  def nav_link_to(label, path, **opts)
    active = current_path_matches?(path)
    base   = "px-3 py-2 rounded-md text-sm font-medium transition-colors duration-150 ease-out focus:outline-none focus-visible:ring-2 focus-visible:ring-brand focus-visible:ring-offset-2 focus-visible:ring-offset-surface"
    state  = active ? "text-text bg-surface-2" : "text-text-muted hover:text-text hover:bg-surface-2"
    aria   = active ? { "aria-current": "page" } : {}

    link_to label, path, **opts.merge(class: "#{base} #{state}", **aria)
  end

  def back_path(fallback = root_path)
    request.referer.presence || fallback
  end

  private

  def current_path_matches?(path)
    return request.path == "/" if path == "/"

    request.path == path || request.path.start_with?("#{path}/")
  end
end
