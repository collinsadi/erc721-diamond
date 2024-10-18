pragma solidity ^0.8.0;

import {LibDiamond} from "../libraries/LibDiamond.sol";
import {IERC721ErrorsEvents} from "../interfaces/IERC721ErrorsEvents.sol";

/**
 * @dev Implementation of the {IERC721} interface.
 *
 * This implementation is for the Diamond pattern using facets.
 */
contract ERC721Facet is IERC721ErrorsEvents {

    /**
     * @dev Returns the name of the token collection.
     */
    function name() public view virtual returns (string memory) {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        return libStorage.name;
    }

    /**
     * @dev Returns the symbol of the token collection.
     */
    function symbol() public view virtual returns (string memory) {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        return libStorage.symbol;
    }

    /**
     * @dev Returns the owner of the `tokenId` token.
     */
    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        address owner = libStorage.owners[tokenId];
        if (owner == address(0)) {
            revert ERC721NonexistentToken(tokenId);
        }
        return owner;
    }

    /**
     * @dev Returns the number of tokens owned by `owner`.
     */
    function balanceOf(address owner) public view virtual returns (uint256) {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        require(owner != address(0), "ERC721: balance query for the zero address");
        return libStorage.balances[owner];
    }

    /**
     * @dev Approves `to` to transfer `tokenId` token on behalf of the owner.
     */
    function approve(address to, uint256 tokenId) public virtual {
        address owner = ownerOf(tokenId);
        require(to != owner, "ERC721: approval to current owner");

        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "ERC721: approve caller is not owner nor approved for all"
        );

        _approve(to, tokenId);
    }

    /**
     * @dev Returns the approved address for a specific `tokenId`.
     */
    function getApproved(uint256 tokenId) public view virtual returns (address) {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        return libStorage.tokenApprovals[tokenId];
    }

    /**
     * @dev Approves or removes `operator` as an operator for the caller.
     */
    function setApprovalForAll(address operator, bool approved) public virtual {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        libStorage.operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     */
    function isApprovedForAll(address owner, address operator) public view virtual returns (bool) {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        return libStorage.operatorApprovals[owner][operator];
    }

    /**
     * @dev Transfers `tokenId` from `from` to `to`.
     */
    function transferFrom(address from, address to, uint256 tokenId) public virtual {
        // Check if caller is owner, approved, or operator
        require(_isApprovedOrOwner(msg.sender, tokenId), "ERC721: transfer caller is not owner nor approved");

        _transfer(from, to, tokenId);
    }

    /**
     * @dev Internal function to transfer ownership of a `tokenId` from `from` to `to`.
     */
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();

        require(ownerOf(tokenId) == from, "ERC721: transfer of token that is not owned");
        require(to != address(0), "ERC721: transfer to the zero address");

        // Clear approvals from the previous owner
        _approve(address(0), tokenId);

        libStorage.balances[from] -= 1;
        libStorage.balances[to] += 1;
        libStorage.owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    /**
     * @dev Approves `to` to operate on `tokenId`.
     */
    function _approve(address to, uint256 tokenId) internal virtual {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        libStorage.tokenApprovals[tokenId] = to;
        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    /**
     * @dev Returns whether `spender` is allowed to manage `tokenId`.
     */
    function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    /**
     * @dev Creates a new `tokenId` and assigns it to `to`.
     */
    function mint(address to, uint256 tokenId) public {
        LibDiamond.enforceIsContractOwner();
        _mint(to, tokenId);
    }

    /**
     * @dev Internal function to mint a new token.
     */
    function _mint(address to, uint256 tokenId) internal virtual {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        require(to != address(0), "ERC721: mint to the zero address");
        require(libStorage.owners[tokenId] == address(0), "ERC721: token already minted");

        libStorage.balances[to] += 1;
        libStorage.owners[tokenId] = to;

        emit Transfer(address(0), to, tokenId);
    }

    /**
     * @dev Burns a specific `tokenId`.
     */
    function burn(uint256 tokenId) public {
        LibDiamond.enforceIsContractOwner();
        _burn(tokenId);
    }

    /**
     * @dev Internal function to burn a token.
     */
    function _burn(uint256 tokenId) internal virtual {
        LibDiamond.DiamondStorage storage libStorage = LibDiamond.diamondStorage();
        address owner = ownerOf(tokenId);

        _approve(address(0), tokenId);

        libStorage.balances[owner] -= 1;
        delete libStorage.owners[tokenId];

        emit Transfer(owner, address(0), tokenId);
    }
}
