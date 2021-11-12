function setInputSelect() {
	var objs = new Array();
	var objects = document.getElementsByTagName('input');
	for ( var i = 0; i < objects.length; i++) {
		var obj = objects[i];
		if (obj.type == 'text'){
			obj.onfocus = function () { this.select(); };
		}
	}
}