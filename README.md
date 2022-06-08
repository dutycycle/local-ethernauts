# local-ethernauts

This repo is fork of https://github.com/0xMacro/local-ethernauts, which is in turn based on the challenges here https://ethernaut.openzeppelin.com/.

## Solution Notes

1. **CoinFlip**: CoinFlip's random selection logic is based on block number. If we call the victim from the attacking contract, the call to the attacker and the victim will execute in the same block number. So, we just need to duplicate the victim's random selection logic in the attacking contract, and we can deterministically guess the selected value.

2. **Delegation**: We want to call the `pwn()` function on the Delegate contract to gain ownership. The victim contract will forward our calls to Delegate. We can't call Delegate.pwn() directly, but we can use ABI encoding to set up the call which will be forwarded.

3. **Force**: Even though the victim contract isn't directly payable, we can transfer funds to the victim by first funding the attacking contract and then self-destructing it.

4. **Vault**: All state variables, including private ones, are stored in 32-bit slots in contract storage. By looking at the order and size of variable declaration in the victim contract, we can deduce which slot will store the variable, and then we can use `ethers` to access the storage directly and read the value of the private variable.

5. **King**: First, the attacking contract makes itself king. When the victim tries to become king, the contract will try to pay out to the attacking contract before crowning the victim as king. By forcibly reverting the transaction in the attacking contract's default payable function, the change of king will always fail, and the attacker remains king.

6. **Reentrance**: First, the attacker makes a legitimate deposit in the victim contract. When the attacker withdraws, the victim contract will transfer funds and then decrement the attacker's balance. However, we insert a loop into the attacker's payable function will which in turn initiate more withdrawls. Since the victim doesn't decrement balance until the first withdrawl completes, the attacker's looped withdrawls will all process successfully until the victim is completely drained of funds.

7. **Denial**: When a withdrawl is initiated, the victim first transfers funds to the attacker and then to the owner. If the attacker contract reverts the transaction, the victim contract will ignore the error and continue with the transfer to the owner, which is intended to the prevent the attacker from disrupting the owner's withdrawl. However, the attacker can run an infinite loop in its default payable function to drain the gas on the withdrawl call, so the owner's withdrawl never gets executed.