function checkInputs(name, symbol, supply){
  console.log(name);
  console.log(symbol);
  console.log(supply);

  if(name == ''){
    alert("Token Name Field is missing");
  }
  else if(symbol == ''){
    alert("Token Symbol Field is missing");
  }
  else if(supply == undefined){
    alert("Token Supply Field is missing");
  }
  else{
    return true;
  }
}

function personalizeSmartContract(template, tName, tSymbol, tSupply) {
  return new Promise(function(resolve, reject) {
    fetch(template)
    .then(res => res.blob()) // Gets the response and returns it as a blob
    .then(blob => {
      var reader = new FileReader();
      reader.onload = function() {
        var contract = reader.result.replace(/tName/g, '\''+tName+'\'');
        contract = contract.replace(/tSymbol/g, '\''+tSymbol+'\'');
        contract = contract.replace(/tSupply/g, tSupply.toString());
        resolve(contract);
      }
      reader.readAsText(blob);
    });
  });
}

function generateSC(e) {
  if (e.preventDefault) e.preventDefault();

  var tName = document.getElementById("tokenName").value;
  var tSymbol = document.getElementById("tokenSymbol").value;
  var tSupply = document.getElementById("tokenSupply").value;

  //Personalize the SmartContract according to the inputs
  if (checkInputs(tName, tSymbol, tSupply)){
    var template = 'https://raw.githubusercontent.com/bastienchevallier/RealEstate-Tokenization/master/contracts/ProjectCrowdsale.sol';
    personalizeSmartContract(template, tName, tSymbol, tSupply)
    .then((contract)=> {
      //Redirect to summary before deployment
      console.log('=======')
      console.log(contract);
      console.log('=======')

      localStorage.setItem("sol:ProjectCrowdsale.sol", contract);
      window.location.href = "summary.html";
      return false;
    });
  }
}

var form = document.getElementById('token-form');
if (form.attachEvent) {
    form.attachEvent("submit", generateSC);
} else {
    form.addEventListener("submit", generateSC);
}
