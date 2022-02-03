const { ethers } = require("hardhat");

async function main() {

  const SuperMarioWorld = await ethers.getContractFactory("SuperMarioWorld");
  const superMarioWorld = await SuperMarioWorld.deploy("SuperMarioWorld", "SPRM");

  await superMarioWorld.deployed();

  console.log("Succes! Contract was deployed to:", superMarioWorld.address);

  await superMarioWorld.mint("https://ipfs.io/ipfs/QmQSg66NYGXhP12tnFcaSm8Gr7h93eZyyz1Mo27MCVvVso");
  
  console.log("NFT successfully minted");
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
