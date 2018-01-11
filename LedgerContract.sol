pragma solidity ^0.4.0;
contract PrescriptionLedger{
    enum MedType {Opiod, SSRI, Antibiotic}
    Prescription[] list;
    uint8 index;
    address public owner;
    mapping(address => uint) _validAddresses;

    function PrescriptionLedger() public{
       index = 0;
       owner = msg.sender;
       _validAddresses[owner] = 1;
    }
    
    modifier checkValid(){
        if(_validAddresses[msg.sender] != 0){
            _;
        }
    }
    
    modifier checkOwner(){
        if(msg.sender == owner){
            _;
        }
    }
    
    struct Prescription{
         MedType presType;
         address pharmacist;
         uint16 myDosage;
        //For reader note, myFrequency refers to the amount of times this specific
        //patient has filled this same Prescription. We did not want to give out anything
        //to identify the patient, but we want to allow people analyzing these blocks to see 
        //trends in which medicines are used habitually, and which are used only once.
        bool repeated; 
        uint myTime;
        uint16 myTransNum;
        uint8 myZip;
    }
    
    function getPrescription() returns (uint){
        return list[0].myDosage;
    }
    
    function addPharmacist(address add) public {
        _validAddresses[add] = 1;
    }
    
    function addPrescription(MedType medicine, uint16 dosage, bool freq, uint8 zip) public checkValid {
        list.push(Prescription(medicine, msg.sender, dosage, freq, now, index, zip));
    }
}
