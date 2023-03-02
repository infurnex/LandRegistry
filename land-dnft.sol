// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LandDNFT {

    address government = 0xE1AA703F275D260fD9bD0CC93fb0A76c2Bfe1f9B;
    string NameofNFT = "Indian Land Registry";
    address[] subRegistrars;


    struct land_dnft {
        uint _landId;
        address _Owner;
        uint _landArea;
        string _address;
        string _state;
        uint _postalNumber;
        string _district;
        string _subDistrict;
        string _longitute;
        string _latitute;
        string _imageUrl;
    }

    struct destroy_dnft{
        address _Owner;
        uint _landId;
        address _burningAthority;
        uint _blockNumber;
    }
    
    mapping(uint256 => land_dnft) private _mintedLand;//mapping land_id to Land_dnft

    mapping(uint256 => destroy_dnft) private _burnnft;//mapping at time of burning land

    function _Name() public view returns(string memory){
        return NameofNFT;
    }//returns name of system


    function Addsubregistrar(address subregistrar) public{
        require(msg.sender== government);
        subRegistrars.push(subregistrar);
    }//giving athority to subRegistrars



    function checkIDAvailability(uint landid) public view returns(bool){
        return _mintedLand[landid]._landArea == 0;
    }//checking availabilty of landid



    function _mintLandnft(uint landID ,address Owner, uint area , string memory landAddress, string memory state, uint postNumber, string memory district, string memory subDistrict,string memory longitute, string memory latitute, string memory imgUrl) public {
        require(msg.sender== government);
        require(checkIDAvailability(landID));
        _mintedLand[landID] = land_dnft(landID, Owner, area, landAddress, state, postNumber, district, subDistrict, longitute, latitute, imgUrl);
    }//minting land nft



    function checkOwner(address claimedOwner, uint landid) public view returns(bool){
        return (_mintedLand[landid]._Owner == claimedOwner);
    }//checking owner of landid



    function _TransferLand(address soldTo, uint landid) public{
        require(checkOwner(msg.sender , landid),"Not the Owner");
        _mintedLand[landid]._Owner = soldTo;
    }//transfer of landid to new owner



    function burn_landnft(uint landid, address Owner,uint subregistrarID) public{
        require(checkOwner(Owner,landid),"owner and landid donot match");
        require(msg.sender == government|| msg.sender== subRegistrars[subregistrarID]);
        _mintedLand[landid]._Owner = government;
        _burnnft[landid] = destroy_dnft(Owner, landid, msg.sender, block.number);
    }// this will burn the land nft by transfering ownership to government



    function ViewLandnft(uint256 landid) public view returns(land_dnft memory){
        return _mintedLand[landid];
    }//view landnft



    function updateLandNFTaddress(string memory landAddress , uint Landid) public {
        require(msg.sender== government);
        _mintedLand[Landid]._address = landAddress;
    }//updating land nft address



    function updateLandNFTimg(string memory imgUrl , uint landid) public {
        require(msg.sender == government);
        _mintedLand[landid]._imageUrl = imgUrl;
    }//updating land img url

}