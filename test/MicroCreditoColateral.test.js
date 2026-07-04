import { describe, it, beforeEach } from "node:test";
import assert from "node:assert";
import hre from "hardhat";

describe("MicroCreditoColateral tests", function () {
  let mockToken;
  let microCredito;
  let owner;
  let borrower;

  beforeEach(async function () {
    const connection = await hre.network.getOrCreate();
    const ethers = connection.ethers;

    [owner, borrower] = await ethers.getSigners();

    const MockERC20 = await ethers.getContractFactory("MockERC20");
    mockToken = await MockERC20.deploy();
    await mockToken.waitForDeployment();

    const MicroCredito = await ethers.getContractFactory("MicroCreditoColateral");
    microCredito = await MicroCredito.deploy(await mockToken.getAddress());
    await microCredito.waitForDeployment();

    // Fondear el contrato de préstamo
    const fundAmount = ethers.parseEther("10000");
    await mockToken.transfer(await microCredito.getAddress(), fundAmount);
  });

  it("Deberia permitir depositar colateral y tomar un prestamo", async function () {
    const connection = await hre.network.getOrCreate();
    const ethers = connection.ethers;

    const montoCredito = ethers.parseEther("100");
    const duracion = 3600; // 1 hora

    // Borrower deposita colateral y toma prestado
    const tx = await microCredito.connect(borrower).depositarColateralYTomarCredito(montoCredito, duracion, {
      value: ethers.parseEther("1"),
    });
    await tx.wait();

    const estado = await microCredito.estadoPrestamo();
    assert.strictEqual(Number(estado), 1); // 1 = ACTIVO

    const balanceBorrower = await mockToken.balanceOf(borrower.address);
    assert.strictEqual(balanceBorrower.toString(), montoCredito.toString());
  });

  it("Deberia permitir pagar el prestamo y recuperar el colateral", async function () {
    const connection = await hre.network.getOrCreate();
    const ethers = connection.ethers;

    const montoCredito = ethers.parseEther("100");
    const duracion = 3600; // 1 hora

    // Borrower deposita colateral y toma prestado
    let tx = await microCredito.connect(borrower).depositarColateralYTomarCredito(montoCredito, duracion, {
      value: ethers.parseEther("1"),
    });
    await tx.wait();

    // Aprobar los tokens para devolverlos
    tx = await mockToken.connect(borrower).approve(await microCredito.getAddress(), montoCredito);
    await tx.wait();

    // Pagar prestamo
    tx = await microCredito.connect(borrower).pagarPrestamo();
    await tx.wait();

    const estado = await microCredito.estadoPrestamo();
    assert.strictEqual(Number(estado), 0); // 0 = INACTIVO (se resetea tras pagar)
  });
});
