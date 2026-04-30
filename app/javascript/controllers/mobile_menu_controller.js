import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["trigger", "panel"]

  toggle() {
    const open = this.panelTarget.classList.toggle("hidden") === false
    this.triggerTarget.setAttribute("aria-expanded", open ? "true" : "false")
  }

  close() {
    this.panelTarget.classList.add("hidden")
    this.triggerTarget.setAttribute("aria-expanded", "false")
  }
}
