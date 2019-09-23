pragma solidity ^0.5.0;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Full.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721Mintable.sol";
import "../node_modules/@openzeppelin/contracts/ownership/Ownable.sol";

contract Kame is ERC721Full, ERC721Mintable, Ownable {
  struct Kora {
    bytes32 metadata;
    address minter;
    bool mainnetLock;
  }

  Kora[] public kora;
  address _v2Contract = address(0);

  constructor (string memory name, string memory symbol) public ERC721Full(name, symbol) {
      // initialize Kora[]
      Kora memory nullKora = Kora({
        metadata: bytes32(0),
        minter: msg.sender,
        mainnetLock: false
      });
      mint(msg.sender, 0);
      kora.push(nullKora);
    }

  function mintKora (bytes32 metadata) public returns(bool, uint256) {
    address minter = msg.sender;
    uint256 newTokenId = kora.length;
    Kora memory newKora = Kora({
      metadata: metadata,
      minter: minter,
      mainnetLock: false
    });
    if (mint(minter, newTokenId) == true) {
      kora.push(newKora);
      return (true, newTokenId);
    } else return (false, 0);
  }

  function getTokenById (uint256 id) public view returns(bytes32, address, bool) {
    Kora memory k = kora[id];
    return(k.metadata, k.minter, k.mainnetLock);
  }

  function tokensOfOwner(address owner) public view returns (uint256[] memory) {
    return _tokensOfOwner(owner);
  }

  function lockToMainnet (uint256 id) public onlyOwner returns(bool) {
    if (kora[id].mainnetLock = true) {
      return true;
    } else {
      kora[id].mainnetLock = true;
      return true;
    }
  }

  function updateContract (address v2Contract) public onlyOwner {
    _v2Contract = v2Contract;
    emit emitV2Contract(_v2Contract);
  }

  event emitV2Contract (address indexed v2Contract);

  function () external payable {}
}
