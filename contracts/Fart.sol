pragma solidity ^0.8.6;

import "./IERC721.sol";

contract Fart /*is IERC721*/ {
    address public constant FARTS = address(0xeDD00C39005e8600b7000000A059A01D0900a363);
    event Transfer(address indexed from, address indexed to, uint256 indexed id);

    event Approval(address indexed owner, address indexed spender, uint256 indexed id);

    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    string public constant name = "BlockFart";
    string public constant symbol = "FART";

    function totalSupply() external view returns (uint256) {
        return block.number;
    }

    mapping (uint256 => address) public getApproved;
    function approve(address spender, uint256 id) external {
        address owner = ownerOf[id];

        require(msg.sender == owner || isApprovedForAll[owner][msg.sender]);

        getApproved[id] = spender;

        emit Approval(owner, spender, id);
    }

    mapping (address => mapping(address => bool)) public isApprovedForAll;
    function setApprovalForAll(address operator, bool approved) external {
        isApprovedForAll[msg.sender][operator] = approved;

        emit ApprovalForAll(msg.sender, operator, approved);
    }


    mapping (uint256 => address) public ownerOf;
    mapping (address => uint256) public balanceOf;
    function transferFrom(
        address from,
        address to,
        uint256 id
    ) public {
        require(from == ownerOf[id]);

        require(msg.sender == from || msg.sender == getApproved[id] || isApprovedForAll[from][msg.sender]);

        unchecked {
            balanceOf[from]--;
            balanceOf[to]++;
        }

        ownerOf[id] = to;

        delete getApproved[id];

        emit Transfer(from, to, id);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id
    ) public {
        transferFrom(from, to, id);

        require(
            to.code.length == 0 ||
                IERC721Receiver(to).onERC721Received(msg.sender, from, id, "") ==
                IERC721Receiver.onERC721Received.selector
        );
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        bytes memory data
    ) public {
        transferFrom(from, to, id);

        require(
            to.code.length == 0
            || IERC721Receiver(to).onERC721Received(msg.sender, from, id, data) == IERC721Receiver.onERC721Received.selector
        );
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == 0x01ffc9a7 || interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;
    }

    function mint(address to) external {
        require(msg.sender == FARTS);
        unchecked {
            balanceOf[to]++;
        }

        ownerOf[block.number] = to;

        emit Transfer(address(0), to, block.number);
    }
}

