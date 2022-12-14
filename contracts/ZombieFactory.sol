// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ZombieFactory is Ownable {
  event NewZombie(uint256 zombieId, string name, uint256 dna);

  uint256 dnaDigits = 16;
  uint256 dnaModulus = 10**dnaDigits;

  struct Zombie {
    string name;
    uint256 dna;
  }

  Zombie[] public zombies;

  mapping(uint256 => address) public zombieToOwner;
  mapping(address => uint256) public ownerZombieCount;

  /**
   * @dev A function that creates a new zombie
   * @param _name The name of the zombie
   * @param _dna The DNA of the zombie
   */
  function _createZombie(string memory _name, uint256 _dna) internal {
    zombies.push(Zombie(_name, _dna));
    uint256 id = zombies.length - 1;

    zombieToOwner[id] = msg.sender;
    ownerZombieCount[msg.sender]++;
    emit NewZombie(id, _name, _dna);
  }

  /**
   * @dev A function that generates a random number
   * @return A random number
   */
  function _generateRandomDna(string memory _str)
    private
    view
    returns (uint256)
  {
    uint256 rand = uint256(keccak256(abi.encode(_str)));

    return rand % dnaModulus;
  }

  /**
   * @dev A public function to create new zombies
   * @param _name The name of the zombie
   */
  function createRandomZombie(string memory _name) public {
    require(
      ownerZombieCount[msg.sender] == 0,
      "The player already has at least one zombie"
    );
    uint256 randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
  }

  function getAllZombies() public view returns (Zombie[] memory) {
    return zombies;
  }
}
