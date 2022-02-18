pragma solidity ^0.8.6;


import "./Farts.sol";
import "./IERC721.sol";


contract KingOfTheFarts /*is IERC721*/ {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
    struct King {
        uint96 balance;
        address king;
        uint96 timestamp;
        address owner;
        address approved;
    }

    Farts public constant FARTS = Farts(0xeDD00C39005e8600b7000000A059A01D0900a363);

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => bool)) public isApprovedForAll;
    King[] public kings;

    function totalSupply() external view returns (uint256) {
        return kings.length;
    }
    function ownerOf(uint256 tokenId) external view returns (address owner) {
        owner = kings[tokenId].owner;
    }

    function approve(address to, uint256 tokenId) external {
        King storage king = kings[tokenId];
        require(king.owner == msg.sender);
        king.approved = to;
    }

    function getApproved(uint256 tokenId) external view returns (address operator) {
        operator = kings[tokenId].approved;
    }

    function setApprovalForAll(address operator, bool _approved) external {
        isApprovedForAll[msg.sender][operator] = _approved;
    }


    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        King storage king = kings[tokenId];
        address owner = king.owner;
        require(from == owner);
        require(from == msg.sender || king.approved == msg.sender || isApprovedForAll[owner][msg.sender]);
        king.owner = to;
        king.approved = 0x0000000000000000000000000000000000000000;
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external {
        require(from != 0x0000000000000000000000000000000000000000);
        require(to != 0x0000000000000000000000000000000000000000);
        King storage king = kings[tokenId];
        address owner = king.owner;
        require(from == owner);
        require(from == msg.sender || king.approved == msg.sender || isApprovedForAll[owner][msg.sender]);
        require(IERC721Receiver(to).onERC721Received(
            msg.sender,
            from,
            tokenId,
            ""
        ) == IERC721Receiver.onERC721Received.selector);
        king.owner = to;
        king.approved = 0x0000000000000000000000000000000000000000;
        emit Transfer(from, to, tokenId);
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external {
        require(from != 0x0000000000000000000000000000000000000000);
        require(to != 0x0000000000000000000000000000000000000000);
        King storage king = kings[tokenId];
        address owner = king.owner;
        require(from == owner);
        require(from == msg.sender || king.approved == msg.sender || isApprovedForAll[owner][msg.sender]);
        require(IERC721Receiver(to).onERC721Received(
            msg.sender,
            from,
            tokenId,
            data
        ) == IERC721Receiver.onERC721Received.selector);
        king.owner = to;
        king.approved = 0x0000000000000000000000000000000000000000;
        emit Transfer(from, to, tokenId);
    }

    function becomeKing() external {
        require(tx.origin == msg.sender);
        uint96 balance = uint96(FARTS.balanceOf(msg.sender));
        uint256 count = kings.length;
        if (count != 0) {
            King storage current = kings[count - 1];
            address king = current.king;
            require(king != msg.sender);
            require(current.balance < balance);
            require(FARTS.balanceOf(king) < balance);
        }
        emit Transfer(0x0000000000000000000000000000000000000000, msg.sender, count);
        kings.push(King(
            balance,
            msg.sender,
            uint96(block.timestamp),
            msg.sender,
            0x0000000000000000000000000000000000000000
        ));
        unchecked {
            balanceOf[msg.sender] += 1;
        }
    }

    function crown(address newKing) external {
        require(tx.origin == msg.sender);
        uint96 balance = uint96(FARTS.balanceOf(newKing));
        uint256 count = kings.length;
        if (count != 0) {
            King storage current = kings[count - 1];
            address king = current.king;
            require(king != newKing);
            require(current.balance < balance);
            require(FARTS.balanceOf(king) < balance);
        }
        emit Transfer(0x0000000000000000000000000000000000000000, newKing, count);
        kings.push(King(
            balance,
            newKing,
            uint96(block.timestamp),
            newKing,
            0x0000000000000000000000000000000000000000
        ));
        unchecked {
            balanceOf[msg.sender] += 1;
        }
    }

    function supportsInterface(bytes4 interfaceId) external pure returns (bool) {
        return interfaceId == 0x01ffc9a7 || interfaceId == 0x80ac58cd || interfaceId == 0x5b5e139f;
    }
}
