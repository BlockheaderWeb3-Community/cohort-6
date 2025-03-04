const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Counter Contract", function () {
    let Counter, counter, owner, addr1;

    beforeEach(async function () {
        [owner, addr1] = await ethers.getSigners();
        Counter = await ethers.getContractFactory("Counter");
        counter = await Counter.deploy();
        await counter.waitForDeployment();
    });

    it("should start with a count of 0", async function () {
        expect(await counter.getCount()).to.equal(0);
    });

    it("should increase count by one", async function () {
        await counter.increaseByOne();
        expect(await counter.getCount()).to.equal(1);
    });

    it("should increase count by a specified value", async function () {
        await counter.increaseByValue(10);
        expect(await counter.getCount()).to.equal(10);
    });

    it("should decrease count by one", async function () {
        await counter.increaseByOne();
        await counter.decreaseByOne();
        expect(await counter.getCount()).to.equal(0);
    });

    it("should decrease count by a specified value", async function () {
        await counter.increaseByValue(20);
        await counter.decreaseByValue(5);
        expect(await counter.getCount()).to.equal(15);
    });

    it("should not decrease count below zero", async function () {
        await expect(counter.decreaseByOne()).to.be.revertedWith("cannot decrease below 0");
    });

    it("should reset count to zero", async function () {
        await counter.increaseByValue(50);
        await counter.resetCount();
        expect(await counter.getCount()).to.equal(0);
    });
});