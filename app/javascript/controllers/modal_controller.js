import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="modal"
export default class extends Controller {
  show(event) {
    const dialogId = event.params.dialog; // Get dialog ID from params
    const dialog = document.getElementById(dialogId);

    if (!dialog) {
      console.error(`Dialog with ID "${dialogId}" not found.`);
      return;
    }

    const backdrop = document.createElement("div");
    backdrop.className = "fixed inset-0 bg-black bg-opacity-50 z-40";

    // Add the backdrop to the body
    document.body.appendChild(backdrop);

    // Show the dialog
    dialog.classList.remove("hidden");
    dialog.classList.add("flex");
    dialog.showModal();

    // Close the modal and remove backdrop on dialog close
    const closeModal = () => {
      dialog.classList.add("hidden");
      dialog.classList.remove("flex");
      backdrop.remove();
      dialog.close();
      dialog.removeEventListener("close", closeModal);
    };

    dialog.addEventListener("close", closeModal);
    backdrop.addEventListener("click", closeModal); // Close modal on backdrop click
  }
}
