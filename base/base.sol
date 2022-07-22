abstract contract PluginBundle {
    event BundleInstalled(address daoAddress);

    bytes32[][] public permissionsOnDao;
    bytes32[][] public permissionsForDao;

    function deploy(address daoAddress, bytes memory data)
        public
        virtual
        returns (address[] memory);

    function update(bytes32 oldVersion, bytes memory data) public virtual;
}

abstract contract PluginTemplate {
    event PluginInstalled(address daoAddress, address plugin);

    bytes32[] public permissionsOnDao;
    bytes32[] public permissionsForDao;

    function deploy(address daoAddress, bytes memory data)
        public
        virtual
        returns (address);

    function update(bytes32 oldVersion, bytes memory data) public virtual;
}

abstract contract Component {
    modifier auth(string memory permissionId) {
        _;
    }

    function grant(address _a, bytes32 _b) public {}
}

abstract contract Plugin is Component {}

abstract contract DAO is Component {
    function execute() public virtual;
}
