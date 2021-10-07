const axios = require('axios')
const fs = require('fs');


const contracts = [
    "bytesXOverString",
    "packStorageVarsBad",
    "packStorageVarsGood",
    "externalOverPublic",
    "sloadStorageVarsGood",
    "sloadStorageVarsBad"
];

const abiPATH = [
    "gasOptimizationTips.sol",
    "gasOptimizationTips.sol",
    "gasOptimizationTips.sol",
    "gasOptimizationTips.sol",
    "gasOptimizationTips.sol",
    "gasOptimizationTips.sol"

]

describe("HH Deployment", function () {
  it("Deploying contracts", async function () {
      for(var i = 0; i< contracts.length; i++){
          const contractName = contracts[i];
          const deployedContract = await deploy(contractName);

          //print contract name, address, gas cost
          console.log("Contract Name:    ", contracts[i]);
          console.log("Contract Address: ", deployedContract.address);
          console.log("Tx hash:          ", deployedContract.deployTransaction.hash);
          const amb_status = await migrateABI(abiPATH[i], contractName, deployedContract.address);
          console.log(amb_status ? "ABI migrated!" : "ABI error!");
          console.log("====================================================================");
          //print status
      }

      //const savedABIStatus = await migrateABI(contracts);
      //console.log(savedABIStatus ? : "ABI migrated!", "ABI error!");
  });
});

async function deploy(contractName){
    const contract = await ethers.getContractFactory(contractName);
    const deployedContract = await contract.deploy();

    return deployedContract;
}

async function migrateABI(abiPath, name, address){
    try{
          const abis = [];
          abis.push(await createABIInput(abiPath, name, address));
          await axios.post("http://127.0.0.1:8081/addABI", abis);
          return true;
    }catch(e){
        console.log("error! Please ensure the private block explorer server running!")
    }
}

async function createABIInput(abiPath, name, address){
        const filePath = `./artifacts/contracts/${abiPath}/${name}.json`;
        console.log(filePath);
        const abi = JSON.parse((await fs.promises.readFile(filePath, 'utf8'))).abi;
        return    {
                    address: address,
                    abi: {contractName: name, abi: abi}
                  };
}
