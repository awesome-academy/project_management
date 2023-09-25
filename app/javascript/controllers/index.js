// Import and register all your controllers from the importmap under controllers/*

import { application } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", application)

// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
import NestedRondoController from "./nested_rondo_controller"
application.register("nested-rondo", NestedRondoController)

import Select2Controller from "./select2_controller"
application.register("select2", Select2Controller)

import SelectStatusReleaseController from "./select_status_release_controller"
application.register("is_released_select", SelectStatusReleaseController)
