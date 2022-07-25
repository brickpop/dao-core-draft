abstract contract PluginBundle {
    event BundleInstalled(address daoAddress);

    function deploy(address daoAddress, bytes memory data)
        public
        virtual
        returns (address[] memory);

    function update(bytes32 oldVersion, bytes memory data) public virtual;

    function getPluginIds() public virtual returns (bytes32[] memory result);

    function getPermissionsOnDao() public virtual returns (bytes32[][] memory);

    function getPermissionsForDao() public virtual returns (bytes32[][] memory);
}

abstract contract PluginTemplate {
    event PluginInstalled(address daoAddress, address plugin);

    function deploy(address daoAddress, bytes memory data)
        public
        virtual
        returns (address);

    function update(bytes32 oldVersion, bytes memory data) public virtual;

    function getPermissionsOnDao() public virtual returns (bytes32[] memory);

    function getPermissionsForDao() public virtual returns (bytes32[] memory);
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
