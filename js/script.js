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

const tableBody = document.getElementById("playersTableBody") ?? null;

if (tableBody !== null) {
  tableBody.addEventListener("click", (e) => {
    const targetElement = e.target;
    if (targetElement.parentElement.classList.contains("table-entry")) {
      window.location.href = "./agencyPlayer.html";
    }
  });
}

const editPlayerBtn = document.getElementById("editPlayerBtn") ?? null;

if (editPlayerBtn !== null) {
  editPlayerBtn.addEventListener("click", () => {
    window.location.href = "./agencyPlayerForm.html";
  });
}
