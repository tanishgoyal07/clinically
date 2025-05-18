document.getElementById("imageInput").addEventListener("change", function () {
    const file = this.files[0];
    const previewContainer = document.getElementById("previewContainer");
    const previewImage = document.getElementById("previewImage");

    if (file) {
        const reader = new FileReader();
        reader.onload = function (e) {
            previewImage.src = e.target.result;
            previewContainer.style.display = "block";
        };
        reader.readAsDataURL(file);
    } else {
        previewContainer.style.display = "none";
    }
});

document.getElementById("uploadForm").addEventListener("submit", function (event) {
    event.preventDefault();

    const formData = new FormData(this);
    const resultContainer = document.getElementById("resultContainer");
    const poseName = document.getElementById("poseName");
    const confidenceValue = document.getElementById("confidenceValue");
    const isCorrect = document.getElementById("isCorrect");

    resultContainer.style.display = "none";

    fetch("/upload", {
        method: "POST",
        body: formData,
    })
        .then((response) => response.json())
        .then((data) => {
            if (data.error) {
                alert(data.error);
            } else {
                poseName.innerText = `${data.predicted_pose}`;
                confidenceValue.innerText = `${(data.confidence * 100).toFixed(2)}`;
                resultContainer.style.display = "block";
            }
        })
        .catch((error) => {
            console.error("Error:", error);
        });
});
