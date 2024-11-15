// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html";
import "./user_socket";
// Establish Phoenix Socket and LiveView configuration.
import { Socket, Presence } from "phoenix";
import { LiveSocket } from "phoenix_live_view";
import topbar from "../vendor/topbar";

let user = document.getElementById("user").innerText;

let socket = new Socket("/socket", {
  params: { user: user },
});

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
});

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" });
window.addEventListener("phx:page-loading-start", (_info) => topbar.show(300));
window.addEventListener("phx:page-loading-stop", (_info) => topbar.hide());

// connect if there are any LiveViews on the page

liveSocket.connect();
socket.connect();

let presences = {};

let formattedTS = (ts) => new Date(ts).toLocaleString();

let listBy = (user, { metas: metas }) => {
  return {
    user: user,
    onlineAt: formattedTS(metas[0].online_at),
  };
};

let userList = document.getElementById("userList");

let render = (presences) => {
  userList.innerHTML = Presence.list(presences, listBy)
    .map(
      (presence) => `
        <li>
          ${presence.user}
          <br>
          <small>online since ${presence.onlineAt}</small>
        </li>
      `
    )
    .join("");
};

let room = socket.channel("room:lobby");

room.join();

room.on("presence_state", (state) => {
  presences = Presence.syncState(presences, state);
  render(presences);
});

room.on("presence_diff", (diff) => {
  presences = Presence.syncDiff(presences, diff);
  render(presences);
});

let messageInput = document.getElementById("message");
messageInput.addEventListener("keypress", (e) => {
  if (e.key === "Enter" && messageInput.value != "") {
    room.push("message:new", messageInput.value);
    messageInput.value = "";
  }
});

let messageList = document.getElementById("messageList");
let renderMessage = (message) => {
  let element = document.createElement("li");
  element.innerHTML = `
    <b>${message.user}</b>
    <i>${formattedTS(message.timestamp)}</i>
    <p>${message.body}</p>
  `;
  messageList.appendChild(element);
  messageList.scrollTop = messageList.scrollHeight;
};

room.on("message:new", (message) => renderMessage(message));

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket;
