pragma solidity ^0.6.8;


import "./Farts.sol";


interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 {

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

    /**
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;
}

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

    Farts public constant token = Farts(0x88d60255F917e3eb94eaE199d827DAd837fac4cB); // TODO
    uint256 public constant INFINITE = 0xe00000000000000000000000;

    mapping(address => uint256) balanceOf;
    mapping(address => mapping(address => bool)) isApprovedForAll;
    King[] kings;

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
        require(from != 0x0000000000000000000000000000000000000000);
        require(to != 0x0000000000000000000000000000000000000000);
        King storage king = kings[tokenId];
        address owner = king.owner;
        require(from == owner);
        require(from == msg.sender || king.approved == msg.sender || isApprovedForAll[owner][msg.sender]);
        king.owner = to;
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
        emit Transfer(from, to, tokenId);
    }

    function becomeKing() external {
        uint96 balance = uint96(token.balanceOf(msg.sender));
        uint256 count = kings.length;
        if (count != 0) {
            King storage current = kings[count - 1];
            address king = current.king;
            require(king != msg.sender);
            require(current.balance < balance);
            require(token.balanceOf(king) < balance);
        }
        emit Transfer(0x0000000000000000000000000000000000000000, msg.sender, count);
        kings.push(King(
            balance,
            msg.sender,
            uint96(now),
            msg.sender,
            0x0000000000000000000000000000000000000000
        ));
        balanceOf[msg.sender] += 1;
    }

    function crown(address newKing) external {
        uint96 balance = uint96(token.balanceOf(newKing));
        uint256 count = kings.length;
        if (count != 0) {
            King storage current = kings[count - 1];
            address king = current.king;
            require(king != newKing);
            require(current.balance < balance);
            require(token.balanceOf(king) < balance);
        }
        emit Transfer(0x0000000000000000000000000000000000000000, newKing, count);
        kings.push(King(
            balance,
            newKing,
            uint96(now),
            newKing,
            0x0000000000000000000000000000000000000000
        ));
        balanceOf[newKing] += 1;
    }
}
