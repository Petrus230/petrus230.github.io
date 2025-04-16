
document.addEventListener("DOMContentLoaded", () => {
    const printButton = document.querySelector(".print-button");
    if (printButton) {
      printButton.addEventListener("click", async (e) => {
        e.preventDefault();
  
        // Ensure Font Awesome is loaded
        try {
          console.log("Aqui button")
          // await document.fonts.load('900 1em "Font Awesome 6 Free"');
        } catch (e) {
          console.warn("Font loading failed, printing anyway:", e);
        }
        window.print();
      });
    }
  });