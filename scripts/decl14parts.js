
function divideParts(obj) {
	var ids = (obj.id).split(':');
	var last = ids[ids.length - 1];
	var idsSuff = last.split('_');
	var suff = idsSuff[1];
	var objIndex = idsSuff[2];
	var subjIndex = idsSuff[3];
//alert('suff = ' + idsSuff[1] + ' objIndex = ' + idsSuff[2] + ' subjIndex = ' + idsSuff[3]);	
	getTotal(suff, objIndex);
	
	//partDateChange(getTotal(suff, objIndex, String(index)), objIndex, suff, index);
}

function getTotal(suff, objIndex) {
	var tot = 0.000000;
	var commonDivider = 1;
	var	totArea = (obtainElementById('span', 'objArea_' + suff + '_' + objIndex)[0]).innerHTML;
	var	beginDate = obtainElementById('span', 'newBeginDate_' + suff + '_' + objIndex)[0].innerHTML.split(".");

	beginDate = new Date(beginDate[2], beginDate[1]-1, beginDate[0])
	
	var total = obtainElementById('input', 'total_' + suff + '_' + objIndex)[0];
	var partAreas = obtainElementById('input', 'partArea_' + suff + '_' + objIndex);
	var decFractions = obtainElementById('input', 'decFraction_' + suff + '_' + objIndex);
	var dividents = obtainElementById('input', 'divident_' + suff + '_' + objIndex);
	var dividers = obtainElementById('input', 'divider_' + suff + '_' + objIndex);
	
	var parentCheck = parentCheck = obtainElementById('input', 'parentCheck_' + suff + '_' + objIndex)[0];
	var closeChecks = null;
//alert('1');	
	if (objIndex != '') {
		closeChecks = obtainElementById('input', 'closed_' + suff + '_' + objIndex);
	}
//alert('2');	
	var arrDividers = new Array();
	var arrDividents = new Array();
	
	for (var i = 0; i < partAreas.length; i++){
		arrDividers[i] = 0;
		arrDividents[i] = 0;

		var partEndDate = null;
		partEndDate = obtainElementById('select', 'partEndDate_' + suff + '_' + objIndex + '_' + i)[0];
		partEndDate = partEndDate.options[partEndDate.selectedIndex].text.split(".");
		if (partEndDate.length == 3) partEndDate = new Date(partEndDate[2], partEndDate[1]-1, partEndDate[0]);
		else partEndDate = null;
		
		if (partEndDate == null || beginDate <= partEndDate) {
//alert(partAreas.length);			
//alert('out' + i + '|' + partAreas.length + '|' + partAreas[i].value);	//minava samo 1 pyt		
			if (partAreas[i].value != 0) { 
//alert('in');			
				var power = Math.max(getPower(totArea), getPower(partAreas[i].value));
				partAreas[i].value = roundPart(partAreas[i].value, 6);
				
				arrDividers[i] = parseInt(parseFloat(totArea) * Math.pow(10, power));
				arrDividents[i] = parseInt(parseFloat(partAreas[i].value) * Math.pow(10, power));
//alert(arrDividents[i] + '|' + arrDividers[i]);
				decFractions[i].value = 0;
				decFractions[i].disabled = true;
				dividents[i].value = 0;
				dividents[i].disabled = true;
				dividers[i].value = 0;
				dividers[i].disabled = true;
				
			} else {
				decFractions[i].disabled = !parentCheck.checked;
				dividents[i].disabled = !parentCheck.checked;
				dividers[i].disabled = !parentCheck.checked;
				if (closeChecks.length > 0){
					decFractions[i].disabled = decFractions[i].disabled || closeChecks[i].checked;
					dividents[i].disabled = dividents[i].disabled || closeChecks[i].checked;
					dividers[i].disabled = dividers[i].disabled || closeChecks[i].checked;
				}
				if (decFractions[i].value != 0) {
					decFractions[i].value = replaceComma(decFractions[i].value);
					
					//���������� �� ������������
					//decFractions[i].value = parseFloat(decFractions[i].value).toFixed(6);
					
					var precAarr = (decFractions[i].value).split('.');
					var power = 6;
					//if (precAarr.length > 1) power = precAarr[1].length;
									
					decFractions[i].value = roundPart (decFractions[i].value, 6);
					
					arrDividers[i] = parseInt(Math.pow(10, power));
					arrDividents[i] = parseInt(parseFloat(decFractions[i].value) * Math.pow(10, power));
					
					partAreas[i].value = 0;
					partAreas[i].disabled = true;
					dividents[i].value = 0;
					dividents[i].disabled = true;
					dividers[i].value = 0;
					dividers[i].disabled = true;
				} else {
					partAreas[i].disabled = !parentCheck.checked;
					dividents[i].disabled = !parentCheck.checked;
					dividers[i].disabled = !parentCheck.checked;
					if (closeChecks.length > 0){
						partAreas[i].disabled = partAreas[i].disabled || closeChecks[i].checked;
						dividents[i].disabled = dividents[i].disabled || closeChecks[i].checked;
						dividers[i].disabled = dividers[i].disabled || closeChecks[i].checked;
					}
					
					if (parseInt(dividers[i].value) != 0 && parseInt(dividents[i].value) != 0){
						arrDividers[i] = parseInt(dividers[i].value);
						arrDividents[i] = parseInt(dividents[i].value);
						
						partAreas[i].value = 0;
						partAreas[i].disabled = true;
						decFractions[i].value = 0;
						decFractions[i].disabled = true;
					} else {
						partAreas[i].disabled = !parentCheck.checked;
						decFractions[i].disabled = !parentCheck.checked;
					if (closeChecks.length > 0){
							partAreas[i].disabled = partAreas[i].disabled || closeChecks[i].checked;
							decFractions[i].disabled = decFractions[i].disabled || closeChecks[i].checked;
						}
					}
				}
			}
		}
	}
//alert('ready');
	var fractList = new Array();
	for (var i = 0; i < arrDividers.length; i++){
		fractList[i] = new Array(arrDividents[i], arrDividers[i]); 
	}
	
	var sumFraction = new Array(0, 1);
	
	if (fractList.length == 0) {
		sumFraction = new Array(0, 0);
	} else {
		if (fractList.length == 1) {
			sumFraction = fractList[0];
		} else {	
			if (fractList.length > 1){
				for (var k = 0; k < fractList.length; k++){
					var fr = fractList[k];
					if (fr[1] != 0) sumFraction = fractSum(sumFraction, fr);
				}
			}
		}
	}
	
	if (sumFraction[1] > 0) tot = (Math.round(1000000 * parseFloat(sumFraction[0]) / parseFloat(sumFraction[1])) / 1000000);
	total.value = parseFloat(tot).toFixed(6);
	
	if (total.value != 1) total.style.color = 'red';
	else total.style.color = 'black';

	return tot;
}

