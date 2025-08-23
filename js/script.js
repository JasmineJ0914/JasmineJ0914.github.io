const myWorkLink = document.getElementById('my-work-link');
if (myWorkLink) {
  myWorkLink.addEventListener('click', (event) => {
    const myWorkSection = document.getElementById('my-work-section');
    if (myWorkSection) {
      event.preventDefault();
      myWorkSection.scrollIntoView({ behavior: "smooth" });
    }
  });
}