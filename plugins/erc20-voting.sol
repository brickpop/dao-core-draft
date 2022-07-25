import "../other/erc20-minter.sol";
import "../base/base.sol";

// The Template
contract Erc20VotingPluginTemplate is PluginTemplate {
    Erc20Minter minter;

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
        Erc20Voting plugin = new Erc20Voting(
            tokenAddress,
            address(0x0),
            daoAddress
        );

        // INTERNAL HELPERS (will have zero permissions on the DAO)
        new MyRandomKeyValue();
        new MyRandomVault();
        new MyEscrow();
        new MyDispute(address(plugin));

        // EVENT
        emit PluginInstalled(daoAddress, address(plugin));
        return address(plugin);
    }

    function update(bytes32 oldVersion, bytes memory data) public override {}

    // PERMISSIONS

    // Here you tell the PluginInstaller what permissions each plugin returned on deploy() needs
    function getPermissionsOnDao()
        public
        pure
        override
        returns (bytes32[] memory result)
    {
        result[0] = bytes32("EXEC_PERMISSION_ID"); // plugin permission
        result[1] = bytes32("CONFIG_PERMISSION_ID"); // plugin permission
        return result;
    }

    // Here you tell the PluginInstaller what permissions the DAO needs on each plugin returned on deploy()
    function getPermissionsForDao()
        public
        pure
        override
        returns (bytes32[] memory result)
    {
        // No permission
        return result;
    }
}

// The Plugin

contract Erc20Voting is Plugin {
    DAO dao;
    address multisigContract;

    constructor(
        address _tokenAddress,
        address _multisigContract,
        address _daoAddress
    ) {
        /* ... */
        multisigContract = _multisigContract;
    }

    function newProposal() public {
        /* ... */
        if (msg.sender != multisigContract) revert();
    }

    function vote() public {}

    function executeResult() public {}

    function dispute() public {}

    function disputeWithdraw(bytes32 proposalId)
        public
        auth("DISPUTE_PERMISSION_ID")
    {
        // Only the plugin talks to the DAO
        dao.execute();
    }
}

// Internal utilities

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

    function dispute(bytes32 proposalId) public {}

    function disputeWithdraw(bytes32 proposalId) public {
        // Only the plugin talks to the DAO
        // => This internal helper asks the plugin to talk to the DAO
        plugin.disputeWithdraw(proposalId); /* ... */
    }
}
