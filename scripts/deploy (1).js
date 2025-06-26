const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying contract with address:", deployer.address);

  const initialCandidates = ["Alice", "Bob", "Charlie"]; // Modify as needed

  const DecentralizedVoting = await hre.ethers.getContractFactory("DecentralizedVoting");
  const contract = await DecentralizedVoting.deploy(initialCandidates);
  await contract.deployed();

  console.log("DecentralizedVoting deployed to:", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
