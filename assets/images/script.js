document.addEventListener('DOMContentLoaded', function () {

    document.getElementById('appointmentForm').addEventListener('submit', function (event) {
        event.preventDefault();

        const name = document.getElementById('name').value;
        const date = document.getElementById('date').value;
        const time = document.getElementById('time').value;

        const message = `Hola, soy ${name}. Me gustaría agendar una cita para el ${date} a las ${time}.`;
        const whatsappUrl = `https://wa.me/5545357150?text=${encodeURIComponent(message)}`;

        window.location.href = whatsappUrl;
    });

    window.addEventListener('scroll', function () {
        var scrollPosition = window.scrollY;

        var navLinks = document.querySelectorAll('header nav ul li a');

        navLinks.forEach(function (link) {
            var sectionId = link.getAttribute('href').substring(1);
            var section = document.getElementById(sectionId);

            if (
                section.offsetTop <= scrollPosition + 150 &&
                section.offsetTop + section.offsetHeight > scrollPosition + 150
            ) {
                link.classList.add('active');
            } else {
                link.classList.remove('active');
            }
        });
    });

    var modal = document.getElementById("myModal");

    var img = document.querySelectorAll('.services-gallery img');
    var modalImg = document.getElementById("img01");

    img.forEach(function (image) {
        image.onclick = function () {
            modal.style.display = "block";
            modalImg.src = this.src;
        }
    });

    var span = document.getElementsByClassName("close")[0];

    span.onclick = function () {
        modal.style.display = "none";
    }

    modal.onclick = function (event) {
        if (event.target === modal) {
            modal.style.display = "none";
        }
    }
});

const track = document.querySelector('.carousel-track');
const prevBtn = document.querySelector('.carousel-btn.prev');
const nextBtn = document.querySelector('.carousel-btn.next');
let index = 0;
const items = document.querySelectorAll('.carousel-item');

function showSlide(i) {
    index = (i + items.length) % items.length;
    track.style.transform = `translateX(${-index * 100}%)`;
}

prevBtn.addEventListener('click', () => showSlide(index - 1));
nextBtn.addEventListener('click', () => showSlide(index + 1));

