const menuTabs = document.getElementsByClassName("menuItem");

function changeTab() {
  const activeTab = document.getElementsByClassName("active")[0];
  if (!this.classList.contains("active")) {
    this.classList.toggle("active");
    activeTab.classList.remove("active");
  }
}

for (let i = 0; i < menuTabs.length; i++) {
  menuTabs[i].addEventListener("click", changeTab);
}

const playerOverlay = document.getElementById("playerOverlay");
document.getElementById("closePlayerOverlay").addEventListener("click", (e) => {
  playerOverlay.style.display = "none";
});

const tableBody = document.getElementById("playersTableBody");

tableBody.addEventListener("click", (e) => {
  const targetElement = e.target;
  if (targetElement.parentElement.classList.contains("table-entry")) {
    playerOverlay.style.display = "block";
  }
});
