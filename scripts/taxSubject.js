
function compileName() {
	var name = obtainElementById('input', null, 'name')[0];
	var sirName = obtainElementById('input', null, 'sirName')[0];
	var familyName = obtainElementById('input', null, 'familyName')[0];
	var taxSubjectName = obtainElementById('input', null, 'taxSubjectName')[0];
	
	name.value = name.value.replace("  ", " ");
	
	sirName.value = sirName.value.replace("  ", " ");
	
	familyName.value = familyName.value.replace("  ", " ");
	
	taxSubjectName.value = name.value + " " + sirName.value + " " + familyName.value;
	taxSubjectName.value = taxSubjectName.value.replace("  ", " ");
}