import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  switch(event) {
    const locale = event.params.locale
    if (!locale) return

    const url = new URL(window.location.href)
    url.searchParams.set("locale", locale)
    window.location.assign(url.toString())
  }

  connect() {
    const url = new URL(window.location.href)
    if (url.searchParams.has("locale")) {
      url.searchParams.delete("locale")
      window.history.replaceState({}, "", url.toString())
    }
  }
}
