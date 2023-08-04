use array::ArrayTrait;
use clone::Clone;
use starknet::{ContractAddress, contract_address_const};
use sx::types::Strategy;

// TODO: move to u32
#[derive(Clone, Drop, Serde)]
struct UpdateSettingsCalldata {
    min_voting_duration: u64,
    max_voting_duration: u64,
    voting_delay: u64,
    metadata_URI: Array<felt252>,
    dao_URI: Array<felt252>,
    proposal_validation_strategy: Strategy,
    proposal_validation_strategy_metadata_URI: Array<felt252>,
    authenticators_to_add: Array<ContractAddress>,
    authenticators_to_remove: Array<ContractAddress>,
    voting_strategies_to_add: Array<Strategy>,
    voting_strategies_metadata_URIs_to_add: Array<Array<felt252>>,
    voting_strategies_to_remove: Array<u8>,
}

trait UpdateSettingsCalldataTrait {
    fn default() -> UpdateSettingsCalldata;
}

// Theoretically could derive a value with a proc_macro,
// since NO_UPDATE values are simply the first x bytes of a hash.
trait NoUpdateTrait<T> {
    fn no_update() -> T;
    fn should_update(self: @T) -> bool;
}

// Obtained by keccak256 hashing the string "No update", and then taking the corresponding number of bytes.
// Evaluates to: 0xf2cda9b13ed04e585461605c0d6e804933ca828111bd94d4e6a96c75e8b048ba

impl NoUpdateU32 of NoUpdateTrait<u32> {
    fn no_update() -> u32 {
        0xf2cda9b1
    }

    fn should_update(self: @u32) -> bool {
        *self != 0xf2cda9b1
    }
}

impl NoUpdateU64 of NoUpdateTrait<u64> {
    fn no_update() -> u64 {
        0xf2cda9b13ed04e58
    }

    fn should_update(self: @u64) -> bool {
        *self != 0xf2cda9b13ed04e58
    }
}

impl NoUpdateFelt252 of NoUpdateTrait<felt252> {
    fn no_update() -> felt252 {
        // First 248 bits
        0xf2cda9b13ed04e585461605c0d6e804933ca828111bd94d4e6a96c75e8b048
    }

    fn should_update(self: @felt252) -> bool {
        *self != 0xf2cda9b13ed04e585461605c0d6e804933ca828111bd94d4e6a96c75e8b048
    }
}

impl NoUpdateContractAddress of NoUpdateTrait<ContractAddress> {
    fn no_update() -> ContractAddress {
        // First 248 bits
        contract_address_const::<0xf2cda9b13ed04e585461605c0d6e804933ca828111bd94d4e6a96c75e8b048>()
    }

    fn should_update(self: @ContractAddress) -> bool {
        *self != contract_address_const::<0xf2cda9b13ed04e585461605c0d6e804933ca828111bd94d4e6a96c75e8b048>()
    }
}

impl NoUpdateStrategy of NoUpdateTrait<Strategy> {
    fn no_update() -> Strategy {
        Strategy {
            address: contract_address_const::<0xf2cda9b13ed04e585461605c0d6e804933ca828111bd94d4e6a96c75e8b048>(),
            params: array::ArrayTrait::new(),
        }
    }

    fn should_update(self: @Strategy) -> bool {
        *self
            .address != contract_address_const::<0xf2cda9b13ed04e585461605c0d6e804933ca828111bd94d4e6a96c75e8b048>()
    }
}

// TODO: find a way for "Strings"
impl NoUpdateArray<T> of NoUpdateTrait<Array<T>> {
    fn no_update() -> Array<T> {
        array::ArrayTrait::<T>::new()
    }

    fn should_update(self: @Array<T>) -> bool {
        self.len() != 0
    }
}


impl UpdateSettingsCalldataImpl of UpdateSettingsCalldataTrait {
    fn default() -> UpdateSettingsCalldata {
        UpdateSettingsCalldata {
            min_voting_duration: NoUpdateU64::no_update(),
            max_voting_duration: NoUpdateU64::no_update(),
            voting_delay: NoUpdateU64::no_update(),
            metadata_URI: NoUpdateArray::no_update(), // TODO: string
            dao_URI: NoUpdateArray::no_update(), // TODO: string
            proposal_validation_strategy: NoUpdateStrategy::no_update(),
            proposal_validation_strategy_metadata_URI: NoUpdateArray::no_update(), // TODO: string
            authenticators_to_add: NoUpdateArray::no_update(),
            authenticators_to_remove: NoUpdateArray::no_update(),
            voting_strategies_to_add: NoUpdateArray::no_update(),
            voting_strategies_metadata_URIs_to_add: NoUpdateArray::no_update(), // TODO: string
            voting_strategies_to_remove: NoUpdateArray::no_update(),
        }
    }
}
