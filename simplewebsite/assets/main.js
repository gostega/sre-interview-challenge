// DOM Elements
const time = document.getElementById("time"),
  greeting = document.getElementById("greeting"),
  sourcecode = document.getElementById("sourcecode");

// Set Background and Greeting
function loadPage() {
  let today = new Date(),
    hour = today.getHours();

  if (hour < 12) {
    // Morning
    document.body.style.backgroundImage =
      "url('./assets/perth-koondoola-morning.jpg')";
    greeting.textContent = "Good Morning";
    document.body.style.color = "white";
  } else if (hour < 18) {
    // Afternoon
    document.body.style.backgroundImage =
      "url('./assets/perth-scarborough-afternoon.jpg')";
    greeting.textContent = "Good Afternoon";
    document.body.style.color = "white";
  } else {
    // Evening
    document.body.style.backgroundImage =
      "url('./assets/perth-koondoola-evening.jpg')";
    greeting.textContent = "Good Evening";
    document.body.style.color = "white";
  }
}

// Run
loadPage();
