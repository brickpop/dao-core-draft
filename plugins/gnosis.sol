import "../base/base.sol";

// The Template
contract GnosisPluginTemplate is PluginTemplate {
    function deploy(address daoAddress, bytes memory data)
        public
        override
        returns (address)
    {
        address multisigAddr;

        // DECODE
        (multisigAddr) = abi.decode(data, (address));

        // DEPLOY IF NEEDED
        if (multisigAddr == address(0x0)) {
            multisigAddr = address(new GnosisSafe(multisigAddr));
        }

        emit PluginInstalled(daoAddress, address(multisigAddr));
        return address(multisigAddr);
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

// NO PLUGIN => Existing contract that you simply grant permission to
contract GnosisSafe {
    // dummy class here
    constructor(address _multisigAddr) {}
}

// NO INTERNAL HELPERS
