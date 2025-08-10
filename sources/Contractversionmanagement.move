module Gangotri_addr::ContractVersionManager {
    use aptos_framework::signer;
    use std::string::{Self, String};
    use std::vector;

   
    struct ContractRegistry has store, key {
        current_version: String,    
        version_history: vector<String>,
        owner: address,              
        is_active: bool,            
    }

  
    const E_NOT_OWNER: u64 = 1;
    const E_REGISTRY_NOT_EXISTS: u64 = 2;
    const E_INVALID_VERSION: u64 = 3;

   
    public fun initialize_registry(owner: &signer, initial_version: String) {
        let owner_addr = signer::address_of(owner);
        
       
        let initial_history = vector::empty<String>();
        vector::push_back(&mut initial_history, initial_version);
        
        let registry = ContractRegistry {
            current_version: initial_version,
            version_history: initial_history,
            owner: owner_addr,
            is_active: true,
        };
        
        move_to(owner, registry);
    }

  
    public fun update_version(
        owner: &signer, 
        registry_owner: address, 
        new_version: String
    ) acquires ContractRegistry {
        let owner_addr = signer::address_of(owner);
        
       
        assert!(exists<ContractRegistry>(registry_owner), E_REGISTRY_NOT_EXISTS);
        
        let registry = borrow_global_mut<ContractRegistry>(registry_owner);
        
      
        assert!(registry.owner == owner_addr, E_NOT_OWNER);
       
        assert!(!string::is_empty(&new_version), E_INVALID_VERSION);
        
       
        registry.current_version = new_version;
        vector::push_back(&mut registry.version_history, new_version);
    }

}

