const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Counter", (m) => {
  const Counter = m.contract("Counter");

  let count = m.call(Counter, "getCount", []);
  
  console.log("Count before increment:")
  console.log(count.value);

  return { Counter };
});