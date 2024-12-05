import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="drop-down"
export default class extends Controller {
  static targets = ["dropdownContent"]
  static values = { open: Boolean }
  static classes = ["opened"]

  connect() {
    if (this.openValue) {
      this.openDropdown()
    } else {
      this.closeDropdown()
    }
  }

  toggleDropdown() {
    if (this.dropdownContentTarget.hidden === true) {
      this.openDropdown()
    } else {
      this.closeDropdown()
    }
  }

  openDropdown() {
    this.dropdownContentTarget.hidden = false
  }

  closeDropdown() {
    this.dropdownContentTarget.hidden = true
  }
}
