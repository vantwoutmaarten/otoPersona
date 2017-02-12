contract VerificationEntity {
    string role;
    uint adminIndex;
    address idAddress;
    mapping(address => uint) administrators;
    mapping(address => uint) verificationRegister;

    event onResult(uint resultType, string resultMsg);

    function VerificationEntity(address _defaultVEContract, bytes idData) {
        administrators[tx.origin] = 1;
        adminIndex = 1;
        idAddress = new Identity("VE", _defaultVEContract, idData);
    }

    function addAdmin(address admin) constant {
        if (administrators[tx.origin] == 1) {
            administrators[admin] = 1;
            adminIndex++;
            onResult(1, "[VerificationEntity][addAdmin] Result: Admin added");
        } else {
            onResult(0, "[VerificationEntity][addAdmin] Error: Not Admin");
        }
    }

    function removeAdmin(address admin) constant {
        if (administrators[tx.origin] == 1 && adminIndex > 1) {
            adminIndex--;
            delete administrators[admin];
            onResult(1, "[VerificationEntity][removeAdmin] Result: Admin removed");
        } else {
            onResult(0, "[VerificationEntity][removeAdmin] Error: Not Admin");
        }
    }

    function setVerificationState(address accountAddress, uint state) {
        if (administrators[tx.origin] == 1) {
            verificationRegister[accountAddress] = state;
        } else {
            onResult(0, "[VerificationEntity][setVerificationState] Erro: Not Owner/Admin");
        }
    }

    function getID() constant returns(address) {
        return idAddress;
    }

    function getVerificationReg(address accountAddress) constant returns(uint) {
        return verificationRegister[accountAddress];
    }

} //end  VE