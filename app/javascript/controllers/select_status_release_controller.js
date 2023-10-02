import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="is_released_select"
export default class extends Controller {
  connect() {}

  change(e) {
    e.preventDefault();
    const releasedAtFieldElement = document.getElementById(
      "released_at-select_date-field"
    );
    const releaseCodeFieldElement = document.getElementById(
      "release_code-text_field"
    );
    if (e.target.value == "released") {
      releasedAtFieldElement.hidden = false;
      releaseCodeFieldElement.hidden = false;
    }
    else {
      releasedAtFieldElement.hidden = true;
      releaseCodeFieldElement.hidden = true;
    }
  }
}
