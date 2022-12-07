pragma solidity >=0.5.0 <0.6.0;

import "./erc721.sol";
import "./safemath.sol";

contract Bookclub is ERC721 {
    using SafeMath for uint256;

    struct Book {
        string name;
        uint256 year;
        string author;
    }

    Book[] bookList;
    mapping(uint256 => address) bookToOwner;
    mapping(address => uint256) ownerBookCount;
    mapping(uint256 => address) bookApprovals;

    function addBook(
        string memory _name,
        uint256 _year,
        string memory _author
    ) public {
        uint256 id = bookList.push(Book(_name, _year, _author));
        bookToOwner[id] = msg.sender;
        ownerBookCount[msg.sender] = ownerBookCount[msg.sender].add(1);
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return ownerBookCount[_owner];
    }

    function ownerOf(uint256 _tokenId) external view returns (address) {
        return bookToOwner[_tokenId];
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _tokenId
    ) external payable {
        require(
            bookToOwner[_tokenId] == msg.sender ||
                bookApprovals[_tokenId] == msg.sender
        );

        ownerBookCount[_to] = ownerBookCount[_to].add(1);
        ownerBookCount[msg.sender] = ownerBookCount[msg.sender].sub(1);
        bookToOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function approve(address _approved, uint256 _tokenId)
        external
        payable
        onlyOwnerOf(_tokenId)
    {
        require(bookToOwner[_tokenId] == msg.sender);
        bookApprovals[_tokenId] == _approved;
        emit Approval(msg.sender, _approved, _tokenId);
    }
}
