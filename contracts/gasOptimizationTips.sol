//SPDX-License-Identifier: unlicenced
pragma solidity =0.8.0;



// Gas Optimization tip:
// use bytesX over string
contract bytesXOverString {
    //gas cost: 19
    function bytesX() public view returns (uint256 gasUsed) {
        uint256 gasleft_1 = gasleft();

        bytes32 a = "bytes";

        uint256 gasleft_2 = gasleft();
        gasUsed = gasleft_1 - gasleft_2;
    }
    //gas cost: 79
    function string_() public view returns (uint256 gasUsed) {
        uint256 gasleft_1 = gasleft();

        string memory a = "bytes";

        uint256 gasleft_2 = gasleft();
        gasUsed = gasleft_1 - gasleft_2;
    }

}


// packing storage variable - bad example
// the same also applies to struct
contract packStorageVarsBad {
    uint128 a;
    uint256 b;
    uint128 c;


    //gas cost: 61703 for update(1,1,1)
    function update(uint128 _a,
                    uint256 _b,
                    uint128 _c)
                    public returns (uint256 gasUsed)
    {
        uint256 gasleft_1 = gasleft();

        a = _a;
        b = _b;
        c = _c;

        uint256 gasleft_2 = gasleft();
        gasUsed = gasleft_1 - gasleft_2;
    }
}

// packing storage variable - good example
contract packStorageVarsGood {
    uint128 a;
    uint128 c;
    uint256 b;
    
    //gas cost: 40908 for update(1,1,1)
    function update(uint128 _a,
                    uint256 _b,
                    uint128 _c)
                    public returns (uint256 gasUsed)
    {
        uint256 gasleft_1 = gasleft();

        a = _a;
        b = _b;
        c = _c;

        uint256 gasleft_2 = gasleft();
        gasUsed = gasleft_1 - gasleft_2;
    }
}

//load storage varaible into a memory when updating multiple times in one single call
// good example
contract sloadStorageVarsGood {
    
    Slot0 slot0;
    
    struct Slot0 {
        uint256 a;
        uint128 b;
    }
    
    function updateSlot0Good() 
                  public returns (uint256 gasUsed) 
    {
        
        uint256 gasleft_1 = gasleft();
        
        Slot0 memory _slot0 = slot0;
        
        _slot0.a = 1;
        _slot0.b = 1;
        
        doSomething();
        
        _slot0.a = 2;
        _slot0.b = 2;
        
        slot0 = _slot0;
        
        uint256 gasleft_2 = gasleft();
        gasUsed = gasleft_1 - gasleft_2;
    
    }
    
    function doSomething() public {}
    
    
}

// load storage varaible into a memory when updating multiple times in one single call
// bad example
contract sloadStorageVarsBad {
    
    Slot0 slot0;
    
    struct Slot0 {
        uint256 a;
        uint128 b;
    }
    
    function updateSlot0Bad() public returns (uint256 gasUsed) 
    {
        
        uint256 gasleft_1 = gasleft();
        
        slot0.a = 1;
        slot0.b = 1;
        
        doSomething();
        
        slot0.a = 2;
        slot0.b = 2;
        
        uint256 gasleft_2 = gasleft();
        gasUsed = gasleft_1 - gasleft_2;
    
    }
    
    function doSomething() public {}

    
}



//use external calldata over public when passing large arguement
contract externalOverPublic {
    
    function savingLargeBytesBad(bytes32[] memory largeParams) public view returns (uint256 gasUsed) {
        uint256 gasleft_1 = gasleft();
        
        uint256 len = largeParams.length;
        
        uint256 gasleft_2 = gasleft();
        gasUsed = gasleft_1 - gasleft_2;
    }
    
    function savingLargeBytesGood(bytes32[] calldata largeParams) external view returns (uint256 gasUsed) {
        uint256 gasleft_1 = gasleft();
        
        uint256 len = largeParams.length;
        
        uint256 gasleft_2 = gasleft();
        gasUsed = gasleft_1 - gasleft_2;
    }
}



