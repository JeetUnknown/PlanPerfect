window.onload= function(){
    document.getElementById('delete').addEventListener('click', function(){
        if (confirm("Are you sure you want to delete this?")) {
            document.getElementById('form_delete').submit();
        }
    });

    document.getElementById('button_submit').style.opacity=0.5;
    const field= document.getElementsByClassName('track');
    for (i=0; i<field.length; i++) {
        field[i].addEventListener('input', function(){
            document.getElementById('button_submit').disabled= false;
            document.getElementById('button_submit').style.opacity= 1;
        });
    }
}