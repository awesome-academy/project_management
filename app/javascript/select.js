$(document).ready(() => {
  $("#select_project").on("change", (e) => {
    const value = $("#select_project").val();
    const data = {
      project_id: value,
    };
    window.location.href = `/resources/new?project_id=${value}`;
  });
});
