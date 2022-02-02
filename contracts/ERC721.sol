pragma solidity ^0.8.2;

contract ERC721 {

    event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping(address => uint256) internal _balances;

    mapping(uint256 => address) internal _owners;

    mapping(address => mapping(address => bool)) private _operatorApprovals;

    mapping(uint256 => address) private _tokenApprovals;


    // Returns the number of NFTs assigned to an owner
    function balanceOf(address owner) public view returns(uint256)  {
        require(owner != address(0), "address is zero");
        return _balances[owner ];
    }

    // Finds the owner of an NFT
    function ownerOf(uint256 token) public view returns(address) {  
        address owner = _owners[tokenId];
        require(owner != address(0), "TokenID does not exist");
        return owner;
    }


    // Enables or disables an operator to manage all of msg.senders assets
    function setApprovalForAll(address operator, bool approved) public {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    // Checks if an address is an operator for another address
    function isApprovedForAll(address owner, address operator) public view returns(bool){
        return _operatorApprovals[owner][operator];
    }

    // Update and approve address for an NFT
    function approve(address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "Msg.sender is not the owner or an approved operator");
        _tokenApprovals[tokenId] = to;
        emit Approve(owner, to, tokenId)
    }

    // Get the approved address for a single NFT
    function getApproved(uint256 tokenId) returns(address) public view returns(address) {
        require(_owners[tokenId] != address(0), "Token ID does not exist")
        return _tokenApprovals[tokenId];
    }

    // Transfer ownership of an NFT
    function transferFrom(address from, address to, uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        require (
            msg.sender == owner ||
            getApproved(tokenId) == msg.sender ||
            isApprovedForAll(owner, msg.sender),
            "msg.sender is not the owner or approved for transfer"
        );
        require(owner == from, "From address is not the owner");
        require(to != address(0), "Address is 0");
        require(_owners[tokenId] != address(0), "TokenId does not exist");
        approve(address(0),tokenId);

        _balance[from] -= 1;
        _balance[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }

    // Standart transferFrom
    // Check if on ERC721Received is implemented WHEN sending to smart contract
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(), "Receiver not implemented");
    }

    function SafeTransferFrom((address from, address to, uint256 tokenId) {
        safeTransferFrom(from, to, tokenId, "");
    }

    // Oversimplified
    function _checkOnERC721Received() private pure returns(bool) {
        return true;
    }

    // EIP165 : Query if a contract implements another interface -> call this function and find out if another smartcontract has the function that we're looking for
    function supportsInterface(bytes4 interfaceId) public pure virtual returns(bool) {
        return interfaceId == 0x80ac58cd;
    }

} 