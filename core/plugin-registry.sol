import "../base/base.sol";

// REGISTRY

contract PluginRegistry {
    function getCurrentTemplate(bytes32 _pluginId)
        public
        returns (PluginTemplate)
    {
        // DUMMY EXAMPLE
        return PluginVersion(address(0x1234)).getTemplate(bytes32(0x0));
    }
}

contract PluginVersion {
    function getTemplate(bytes32 _version) public returns (PluginTemplate) {
        // DUMMY EXAMPLE
        return PluginTemplate(address(0x1234));
    }
}
