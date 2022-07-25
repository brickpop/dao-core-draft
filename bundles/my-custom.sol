import "../plugins/erc20-voting.sol";
import "../plugins/erc20-bidding.sol";
import "../other/erc20-minter.sol";
import "../core/plugin-registry.sol";
import "../base/base.sol";

// Bundle
contract MyCustomBundle is PluginBundle {
    PluginRegistry pluginRegistry;
    Erc20Minter minter;

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
        bytes32[] memory pluginIds = getPluginIds();
        address[] memory installedPlugins;

        // Plugin (1) ERC20voting
        PluginTemplate template1 = pluginRegistry.getCurrentTemplate(
            pluginIds[0]
        );
        if (address(template1) == address(0x0)) revert();

        // Reencode
        bytes memory data1 = abi.encode(tokenAddress, 0, 0, "", "");
        address newPlugin = template1.deploy(daoAddress, data1);

        installedPlugins[0] = newPlugin;

        // Plugin (2) ERC20 bidding
        PluginTemplate template2 = pluginRegistry.getCurrentTemplate(
            pluginIds[1]
        );
        if (address(template2) == address(0x0)) revert();

        // Reencode
        bytes memory data2 = abi.encode(tokenAddress, timeWindow, 0, 0, "", "");
        newPlugin = template2.deploy(daoAddress, data2);

        installedPlugins[1] = newPlugin;

        // Done
        emit BundleInstalled(daoAddress);
        return installedPlugins;
    }

    function update(bytes32 oldVersion, bytes memory data) public override {}

    // PLUGINS MANAGED

    // Here you return the ID of the plugins that the bundle officially installs
    function getPluginIds() public override returns (bytes32[] memory result) {
        // plugin 1 ID
        result[0] = bytes32(
            0x0000000000000000000000000000000000000000000000000000000000001234
        );
        // plugin 2 ID
        result[1] = bytes32(
            0x0000000000000000000000000000000000000000000000000000000000002345
        );
        return result;
    }

    // PERMISSIONS

    // Here you tell the PluginInstaller what permissions each plugin returned on deploy() needs
    function getPermissionsOnDao()
        public
        override
        returns (bytes32[][] memory result)
    {
        result[0][0] = bytes32("EXEC_PERMISSION_ID"); // plugin 1 permissions
        result[0][1] = bytes32("CONFIG_PERMISSION_ID"); // plugin 1 permissions
        result[1][0] = bytes32("EXEC_PERMISSION_ID"); // plugin 2 permissions
        return result;
    }

    // Here you tell the PluginInstaller what permissions the DAO needs on each plugin returned on deploy()
    function getPermissionsForDao()
        public
        override
        returns (bytes32[][] memory result)
    {
        result[0][0] = bytes32("EXEC_PERMISSION_ID"); // plugin 1 permissions
        // NO plugin 2 permissions
        return result;
    }
}
