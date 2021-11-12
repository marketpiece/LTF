
var counter = 1;
var intervalID;
    function updateProgress(i) {
    	if(counter == 99)
    		return;
        $('form:progressBar').component.setValue(counter++);
        
    }
    
    function startProgress(){
        counter=1;
        $('form:progressBar').component.enable();
        $('form:progressBar').component.setValue(1);
        intervalID = setInterval(updateProgress,100);
    }
