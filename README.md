# TrabalhoFinalSmartContract
## Comandos
npm init  
npm install web3@0.20.0 solc@0.4.18  

node  
Web3 = require('web3')  
web3 = new Web3(new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545"))  
solc = require('solc')  
sourceCode =  fs.readFileSync('ExecutarMusica.sol').toString()  
compiledCode = solc.compile(sourceCode)  
contractABI = JSON.parse(compiledCode.contracts[':ExecutarMusica'].interface)  
executarMusicaContract = web3.eth.contract(contractABI)  
byteCode = compiledCode.contracts[':ExecutarMusica'].bytecode  
executarMusicaDeployed = executarMusicaContract.new({data:byteCode, from:web3.eth.accounts[0], gas:4700000})  
executarMusicaInstance =  executarMusicaContract.at(executarMusicaDeployed.address)  
executarMusicaDeployed.address  
