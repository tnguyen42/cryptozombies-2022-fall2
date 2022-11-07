const { expect } = require("chai");
const { ethers } = require("hardhat");
require("chai").should();

describe("ZombieFactory", () => {
  let ZombieFactory;
  let zombieFactory;

  beforeEach(async () => {
    ZombieFactory = await ethers.getContractFactory("ZombieFactory");
    [user1, user2] = await ethers.getSigners();
    zombieFactory = await ZombieFactory.deploy();
  });

  it("should create a new zombie", async () => {
    const zombieCount = (await zombieFactory.getAllZombies()).length;
    expect(zombieCount).to.equal(0);

    await zombieFactory.createRandomZombie("Elon");
    const newZombieCount = (await zombieFactory.getAllZombies()).length;
    expect(newZombieCount).to.equal(1);
  });

  it("should not allow a player to create two zombies in a row", async () => {
    await zombieFactory.connect(user1).createRandomZombie("Jad");
    await zombieFactory
      .connect(user1)
      .createRandomZombie("Elon")
      .should.be.revertedWith("The player already has at least one zombie");
  });
});
