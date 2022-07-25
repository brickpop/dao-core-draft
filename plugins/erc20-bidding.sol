import "../other/erc20-minter.sol";
import "../base/base.sol";

// The Template
contract Erc20BiddingPluginTemplate is PluginTemplate {
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
        uint16 timeWindow;
        uint256 supply;
        uint8 decimals;
        string memory name;
        string memory symbol;

        // DECODE
        (tokenAddress, timeWindow, supply, decimals, name, symbol) = abi.decode(
            data,
            (address, uint16, uint256, uint8, string, string)
        );

        if (timeWindow == 0) {
            revert();
        }

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

        Erc20BiddingPlugin plugin = new Erc20BiddingPlugin(
            tokenAddress,
            timeWindow
        );
        plugin.grant(daoAddress, permissionsForDao[0]);

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
        result[0] = bytes32("CONFIG_PERMISSION_ID"); // plugin permission
        return result;
    }
}

// The Plugin
contract Erc20BiddingPlugin is Plugin {
    constructor(address tokenAddress, uint16 timeWindow) {
        // ...
    }

    function newProposal() public {
        // ...
    }

    function vote() public {
        // ...
    }

    function executeResult() public {
        // ...
    }
}

// NO INTERNAL HELPERS
