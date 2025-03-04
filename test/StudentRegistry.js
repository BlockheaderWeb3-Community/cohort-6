const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("StudentRegistry", function () {
    let StudentRegistry, studentRegistry, owner, addr1, addr2;

    beforeEach(async function () {
        [owner, addr1, addr2] = await ethers.getSigners();
        StudentRegistry = await ethers.getContractFactory("StudentRegistry");
        studentRegistry = await StudentRegistry.deploy();
    });

    it("should deploy with the correct owner", async function () {
        expect(await studentRegistry.owner()).to.equal(owner.address);
    });

    it("should allow a student to register", async function () {
        await studentRegistry.connect(addr1).registerNewStudent("Alice");
        const studentName = await studentRegistry.getStudentName(addr1.address);
        expect(studentName).to.equal("Alice");
    });

    it("should prevent duplicate registration", async function () {
        await studentRegistry.connect(addr1).registerNewStudent("Alice");
        await expect(
            studentRegistry.connect(addr1).registerNewStudent("Alice")
        ).to.be.revertedWith("Student already exists");
    });

    it("should allow marking attendance", async function () {
        await studentRegistry.connect(addr1).registerNewStudent("Alice");
        await studentRegistry.markAttendance(addr1.address, 1); // 1 = Present
        expect(await studentRegistry.getStudentAttendance(addr1.address)).to.equal(1);
    });

    it("should allow adding interests", async function () {
        await studentRegistry.connect(addr1).registerNewStudent("Alice");
        await studentRegistry.addInterest(addr1.address, "Blockchain");
        const interests = await studentRegistry.getStudentInterests(addr1.address);
        expect(interests).to.include("Blockchain");
    });

    it("should prevent duplicate interests", async function () {
        await studentRegistry.connect(addr1).registerNewStudent("Alice");
        await studentRegistry.addInterest(addr1.address, "Blockchain");
        await expect(
            studentRegistry.addInterest(addr1.address, "Blockchain")
        ).to.be.revertedWith("Duplicate interest");
    });

    it("should allow removing interests", async function () {
        await studentRegistry.connect(addr1).registerNewStudent("Alice");
        await studentRegistry.addInterest(addr1.address, "Blockchain");
        await studentRegistry.removeInterest(addr1.address, "Blockchain");
        const interests = await studentRegistry.getStudentInterests(addr1.address);
        expect(interests).to.not.include("Blockchain");
    });

    it("should allow owner to transfer ownership", async function () {
        await studentRegistry.transferOwnership(addr1.address);
        expect(await studentRegistry.owner()).to.equal(addr1.address);
    });

    it("should prevent non-owners from transferring ownership", async function () {
        await expect(
            studentRegistry.connect(addr1).transferOwnership(addr2.address)
        ).to.be.revertedWith("Only owner");
    });
});
