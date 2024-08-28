const image = document.querySelector(".image .image-2");
const slider = document.querySelector(".slider input");
const drag = document.querySelector(".slider .dragLine");

slider.oninput = () =>{
    let sliderVal = slider.value;
    drag.style.left = sliderVal + "%";
    image.style.width = sliderVal + "%";
}