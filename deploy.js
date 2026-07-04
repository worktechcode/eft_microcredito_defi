import hre from "hardhat";

async function main() {
  console.log("Iniciando despliegue de contratos...");

  // Conexiones Explícitas a Redes en Hardhat 3
  const connection = await hre.network.getOrCreate();
  const ethers = connection.ethers;

  // 1. Obtener las cuentas del entorno
  const [deployer, borrower] = await ethers.getSigners();
  console.log(`Desplegando contratos con la cuenta de Administrador: ${deployer.address}`);

  // 2. Desplegar el contrato MockERC20
  const MockERC20 = await ethers.getContractFactory("MockERC20");
  const mockToken = await MockERC20.deploy();
  await mockToken.waitForDeployment();
  const tokenAddress = await mockToken.getAddress();
  console.log(`MockERC20 desplegado exitosamente en: ${tokenAddress}`);

  // 3. Desplegar el contrato MicroCreditoColateral pasándole la dirección del Token
  const MicroCredito = await ethers.getContractFactory("MicroCreditoColateral");
  const microCredito = await MicroCredito.deploy(tokenAddress);
  await microCredito.waitForDeployment();
  const contractAddress = await microCredito.getAddress();
  console.log(`MicroCreditoColateral desplegado exitosamente en: ${contractAddress}`);

  // 4. Fondear el pool del contrato de microcrédito con Tokens ERC20 para que pueda prestar
  const fundAmount = ethers.parseEther("500000"); // 500k tokens
  const tx = await mockToken.transfer(contractAddress, fundAmount);
  await tx.wait();
  console.log(`Fondeo del pool completado con: ${ethers.formatEther(fundAmount)} TCRED`);

  console.log("\n--- Resumen de Despliegue ---");
  console.log(`Owner/Lender: ${deployer.address}`);
  console.log(`Token ERC20: ${tokenAddress}`);
  console.log(`MicroCredito Contract: ${contractAddress}`);
  console.log("-----------------------------\n");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
