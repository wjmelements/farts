# BlockFarts
A transaction using more than half the block gas makes FARTS.

### Basic FARTS
If you release enough gas, you get FARTS.
```
function mintWithCall(address target, bytes calldata data) external;
```
You can still try to fart if you think it might be close and wouldn't want to revert.
```
function tryMintWithCall(address target, bytes calldata data) external;
```

### Turn your gas tokens into FARTS
Transactions clearing gas tokens from the state can claim FARTS using only 20% of the block gas.
```
function mintWithGasToken(IGasToken gasToken, uint256 burn) external;
```
Supported: GST1, GST2, CHI

### MultiFARTS
Batch FARTS best FARTS.
```
function mintWithMulticall(address[] calldata targets, bytes[] calldata datas, uint256[] calldata values) external payable;
function tryMintWithMulticall(address[] calldata targets, bytes[] calldata datas, uint256[] calldata values) external payable;
```

### Flash FARTS
Your FARTS are ready before your call, so you can use them within the transaction that creates them.

### Security
Don't leave any assets in this contract; they can be claimed by anyone.
