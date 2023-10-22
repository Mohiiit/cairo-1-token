#[starknet::contract]
mod MyToken {
    use starknet::ContractAddress;
    use openzeppelin::token::erc20::ERC20;

    #[storage]
    struct Storage {
        // The decimals value is stored locally
        _decimals: u8,
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        decimals: u8
    ) {
        // Call the internal function that writes decimals to storage
        self._set_decimals(decimals);

        // Initialize ERC20
        let name = 'MyToken';
        let symbol = 'MTK';

        let mut unsafe_state = ERC20::unsafe_new_contract_state();
        ERC20::InternalImpl::initializer(ref unsafe_state, name, symbol);
    }

    /// This is a standalone function for brevity.
    /// It's recommended to create an implementation of IERC20
    /// to ensure that the contract exposes the entire ERC20 interface.
    /// See the previous example.
    #[external(v0)]
    fn decimals(self: @ContractState) -> u8 {
        self._decimals.read()
    }

    #[generate_trait]
    impl InternalImpl of InternalTrait {
        fn _set_decimals(ref self: ContractState, decimals: u8) {
            self._decimals.write(decimals);
        }
    }
}