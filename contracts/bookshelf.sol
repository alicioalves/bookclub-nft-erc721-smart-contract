pragma solidity >=0.5.0 <0.6.0;

import "./erc721.sol";
import "./safemath.sol";

contract Bookshelf is ERC721 {
    using SafeMath for uint256;

    struct Book {
        string name;
        uint256 year;
        string author;
    }

    Book[] bookList;
    mapping(uint256 => address) bookToOwner;
    mapping(address => uint256) ownerBookCount;

    function addBook(
        string memory _name,
        uint256 _year,
        string memory _author
    ) public {
        uint256 id = bookList.push(Book(_name, _year, _author));
        bookToOwner[id] = msg.sender;
        ownerBookCount[msg.sender] = ownerBookCount[msg.sender].add(1);
    }
}
