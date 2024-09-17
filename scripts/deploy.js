const hre = require("hardhat");

async function main() {
  // Compile contracts before deployment
  await hre.run('compile');

  // Get the contract factory for the LoyaltyCoupon contract
  const LoyaltyCoupon = await hre.ethers.getContractFactory("LoyaltyCoupon");

  // Deploy the contract
  const loyaltyCoupon = await LoyaltyCoupon.deploy();

  // Wait for the contract deployment to be mined
  await loyaltyCoupon.waitForDeployment();

  // Log the contract address
  console.log("LoyaltyCoupon contract deployed to:", loyaltyCoupon.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
