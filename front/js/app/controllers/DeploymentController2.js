window.addEventListener('load', function() {
  console.log('Start')
  doGetCompilers();
  console.log("DONE")
  addCompileEvent()
});

let optimize = 1
let compiledContract

function status(txt) {
  document.getElementById('status').innerHTML = txt
}

/**
* This populates all <SELECT> boxes with accounts
*/
function populateVersions(versions) {
  sel = document.getElementById('select_to_compile_version')
  sel.innerHTML = ''
  for (let i = 0; i < versions.length; i++) {
    let opt = document.createElement('option')
    opt.appendChild(document.createTextNode(versions[i]))
    opt.value = versions[i]
    sel.appendChild(opt)
  }
}

function getVersion() {
  return document.getElementById('select_to_compile_version').value
}

/**
* Set version default value
*/
function setVersion(version) {
  document.getElementById('select_to_compile_version').value = version
}

function loadSolcVersion() {
  status(`Loading Solc: ${getVersion()}`)
  BrowserSolc.loadVersion(getVersion(), function (c) {
    status('Solc loaded.')
    compiler = c
  })
}


/**
* Gets the list of compilers
*/
function doGetCompilers()  {
 BrowserSolc.getVersions(function(soljsonSources, soljsonReleases) {
   populateVersions(soljsonSources)
   setVersion(soljsonReleases['0.5.7'])
   loadSolcVersion()
 });
}


function addCompileEvent() {
  const compileBtn = document.getElementById('contract-compile')
  compileBtn.addEventListener('click', solcCompile)
}

function solcCompile() {
  if (!compiler) return alert('Please select a compiler version.')

  setCompileButtonState(true)
  status("Compiling contract...")
  compiledContract = compiler.compile(getSourceCode(), optimize)

  if (compiledContract) setCompileButtonState(false)

  console.log('Compiled Contract :: ==>', compiledContract)
  status("Compile Complete.")
}

function getSourceCode() {
  return document.getElementById("contract").value
}

function setCompileButtonState(state) {
  document.getElementById("contract-compile").disabled = state
}

/**
* Compile solidity code and get abi and bytecode from only sloc
*/
function doCompileSolidityContract()  {
   console.log(document.getElementById('select_to_compile_version'));
   var compilerVersion = document.getElementById('select_to_compile_version').value;
   // Clen output field
   document.getElementById('compiled_bytecode').value='';
   document.getElementById('compiled_abidefinition').value='';
   document.getElementById('layout').style.display = 'block';

   //console.log(source);
   window.BrowserSolc.loadVersion(compilerVersion, function(c) {
     var compiler = c;
     status('Solc Loaded')
     console.log('Solc Version Loaded: ' + compilerVersion);

     var source = document.getElementById('sourcecode').value;
     var result = compiler.compile(source, 1);

     if(result.errors && JSON.stringify(result.errors).match(/error/i)){

         console.log(result.errors);
         setData('compilation_result',result.errors,true);
     } else {
         var thisMap = _.sortBy(_.map(result.contracts, function(val,key) {
             return [key,val];
         }), function(val) {
             return -1*parseFloat(val[1].bytecode);
         });

         console.debug(thisMap);
         var abi = JSON.parse(thisMap[0][1].interface);
         var bytecode = '0x' + thisMap[0][1].bytecode;
         document.getElementById('compiled_bytecode').value=bytecode;
         document.getElementById('compiled_abidefinition').value=JSON.stringify(abi);
         document.getElementById('layout').style.display = 'none';
     }
 });
}


function showLoading(){}
