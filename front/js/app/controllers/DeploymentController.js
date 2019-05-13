/*
    baseUrl: 'js/lib',
    paths: {
      'nodeRequire': 'require',
      'solc': 'browser-solc.min',
      'fs': 'browserfs.min'
    }
});
*/
const __dirname = 'http://127.0.0.1:8080/contracts/';
//const fs = requirejs(['fs']);
//const solc = requirejs(['solc']);
//const Tx = require('ethereumjs-tx');

//HEROKU
//var DelayedResponse = require('http-delayed-response');

// %% BUILDING SMARTCONTRACT %% //
// Input parameters for solc
// Refer to https://solidity.readthedocs.io/en/develop/using-the-compiler.html#compiler-input-and-output-json-description
var solcInput = {
    language: "Solidity",
    sources: { },
    settings: {
        optimizer: {
            enabled: true
        },
        evmVersion: "byzantium",
        outputSelection: {
            "*": {
              "": [
                "legacyAST",
                "ast"
              ],
              "*": [
                "abi",
                "evm.bytecode.object",
                "evm.bytecode.sourceMap",
                "evm.deployedBytecode.object",
                "evm.deployedBytecode.sourceMap",
                "evm.gasEstimates"
              ]
            },
        }
    }
};

// %% DEPLOYING SMARTCONTRACT %% //
/*
let accounts = [
    {
        // Develop
        address: process.env.PUBLIC_KEY,
        key: process.env.PRIVATE_KEY
    },
];
*/

let selectedHost = 'https://ropsten.infura.io/v3/eac8fbafbf314d08b80b7557834dd50d';

let selectedAccountIndex = 0; // Using the first account in the list

window.addEventListener('load', () => {
    // Checking if Web3 has been injected by the browser (Mist/MetaMask)
    if (typeof web3 !== 'undefined') {
        // Use Mist/MetaMask's provider
        console.log('MetaMask s provider')
        web3 = new Web3(web3.currentProvider);
    } else {
        console.log('No web3? You should consider trying MetaMask!');
        // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
        web3 = new Web3(new Web3.providers.HttpProvider(selectedHost));
    }
    console.log(web3.eth.accounts[0])
    //TODO : set gasPrice automatically
    let gasPrice = 41e9;
    let gasPriceHex = web3.toHex(gasPrice);
    let gasLimitHex = web3.toHex(6000000);

    var form = document.getElementById('network-form');
    if (form.attachEvent) {
        form.attachEvent("submit", deploy);
    } else {
        form.addEventListener("submit", deploy);
    }
});

// Try to lookup imported sol files in "contracts" folder or "node_modules" folder
function findImports(importFile) {
    console.log("Import File:" + importFile);
    try {
        // Find in contracts folder first
        //var result = fs.readFileSync(__dirname + importFile, 'utf8');
        var result = localStorage.getItem('sol:' + importFile);
        return { contents: result };
    } catch (error) {
        return { error: 'File not found' };
    }
}

function saveContract(name, data) {
  localStorage.setItem('sol:'+name, data);
  /*
  fs.writeFile(__dirname + 'Output.sol', contract, (err) => {
    // In case of a error throw err.
    if (err) throw err;
  })
  */
}

// Compile the sol file in "contracts" folder and output the built json file to "build/contracts"
function buildContract(contractname) {
  return new Promise(function(resolve, reject) {
    let jsonOutputName = contractname + '.json';
    //let jsonOutputFile = __dirname + '/../build/contracts/' + jsonOutputName;
    console.log('sol:'+contractname + '.sol')
    var contract = localStorage.getItem('sol:'+contractname + '.sol')
    //Load a specific compiler version
    BrowserSolc.getVersions(function(soljsonSources, soljsonReleases) {
      BrowserSolc.loadVersion("soljson-v0.5.7+commit.6da8b019.js", function(compiler) {
        optimize = 1;
        result = compiler.compile(contract, optimize);
        result = JSON.stringify(result);
        console.log("===== RESULT ======")
        console.log(result)
        console.log("===== ====== ======")
        resolve(result);
      });
    });
  });
    /*
    solcInput.sources[contractname + '.sol'] = {
        "content": contract
    };

    let solcInputString = JSON.stringify(solcInput);
    let output = solc.compileStandardWrapper(solcInputString, findImports);

    let jsonOutput = JSON.parse(output);
    let isError = false;

    if (jsonOutput.errors) {
        jsonOutput.errors.forEach(error => {
            console.log(error.severity + ': ' + error.component + ': ' + error.formattedMessage);
            if (error.severity == 'error') {
                isError = true;
            }
        });
    }

    if (isError) {
        // Compilation errors
        console.log('Compile error!');
        return false;
    }

    // Update the sol file checksum
    //jsonOutput['contracts'][contract]['checksum'] = contractFileChecksum;

    let formattedJson = JSON.stringify(jsonOutput, null, 4);

    // Write the output JSON
    //fs.writeFileSync(jsonOutputFile, formattedJson);
    localStorage.setItem('json:'+jsonOutputName, formattedJson);
    console.log('==============================');
    */
}

