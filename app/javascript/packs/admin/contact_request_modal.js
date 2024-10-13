document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll("[data-modal-id]").forEach(button => {
    button.addEventListener("click", function() {
      const modalId = this.getAttribute("data-modal-id");
      const modal = document.getElementById(modalId);
      if (modal) {
        modal.classList.remove("hidden");
      }
    });
  });

  document.querySelectorAll(".close-modal").forEach(button => {
    button.addEventListener("click", function() {
      const modalId = this.getAttribute("data-modal-id");
      const modal = document.getElementById(modalId);
      if (modal) {
        modal.classList.add("hidden");
      }
    });
  });
});
