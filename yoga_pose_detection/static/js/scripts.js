document.getElementById("uploadForm").addEventListener("submit", function (event) {
    event.preventDefault();

    const formData = new FormData(this);
    const progressBarContainer = document.getElementById("progressBarContainer");
    const progressBar = document.getElementById("progressBar");
    const resultContainer = document.getElementById("resultContainer");

    progressBarContainer.style.display = "block";
    resultContainer.style.display = "none";

    const socket = io();

    socket.on("progress", (data) => {
        progressBar.style.width = `${data.progress}%`;
        progressBar.innerText = `${data.progress}%`;
    });

    fetch("/upload", {
        method: "POST",
        body: formData,
    })
        .then((response) => response.json())
        .then((data) => {
            if (data.error) {
                alert(data.error);
            } else {
                document.getElementById("poseName").innerText = data.predicted_pose;
                document.getElementById("confidenceValue").innerText = data.confidence;
                resultContainer.style.display = "block";
            }
        })
        .catch((error) => {
            console.error("Error:", error);
        });
});
