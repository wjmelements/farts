pragma solidity ^0.8.6;

interface IGasToken {
    function freeFrom(address, uint256) external returns (bool);
}

contract Farts /*is IERC20*/ {

    string public constant name = "BlockFarts"; // Attn Rappers: this rhymes with PopTarts
    string public constant symbol = "FARTS";
    IGasToken public constant GST1 = IGasToken(0x88d60255F917e3eb94eaE199d827DAd837fac4cB);
    IGasToken public constant GST2 = IGasToken(0x0000000000b3F879cb30FE243b4Dfee438691c04);
    IGasToken public constant CHI = IGasToken(0x0000000000004946c0e9F43F4Dee607b0eF1fA1c);
    uint8 public constant decimals = 12;
    uint256 private constant INFINITE = 0xe00000000000000000000000;

    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Toot(address who, uint256 value);

    function transfer(address to, uint256 value) external returns (bool) {
        unchecked {
            {
                uint256 fromBalance = balanceOf[msg.sender];
                require (fromBalance >= value);
                balanceOf[msg.sender] = fromBalance - value;
            }
            {
                balanceOf[to] += value;
            }
            emit Transfer(msg.sender, to, value);
        }
        return true;
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        unchecked {
            {
                uint256 fromBalance = balanceOf[from];
                require (fromBalance >= value);
                balanceOf[from] = fromBalance - value;
            }
            {
                uint256 fromAllowance = allowance[from][msg.sender];
                if (fromAllowance < INFINITE) {
                    require (fromAllowance >= value);
                    allowance[from][msg.sender] = fromAllowance - value;
                }
            }
            balanceOf[to] += value;
            emit Transfer(from, to, value);
        }
        return true;
    }

    function mintWithGasToken(IGasToken gasToken, uint256 burn) external {
        unchecked {
            uint256 gas = gasleft();
            require (gasToken == CHI || gasToken == GST2 || gasToken == GST1);
            gasToken.freeFrom(msg.sender, burn);
            if (gas - gasleft() > block.gaslimit >> 1) {
                burn *= 1000000000000;
                balanceOf[msg.sender] += burn;
                totalSupply += burn;
                emit Transfer(0x0000000000000000000000000000000000000000, msg.sender, burn);
            } else {
                emit Toot(msg.sender, burn);
            }
        }
    }
}
