import "../base/base.sol";
import "./plugin-registry.sol";
import "./bundle-registry.sol";

// ASSUMPTIONS:
// - Singleton instance, deployed by Aragon
// - Can grant/revoke on all DAO's
// - Doess the permission assignment to all new plugins

contract PluginInstaller {
    PluginRegistry pluginRegistry;
    BundleRegistry bundleRegistry;

    function installPlugin(
        address daoAddress,
        bytes32 pluginId,
        bytes memory data
    ) public returns (address) {
        // 1) GET TEMPLATE FROM REGISTRY
        PluginTemplate template = pluginRegistry.getCurrentTemplate(pluginId);

        // 2) INSTALL
        address newPlugin = template.deploy(daoAddress, data);

        // 3) PLUGIN PERMISSIONS: Grant the plugin the declared permissions on the DAO contract
        for (uint256 i = 0; i < template.permissionsOnDao.len(); i++) {
            Component(newPlugin).grant(
                daoAddress,
                template.permissionsOnDao(i)
            );
        }

        // 4) DAO PERMISSIONS: Grant the permissions declared by the plugin to the DAO
        for (uint256 i = 0; i < template.permissionsForDao.len(); i++) {
            Component(daoAddress).grant(
                newPlugin,
                template.permissionsForDao(i)
            );
        }

        return newPlugin;
    }

    function installBundle(
        address daoAddress,
        bytes32 bundleId,
        bytes memory data
    ) public returns (address[] memory) {
        // 1) GET BUNDLE FROM REGISTRY
        PluginBundle bundle = bundleRegistry.getCurrentBundle(bundleId);

        // 2) RUN THE INSTALL CUSTOM LOGIC
        address[] memory newPlugins;
        newPlugins = bundle.deploy(daoAddress, data);

        // 3) PLUGIN PERMISSIONS: Grant each plugin the declared permissions on the DAO contract
        for (uint256 i = 0; i < newPlugins.len(); i++) {
            bytes32[] memory permissions = bundle.permissionsOnDao(i);

            for (uint256 j = 0; j < permissions.len(); j++) {
                Component(newPlugins[i]).grant(daoAddress, permissions[j]);
            }
        }

        // 4) DAO PERMISSIONS: Grant the permissions declared by each plugin to the DAO
        for (uint256 i = 0; i < newPlugins.len(); i++) {
            bytes32[] memory permissions = bundle.permissionsForDao(i);

            for (uint256 j = 0; j < permissions.len(); j++) {
                Component(daoAddress).grant(newPlugins[i], permissions[j]);
            }
        }

        return newPlugins;
    }
}