function deployContract(smartcontract, callback) {
    // It will read the ABI & byte code contents from the JSON file in ./build/contracts/ folder
    let jsonOutputName = smartcontract + '.json';
    let jsonFile = __dirname + '/../../../build/contracts/' + jsonOutputName;

    // After the smart deployment, it will generate another simple json file for web frontend.
    let webJsonFile = __dirname + '/../../../www/assets/contracts/' + jsonOutputName;
    let result = false;

    /*
    try {
        result = fs.statSync(jsonFile);
    } catch (error) {
        console.log(error.message);
        return false;
    }*/

    // Read the JSON file contents
    //let contractJsonContent = fs.readFileSync(jsonFile, 'utf8');
    let contractJsonContent = localStorage.getItem('json:'+jsonOutputName);
    let jsonOutput = JSON.parse(contractJsonContent);
    // Retrieve the ABI
    let abi = jsonOutput['contracts'][smartcontract + '.sol'][smartcontract]['abi'];

    // Retrieve the byte code
    let bytecode = jsonOutput['contracts'][smartcontract + '.sol'][smartcontract]['evm']['bytecode']['object'];

    let tokenContract = new web3.eth.Contract(abi);

    // Prepare the smart contract deployment payload
    // If the smart contract constructor has mandatory parameters, you supply the input parameters like below
    //
    // contractData = tokenContract.new.getData( param1, param2, ..., {
    //    data: '0x' + bytecode
    // });
    //var contractData = tokenContract.new.getData({data: '0x' + bytecode});
    var contractData ='0x' + bytecode;
    // Prepare the raw transaction information
    let rawTx = {
        chainId: 3,
        gasPrice: gasPriceHex,
        gasLimit: gasLimitHex,
        data: contractData,
        from: accounts[selectedAccountIndex].address
    };

    // Get the account private key, need to use it to sign the transaction later.
    //let privateKey = new Buffer(accounts[selectedAccountIndex].key, 'hex')
    let privateKey = '0x' + accounts[selectedAccountIndex].key

    let tx = new Tx(rawTx);
    let treceipt = null;
    web3.eth.accounts.signTransaction(rawTx, privateKey)
    .then(RLPencodedTx => {
        web3.eth.sendSignedTransaction(RLPencodedTx['rawTransaction'])
            .on('receipt', (receipt) => {
              console.log("====== Receipt received ======");
              console.log("Contract Address:", receipt.contractAddress);
              console.log("Gas Used:", receipt.gasUsed);
              console.log("====== ================ ======");
              console.log(receipt);
              console.log("====== ================ ======");
              callback(receipt);
            });
    });
}

function deploy(e) {
  if (e.preventDefault) e.preventDefault();
  document.getElementById("confirmationbody").innerHTML = "Please wait until your contract is mined...";
  var network = document.getElementById("network").value;

  //In order to prevent Heroku request timeout
  //var delayed = new DelayedResponse(req, res);

  //Save contract.sol
  //saveContract(sessionStorage.getItem("sol:ProjectCrowdsale.sol"));
  //Build contract.json
  buildContract('ProjectCrowdsale')
  .then(compiledcontract =>{
    //Deploy contract
    deployContract('ProjectCrowdsale', function(receipt){
      sessionStorage.setItem("contract:address", receipt.contractAddress);
      sessionStorage.setItem("contract:gasUsed", receipt.gasUsed);
      sessionStorage.setItem("contract:txoHash", receipt.transactionHash);
    });
    return false;
  });
}
