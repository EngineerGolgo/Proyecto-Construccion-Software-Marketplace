/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */


document.addEventListener("DOMContentLoaded", function () {
    const container = document.querySelector(".container");
    const btnSignUp = document.getElementById("btn-sign-up");
    const btnSignIn = document.getElementById("btn-sign-in");

    if (btnSignUp && btnSignIn && container) {
        btnSignUp.addEventListener("click", () => {
            container.classList.add("toggle");
        });

        btnSignIn.addEventListener("click", () => {
            container.classList.remove("toggle");
        });
    }
});