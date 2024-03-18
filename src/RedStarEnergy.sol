// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract RedStarEnergy is
    Initializable,
    UUPSUpgradeable,
    ERC20Upgradeable,
    OwnableUpgradeable
{
    IERC20 public UPTToken;
    uint256 public swapRate;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    event Swap(address indexed from, uint256 amount, uint256 rate);
    event Burn(address indexed from, uint256 amount);

    function initialize(address _UPTToken) public initializer {
        __ERC20_init("Red Star Energy", "RSE");
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();

        UPTToken = IERC20(_UPTToken);
        swapRate = 2e18;
    }

    function decimals() public view virtual override returns (uint8) {
        return 0;
    }

    // swap 2e18 UPT for 1 RSE
    function swap(uint256 amount) public {
        require(
            UPTToken.transferFrom(msg.sender, address(this), amount),
            "UPT transfer failed"
        );
        // limit the amount to be multiplied by the swap rate
        require(amount % swapRate == 0, "Invalid amount");

        _mint(msg.sender, amount / swapRate);

        emit Swap(msg.sender, amount, swapRate);
    }

    function setSwapRate(uint256 _swapRate) public onlyOwner {
        swapRate = _swapRate;
    }

    function _update(
        address from,
        address to,
        uint256 value
    ) internal virtual override {
        // Prevent transfers by checking if the token already has an owner (not minting) and not burning
        if (from != address(0) && to != address(0)) {
            revert("Transfers are disabled");
        }

        return super._update(from, to, value);
    }

    function burnFrom(address from, uint256 amount) public returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, amount);
        _burn(from, amount);

        emit Burn(from, amount);

        return true;
    }

    // withdraw any ERC20 token from the contract
    function withdrawERC20(address tokenAddress) public onlyOwner {
        IERC20 token = IERC20(tokenAddress);
        uint256 balance = token.balanceOf(address(this));
        token.transfer(owner(), balance);
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}
}
