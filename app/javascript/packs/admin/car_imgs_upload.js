document.addEventListener("turbolinks:load", function() {
  const fileInput = document.getElementById("image_input");
  const fileList = document.getElementById("file-list");

  fileInput.addEventListener("change", function() {
    fileList.innerHTML = "";

    if (fileInput.files.length > 0) {
      let fileNames = [];
      for (let i = 0; i < fileInput.files.length; i++) {
        fileNames.push(fileInput.files[i].name);
      }
      fileList.textContent = fileNames.join(", ");
    } else {
      fileList.innerHTML = "<p>No se seleccionaron archivos.</p>";
    }
  });
});
