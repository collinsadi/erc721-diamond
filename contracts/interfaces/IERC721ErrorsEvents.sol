/**
 * @dev Standard ERC-721 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-721 tokens.
 */
interface IERC721ErrorsEvents {
    /**
     * @dev Indicates an error related to an invalid or zero address as the owner.
     * @param owner Address that cannot be the owner of the token (e.g., address(0)).
     */
    error ERC721InvalidOwner(address owner);

    /**
     * @dev Indicates a failure when trying to interact with a non-existent tokenId.
     * @param tokenId Identifier of the token that does not exist.
     */
    error ERC721NonexistentToken(uint256 tokenId);

    /**
     * @dev Indicates an error where the sender is not the owner of the token.
     * @param sender Address that is attempting the operation.
     * @param tokenId Identifier of the token.
     * @param owner Actual owner of the token.
     */
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC721InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC721InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval status. Used in transfers.
     * @param operator Address attempting to transfer a token.
     * @param tokenId Identifier of the token.
     */
    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    /**
     * @dev Indicates a failure when trying to approve a zero address or invalid address.
     * @param approver Address initiating the approval.
     */
    error ERC721InvalidApprover(address approver);

    /**
     * @dev Indicates a failure when trying to approve an invalid operator.
     * @param operator Address that is supposed to be approved.
     */
    error ERC721InvalidOperator(address operator);

    /**
     * @dev Emitted when a token is transferred from `from` to `to`.
     * @param from Address the token is transferred from.
     * @param to Address the token is transferred to.
     * @param tokenId Identifier of the transferred token.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     * @param owner Address that owns the token.
     * @param approved Address approved to manage the token.
     * @param tokenId Identifier of the token being approved.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all its assets.
     * @param owner Address that owns the tokens.
     * @param operator Address that is allowed or disallowed to operate on the owner's tokens.
     * @param approved Boolean that indicates if the operator is approved or not.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
}
