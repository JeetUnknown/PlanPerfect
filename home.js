window.onload= function () {
    // if any of the upcoming event is clicked, fetch details of this using hidden form
    const action= document.getElementsByClassName('upcoming-event-title');
    for (let j=0; j< action.length; j++) {
        action[j].addEventListener('click', function() {
            let ip_id= document.getElementById('detail');
            ip_id.value= action[j].id;
            document.getElementById('form_detail').submit();
        });
    }

    // if any of the today event is clicked, fetch details of this using hidden form
    const action_today= document.getElementsByClassName('today-event-title');
    for (let j=0; j< action_today.length; j++) {
        action_today[j].addEventListener('click', function() {
            let ip_id= document.getElementById('detail');
            ip_id.value= action_today[j].id;
            document.getElementById('form_detail').submit();
        });
    }
    
    // if user click the logo(user-logo), will show login page
    let click_count=0;
    document.getElementsByClassName('user')[0].addEventListener('click',function(){ 
        if(click_count%2 ==0)
            document.getElementById('myDiv').style.display="block";
        else
            document.getElementById('myDiv').style.display="none";
        click_count++;
    });
    document.getElementById('container').addEventListener('click',function(){
        document.getElementById('myDiv').style.display="none";
        click_count=0;
    });

    // if user search something, the searched elements will be highlighted
    document.getElementById('search').addEventListener('click', function(){
        const ele= document.getElementById('search_ip').value;
        const title_list= document.getElementsByClassName('title_details');
        for (let i=0; i<title_list.length; i++ ){
            if(title_list[i].innerHTML.includes(`<strong>${ele}</strong>`)) {
                title_list[i].classList.add('title_details_search');
            }
        }
    });

    // if search field gets empty, unselect the highlighted items
    document.getElementById('search_ip').addEventListener('input', function () {
        if (this.value=== "") {
            const title_list= document.getElementsByClassName('title_details_search');
            while (title_list.length> 0) {
                title_list[0].classList.remove('title_details_search');
            }
        }
    });
}