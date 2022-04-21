let loginbtn = document.getElementById("login");
let signupbtn = document.getElementById("signup");
let btn = document.getElementById("btn");
let infoId = document.getElementsByClassName('info');
let url = `https://newsapi.org/v2/top-headlines?country=za&category=sports&apiKey=0cf93819ab9847288d34d9ad380f2fb8`;

function signup(){
    loginbtn.style.left = "-400px";
    signupbtn.style.left = "50px";
    btn.style.left = "110px";
} 

function login(){
    loginbtn.style.left = "50px";
    signupbtn.style.left = "450px";
    btn.style.left = "0px";
}

$.get(url, (response)=>{
    for(i=0;i<3;i++){
        let html = `<article id="news"> 
        <P><h3 class="title">${response.articles[i].title}</h3><img src="${response.articles[i].urlToImage}" class="" alt="">${response.articles[i].content} | ${response.articles[i].source.name} | ${response.articles[i].author}</P> 
        <p class="timeDate"><small class="text">${response.articles[i].publishedAt}</small></p>
        <button><a href="${response.articles[i].url}" target="_blank" class="more-btn">Read More</a></button>
    </article>`; 

    $(infoId).append(html);
    }

}); 