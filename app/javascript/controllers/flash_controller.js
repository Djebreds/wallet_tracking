import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = ['closeFlash']

  connect() {
    if (this.closeFlashTarget) {
      this.autoCloseFlash();
    }
  }

  autoCloseFlash() {
    setTimeout(() => {
      this.closeFlashTarget.classList.add("hidden");
    }, 5000)
  }

  toggle() {
    this.closeFlashTarget.classList.toggle("hidden");
  }
}
