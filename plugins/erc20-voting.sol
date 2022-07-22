import "../other/erc20-minter.sol";
import "../base/base.sol";

// The Template
contract Erc20VotingPluginTemplate is PluginTemplate {
    Erc20Minter minter;

    // Here you tell the PluginInstaller what permissions the new plugin created on deploy() needs
    bytes32[] public override permissionsOnDao = [
        bytes32("EXEC_PERMISSION_ID")
    ];
    // Here you tell the PluginInstaller what permissions the DAO needs on the plugin returned on deploy()
    bytes32[] public override permissionsForDao;

    constructor(Erc20Minter _minter) {
        minter = _minter;
    }

    function deploy(address daoAddress, bytes memory data)
        public
        override
        returns (address)
    {
        address tokenAddress;
        uint256 supply;
        uint8 decimals;
        string memory name;
        string memory symbol;

        // DECODE
        (tokenAddress, supply, decimals, name, symbol) = abi.decode(
            data,
            (address, uint256, uint8, string, string)
        );

        // DEPLOY IF NEEDED
        if (tokenAddress == address(0x0)) {
            tokenAddress = minter.mint(
                daoAddress,
                supply,
                decimals,
                name,
                symbol
            );
        }

        // DEPLOY PLUGIN
        Erc20Voting plugin = new Erc20Voting(tokenAddress, daoAddress);

        // INTERNAL HELPERS (will have zero permissions on the DAO)
        new MyRandomKeyValue();
        new MyRandomVault();
        new MyEscrow();
        new MyDispute(address(this));

        // EVENT
        emit PluginInstalled(daoAddress, address(plugin));
        return address(plugin);
    }

    function update(bytes32 oldVersion, bytes memory data) public override {}
}

// The Plugin

contract Erc20Voting is Plugin {
    DAO dao;

    constructor(address tokenAddress, address daoAddress) {
        /* ... */
    }

    function newProposal() public {
        /* ... */
    }

    function vote() public {
        /* ... */
    }

    function executeResult() public {
        /* ... */
    }

    function dispute()
        public
        /* ... */
        auth("DISPUTE_PERMISSION_ID")
    {
        // Only the plugin talks to the DAO
        dao.execute(); /* ... */
    }
}

// Internal helpers

contract MyRandomKeyValue {
    // ...
}

contract MyRandomVault {
    // ...
}

contract MyEscrow {
    // ...
}

contract MyDispute {
    Erc20Voting plugin;

    constructor(address _plugin) {
        plugin = Erc20Voting(_plugin);
    }

    function dispute(bytes32 proposalId) public {
        // Only the plugin talks to the DAO
        // => This internal helper asks the plugin to talk to the DAO
        plugin.dispute(); /* ... */
    }
}
