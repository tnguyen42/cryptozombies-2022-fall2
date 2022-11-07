// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.9.0;

contract ZombieFactory {
  event NewZombie(uint256 zombieId, string name, uint256 dna);

  uint256 dnaDigits = 16;
  uint256 dnaModulus = 10**dnaDigits;

  struct Zombie {
    string name;
    uint256 dna;
  }

  Zombie[] public zombies;

  /**
   * @dev A function that creates a new zombie
   * @param _name The name of the zombie
   * @param _dna The DNA of the zombie
   */
  function _createZombie(string memory _name, uint256 _dna) private {
    zombies.push(Zombie(_name, _dna));

    emit NewZombie(zombies.length, _name, _dna);
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
    uint256 randDna = _generateRandomDna(_name);
    _createZombie(_name, randDna);
  }
}
