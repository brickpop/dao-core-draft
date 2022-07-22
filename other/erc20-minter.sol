// RANDOM, SEPARATE, NON-PLUGIN RELATED CONTRACT
// It can be used by any PluginTemplate, same as it could be used by any contract in general

contract Erc20Minter {
    function mint(
        address daoAddress,
        uint256 supply,
        uint8 decimals,
        string memory name,
        string memory symbol
    ) public returns (address) {
        // Do the minting
        Erc20Token minter = new Erc20Token(
            daoAddress,
            supply,
            decimals,
            name,
            symbol
        );

        return address(minter);
    }
}

contract Erc20Token {
    constructor(
        address owner,
        uint256 supply,
        uint8 decimals,
        string memory name,
        string memory symbol
    ) {}

    function balanceOf(address _addr) public view {}
    // ...
}
