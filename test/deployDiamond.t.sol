// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "../contracts/upgradable-contracts/interfaces/IDiamondCut.sol";
import "../contracts/upgradable-contracts/facets/DiamondCutFacet.sol";
import "../contracts/upgradable-contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/upgradable-contracts/facets/OwnershipFacet.sol";
import "../contracts/upgradable-contracts/facets/SetterGetter.sol";
import "forge-std/Test.sol";
import "../contracts/upgradable-contracts/Diamond.sol";

contract DiamondDeployer is Test, IDiamondCut {
    //contract types of facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    SetterGetter setterGetter;

    function setUp() public {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](2);

        cut[0] = (
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");

        //call a function
        DiamondLoupeFacet(address(diamond)).facetAddresses();
    }

    function testAddFaucet() public {
        setterGetter = new SetterGetter();

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](1);
        cut[0] = (
            FacetCut({
                facetAddress: address(setterGetter),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("SetterGetter")
            })
        );

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");
        SetterGetter(address(diamond)).setName("Aji");
        string memory name = SetterGetter(address(diamond)).getName();

        assert(keccak256(abi.encodePacked(name)) == keccak256(abi.encodePacked("Aji"))); // Ensure string comparison works
    }

    function generateSelectors(string memory _facetName) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "script/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function diamondCut(FacetCut[] calldata _diamondCut, address _init, bytes calldata _calldata) external override {}
}
