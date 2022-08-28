import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  initialize() {}
  connect() {}
  toggleForm(event) {
    console.log("I click the button")
    event.preventDefault();
    event.stopPropagation();

    const formId = event.params["form"];
    const form = document.getElementById(formId);

    form.classList.toggle("hidden");
  }
}