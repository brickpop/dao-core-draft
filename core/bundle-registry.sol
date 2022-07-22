import "../base/base.sol";

// REGISTRY

contract BundleRegistry {
    function getCurrentBundle(bytes32 _bundleId)
        public
        returns (PluginBundle)
    {
        // DUMMY EXAMPLE
        return BundleVersion(address(0x1234)).getBundle(bytes32(0x0));
    }
}

contract BundleVersion {
    function getBundle(bytes32 _version) public returns (PluginBundle) {
        // DUMMY EXAMPLE
        return PluginBundle(address(0x1234));
    }
}