function fractSum(fract1, fract2){
	var nok = 0;
	var mn1 = 0;
	var mn2 = 0;
	
//	alert('fract1 = ' + fract1 + ', fract2 = ' + fract2);
	
	if (fract1[1] != 0 && fract2[1] != 0) {
		nok = lcm(fract1[1], fract2[1]);
		mn1 = nok / fract1[1];
		mn2 = nok / fract2[1];
	}
	
	var res = new Array((fract1[0] * mn1) + (fract2[0] * mn2), nok);
	
	var nod = gcd(res[0], res[1]);
	if (nod > 1) res = new Array(res[0] / nod, res[1] / nod);
	
	return res;
}

function lcm(a, b){
	var g = gcd(a, b);
	
	if (g == 0) return 0; 
	else return (a * b) / g;
}

function gcd(a, b){
	if (b == 0) return a;
	else return gcd(b, a % b);	
}

function partDateChange(tot, objIndx, suff, subjIndex){
//alert(tot + ' - ' + objIndx + ' - ' + suff + ' - ' + subjIndex);
	if (parseFloat(tot) > 0) {
		var landBegin = null;
		if (subjIndex == "") {
			landBegin = obtainElementById('input', null, 'parentBeginDate' + 'InputDate')[0];
		} else {
			landBegin = obtainElementById('input', objIndx, 'newBeginDate' + 'InputDate')[0];
		}
		
//alert(objIndx + ' - partBeginDate - ' + suff + ' - ' + subjIndex);
		var partLandBegin = obtainElementById('input', objIndx, 'partBeginDate' + suff + subjIndex)[0];
//alert('partLandBegin = ' + partLandBegin);		

//alert('landBegin.value = ' + landBegin.value);	
		//if (/*!partLandBegin.disabled && */partLandBegin.value == ""){
			partLandBegin.value = landBegin.value;
		//}
	}
}

function getPower(str) {
	var splStr = str.split('.');
	var man = splStr[splStr.length - 1];
	
	if (splStr.length==1) return 0;
	return man.length;
}

/*function partLandTotal(){
	getTotal('P', null, ''); 
	getTotal('E', null, '');
}

function partHomeObjTotal(imax, own, emp){
	//alert('imax = ' + imax + ' own = ' + own + ' emp = ' + emp);
	for (var i = 1; i <= imax; i++){
		for (var ow = 1; ow <= own; ow++){
			//alert(ow);
			partDateChange(getTotal('P', i.toString(), ow.toString()), i.toString(), 'P', ow.toString());
		}
		
		if (emp > 0) {
			for (var em = 1; em <= emp; em++){
				partDateChange(getTotal('E', i.toString(), em.toString()), i.toString(), 'E', em.toString());
			}
		}
	}
}*/

function replaceComma (str) {
	for (var i = 0; i < str.length; i++){
		if (str.charAt(i) == ',') str = str.substring(0, i) + '.' + str.substring(i + 1);
	}	
	return str;
}

function roundPart (str, prec) {
	var comaPos = str.indexOf('.');
	var mantissaLength = 0;
	
	if (comaPos > 0) {
		mantissaLength = str.length - comaPos - 1;
	}
	
	if (mantissaLength > prec) {
		str = Math.round(parseFloat(str) * 1000000) / 1000000;
		str = parseFloat(str).toFixed(6);
	}
	
	return str;
}

