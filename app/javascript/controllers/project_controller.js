import { Controller } from "@hotwired/stimulus"
import { get } from '@rails/request.js'

export default class extends Controller {
  static targets = ["planSelect"]

  change(event) {
    let project_id = event.target.selectedOptions[0].value
    let target = this.planSelectTarget.id

    get(`/project_features/plans?target=${target}&project_id=${project_id}`, {
      responseKind: "turbo-stream"
    })
  }
}
