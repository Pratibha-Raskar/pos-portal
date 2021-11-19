// This contract is not supposed to be used in production
// It's strictly for testing purpose

pragma solidity 0.6.6;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {NativeMetaTransaction} from "../../common/NativeMetaTransaction.sol";
import {ContextMixin} from "../../common/ContextMixin.sol";

contract DummyERC20 is
    ERC20,
    NativeMetaTransaction,
    ContextMixin
{
    uint8 private constant GAME_INDEX = 0;
    uint8 private constant STAKING_INDEX = 1;
    uint8 private constant COMMUNITY_INDEX = 2;
    uint8 private constant CORE_TEAM_INDEX = 3;
    uint8 private constant PRIVATE_SALE_INDEX = 4;
    uint8 private constant PUBLIC_SALE_INDEX = 5;
    uint8 private constant INVALID_INDEX = 6;

    uint256[7] private _pools_amount = [
        450 * 10**(8 + 18), // gaming rewards 30%
        345 * 10**(8 + 18), // staking rewards 23%
        150 * 10**(8 + 18), //community funds 10 %
        330 * 10**(8 + 18), //core team 22%
        165 * 10**(8 + 18),  //public sale  11%
        60 * 10**(8 + 18)    //private sale  4%
    ];

    bool[6] public _minted_pool;
    address private _owner;
       constructor(
        address game,
        address stake,
        address community,
        address team
    ) public ERC20("klarii", "klarii") {
        require(game != address(0), "klariiToken: ZERO ADDRESS");
        require(stake != address(0), "klariiToken: ZERO ADDRESS");
        require(community != address(0), "klariiToken: ZERO ADDRESS");
        require(team != address(0), "klariiToken: ZERO ADDRESS");
        _owner = msg.sender;

        _mint(game, _pools_amount[GAME_INDEX]);
        _minted_pool[GAME_INDEX] = true;

        _mint(stake, _pools_amount[STAKING_INDEX]);
        _minted_pool[STAKING_INDEX] = true;

        _mint(community, _pools_amount[COMMUNITY_INDEX]);
        _minted_pool[COMMUNITY_INDEX] = true;
        
        _mint(team, _pools_amount[CORE_TEAM_INDEX]);
        _minted_pool[CORE_TEAM_INDEX] = true;

        _minted_pool[PRIVATE_SALE_INDEX] = false;
        _minted_pool[PUBLIC_SALE_INDEX] = false;
    }

    function addLocker(uint8 pool_index, address pool_address) external {
        require(msg.sender == _owner);
        require(pool_address != address(0), "klariiToken: ZERO ADDRESS");
        require(pool_index >= PRIVATE_SALE_INDEX);
        require(pool_index <= PUBLIC_SALE_INDEX);
        require(_minted_pool[pool_index] == false);

        _mint(pool_address, _pools_amount[pool_index]);
        _minted_pool[pool_index] = true;
    }
    /*
    constructor(string memory name_, string memory symbol_)
        public
        ERC20(name_, symbol_)
    {
        uint256 amount = 10**10 * (10**18);
        _mint(_msgSender(), amount);
        _initializeEIP712(name_);
    }

    function mint(uint256 amount) public {
        _mint(_msgSender(), amount);
    }

    function _msgSender()
        internal
        override
        view
        returns (address payable sender)
    {
        return ContextMixin.msgSender();
    }*/
}
