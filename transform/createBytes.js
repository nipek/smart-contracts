const ethers = require("ethers");

const createBytes = (args) => {
  const name = args[0];
  const bytes = ethers.utils.formatBytes32String(name);
  console.log(bytes);
};

createBytes(process.argv.slice(2));
