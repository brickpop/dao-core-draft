import "../plugins/erc20-voting.sol";
import "../plugins/erc20-bidding.sol";
import "../other/erc20-minter.sol";
import "../base/base.sol";

// Bundle
contract MyCustomBundle is PluginBundle {
    Erc20Minter minter;

    // Here you tell the PluginInstaller what permissions each plugin returned on deploy() needs
    bytes32[][] public override permissionsOnDao = [
        [bytes32("EXEC_PERMISSION_ID")],  // plugin 1 permissions
        [bytes32("EXEC_PERMISSION_ID")]   // plugin 2 permissions
    ];
    // Here you tell the PluginInstaller what permissions the DAO needs on each plugin returned on deploy()
    bytes32[][] public override permissionsForDao = [
        [bytes32("CONFIG_PERMISSION_ID")], // DAO permissions on plugin 1
        []                                 // DAO permissions on plugin 2
    ];

    constructor(Erc20Minter _minter) {
        minter = _minter;
    }

    function deploy(address daoAddress, bytes memory data)
        public
        override
        returns (address[] memory)
    {
        address tokenAddress;
        uint16 timeWindow;
        uint256 supply;
        uint8 decimals;
        string memory name;
        string memory symbol;

        // DECODE PARAMS FOR ALL PLUGINS
        (tokenAddress, timeWindow, supply, decimals, name, symbol) = abi.decode(
            data,
            (address, uint16, uint256, uint8, string, string)
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

        // Result
        address[] memory installedPlugins;

        // Plugin (1) ERC20voting
        address template1Addr = address(0x1234); // Fetch it from the Plugin Registry
        Erc20VotingPluginTemplate template1 = Erc20VotingPluginTemplate(
            template1Addr
        );

        // Reencode
        bytes memory data1 = abi.encode(tokenAddress, 0, 0, "", "");
        address newPlugin = template1.deploy(daoAddress, data1);

        installedPlugins[0] = newPlugin;

        // Plugin (2) ERC20 bidding
        address template2Addr = address(0x2345); // Fetch it from the Plugin Registry
        Erc20BiddingPluginTemplate template2 = Erc20BiddingPluginTemplate(
            template2Addr
        );

        // Reencode
        bytes memory data2 = abi.encode(tokenAddress, 0, 0, "", "");
        newPlugin = template2.deploy(daoAddress, data2);

        installedPlugins[1] = newPlugin;

        // Done
        emit BundleInstalled(daoAddress);
        return installedPlugins;
    }

    function update(bytes32 oldVersion, bytes memory data) public override {}
}
