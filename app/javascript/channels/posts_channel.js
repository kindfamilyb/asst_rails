import consumer from "./consumer";

consumer.subscriptions.create("PostsChannel", {
  connected() {
    console.log("Connected to the Posts Channel");
  },

  disconnected() {
    console.log("Disconnected from the Posts Channel");
  },

  received(data) {
    console.log("Received data:", data); // 디버깅용 로그
    const postsContainer = document.getElementById("posts");
    const postElement = document.createElement("div");
    postElement.innerHTML = `<h3>${data.id}</h3><p>${data.name}</p>`;
    postsContainer.appendChild(postElement);
  },
});
