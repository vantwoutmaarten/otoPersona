contract Identity {

    address owner;
    string idType;
    bytes idData;
    bytes metaData;

    mapping(address => uint) VEAdmins;

    mapping(address => uint) VEContractIndexMap;
    address[10] VEContracts;
    bytes[10] VEStamps;
    uint VEContractIndex;

    event onResult(uint resultType, string resultMsg);

    function Identity(string _idType, address _defaultVEContract) {
        owner = tx.origin;
        idType = _idType;

        VEContractIndex = 1;
        VEAdmins[0x63ad0cb91d02c91b9392d1af58c87e282238a3a6] = VEContractIndex;
        VEContracts[VEContractIndex] = _defaultVEContract;
        VEContractIndexMap[_defaultVEContract] = VEContractIndex;
    }

    function setOwner(address newOwner) {
        if (tx.origin == owner) {
            owner = newOwner;
        }
    }

    function setData(bool isIdData, bytes data) {
        if (tx.origin == owner) {
            if (isIdData) {
                idData = data;
                delete VEStamps;
            } else {
                metaData = data;
            }
        }
    }

    function setVE(address veContractAddress) {
        if (VEAdmins[tx.origin] == 1) {
            uint index = VEContractIndexMap[veContractAddress];
        }
    }

    function setStamp(bytes stamp) {
        VEStamps[VEAdmins[tx.origin]] = stamp;
    }

    function getOwner() constant returns(address) {
        return owner;
    }

    function getIdType() constant returns(string) {
        return idType;
    }

    function getData(bool isIdData) constant returns(bytes) {
        if (isIdData) {
            return idData;
        } else {
            return metaData;
        }
    }

    function getVEContracts() constant returns(address[10]) {
        return VEContracts;
    }

    function getStamp(address contractAddress) constant returns(bytes) {
        return VEStamps[VEContractIndexMap[contractAddress]];
    }

    function getVerificationState() constant returns(uint) {
        return getVerificationState(VEContracts[1]);
    }

    function getVerificationState(address verificationEntityContract) constant returns(uint) {
        VerificationEntity verificationEntity = VerificationEntity(verificationEntityContract);
        return verificationEntity.getVerificationReg(this);
    }

} //end Identity



contract Persona {
    address owner;
    address idAddress;

    event onResult(uint resultType, string resultMsg);

    function Persona(address _defaultVEContract, bytes idData) {
        owner = tx.origin;
        idAddress = new Identity("individual", _defaultVEContract, idData);
    }

    function signReso(address resoAddress) {
        Reso reso = Reso(resoAddress);
        reso.sign();
    }

    function getOwner() constant returns(address) {
        return owner;
    }

    function getID() constant returns(address) {
        return idAddress;
    }

} //end Persona