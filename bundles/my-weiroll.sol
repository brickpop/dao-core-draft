import "../plugins/erc20-voting.sol";
import "../plugins/erc20-bidding.sol";
import "../other/erc20-minter.sol";
import "../base/base.sol";

// Bundle
contract MyWeirollBundle is PluginBundle {
    function deploy(address daoAddress, bytes memory data)
        public
        override
        returns (address[] memory)
    {
        // Result
        address[] memory installedPlugins;

        // 1: Decode `data` into a weiroll instance
        // 2: Execute weiroll to do something
        // 3: Populate installedPlugins

        // Done
        emit BundleInstalled(daoAddress);
        return installedPlugins;
    }

    function update(bytes32 oldVersion, bytes memory data) public override {}
}
