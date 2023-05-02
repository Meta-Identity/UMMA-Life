// SPDX-License-Identifier: MIT

// Total token amount = 290000000000000000000000000  // 290 Million * 1e18

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./DateTimeLibrary.sol";

contract Vesting is Ownable {
    using SafeMath for uint256;

    address public marketingPartnerships; // 1 0x067094141F62BC7050eeAa854Dc073e3d22eF608
    address public exchangeListingLiquidity; // 2 0x30d10659F2C2E4E19aE7BB7024269959Ae9f5a9E
    address public researchDevelopment; // 3 0x4586d9FdF82108Fc192a68537f43e23f574F22C3
    address public teamAdvisors; // 4 0xB3cE9CAF4F9e6Ae33A8D66934F14fa7Ccc177690
    address public treasury; // 5 0xb0EF1e58F98A038Fb2923eD4fA9439C9983b7bFA
    address public usersCommunityRewards; // 6 0xfB8b280eeDeF147c4dfca551a94D232a7fe41CAc

    IERC20 public token; // 0x36596A1dC57c695Bed1A063470a7802797Dca133 UMMA Token
    uint256 private constant DECIMALS_MULTIPLIER = 1e18;
    uint256 private constant Millions = 1e6;

    bool public isVestingWalletsSet = false;

    struct VestingSchedule {
        uint256[] _years;
        mapping(uint256 => mapping(uint256 => uint256)) yearToClaimDatesToAmounts;
    }

    mapping(address => VestingSchedule) private schedules;

    constructor(IERC20 _token) {
        token = _token;
    }

    function claim() external {
        VestingSchedule storage schedule = schedules[msg.sender];
        require(schedule._years.length > 0, "No vesting schedule found");

        uint256 totalClaimable = 0;
        uint256 currentYear = _getCurrentYear();
        uint256 currentMonth = _getCurrentMonth();

        for (uint256 i = 0; i < schedule._years.length; i++) {
            uint256 year = schedule._years[i];
            if (year <= currentYear) {
                for (uint256 month = 1; month <= 12; month++) {
                    uint256 claimable = schedule.yearToClaimDatesToAmounts[
                        year
                    ][month];

                    if (
                        claimable > 0 &&
                        (year < currentYear ||
                            (year == currentYear && month <= currentMonth))
                    ) {
                        totalClaimable += claimable;
                        schedule.yearToClaimDatesToAmounts[year][month] = 0;
                    }
                }
            }
        }

        require(totalClaimable > 0, "No claimable tokens found");
        token.transfer(msg.sender, totalClaimable);
    }

    function _getCurrentYear() private view returns (uint256) {
        return DateTimeLibrary.getYear(block.timestamp);
    }

    function _getCurrentMonth() private view returns (uint256) {
        return DateTimeLibrary.getMonth(block.timestamp);
    }

    function getFormattedDate() public view returns (string memory) {
        return DateTimeLibrary.formatDate(block.timestamp);
    }

    function getClaimableAmount(address _beneficiary)
        public
        view
        returns (uint256)
    {
        VestingSchedule storage schedule = schedules[_beneficiary];
        uint256 totalClaimableAmount = 0;
        uint256 currentYear = _getCurrentYear();
        uint256 currentMonth = _getCurrentMonth();

        for (uint256 i = 0; i < schedule._years.length; i++) {
            uint256 year = schedule._years[i];

            if (year < currentYear) {
                // If the year is in the past, add all amounts for that year
                for (uint256 month = 1; month <= 12; month++) {
                    totalClaimableAmount += schedule.yearToClaimDatesToAmounts[
                        year
                    ][month];
                }
            } else if (year == currentYear) {
                // If the year is the current year, add all amounts up to the current month
                for (uint256 month = 1; month <= currentMonth; month++) {
                    totalClaimableAmount += schedule.yearToClaimDatesToAmounts[
                        year
                    ][month];
                }
            } else {
                // If the year is in the future, do not add any amounts
                break;
            }
        }

        return totalClaimableAmount;
    }

    function setVestingWallets(
        address _mP,
        address _eL,
        address _rD,
        address _tA,
        address _t,
        address _uCR
    ) external onlyOwner {
        require(isVestingWalletsSet == false, "Vesting is set already");
        require(
            _mP != address(0x0) ||
                _eL != address(0x0) ||
                _rD != address(0x0) ||
                _tA != address(0x0) ||
                _t != address(0x0) ||
                _uCR != address(0x0),
            "Address zero!"
        );

        marketingPartnerships = _mP;
        exchangeListingLiquidity = _eL;
        researchDevelopment = _rD;
        teamAdvisors = _tA;
        treasury = _t;
        usersCommunityRewards = _uCR;
        isVestingWalletsSet = true;
        setSchedules();
    }

    function setSchedules() private {
        // marketingPartnerships

        schedules[marketingPartnerships]._years.push(2023);
        schedules[marketingPartnerships]._years.push(2024);
        schedules[marketingPartnerships]._years.push(2025);
        schedules[marketingPartnerships]._years.push(2026);
        schedules[marketingPartnerships]._years.push(2027);
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2023][1] =
            11 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2024][1] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2024][7] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2025][1] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2025][7] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2026][1] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2026][7] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2027][1] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[marketingPartnerships].yearToClaimDatesToAmounts[2027][7] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;

        // exchangeListingLiquidity

        schedules[exchangeListingLiquidity]._years.push(2023);
        schedules[exchangeListingLiquidity]._years.push(2024);
        schedules[exchangeListingLiquidity]._years.push(2025);
        schedules[exchangeListingLiquidity]._years.push(2026);
        schedules[exchangeListingLiquidity].yearToClaimDatesToAmounts[2023][1] =
            20 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[exchangeListingLiquidity].yearToClaimDatesToAmounts[2024][7] =
            10 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[exchangeListingLiquidity].yearToClaimDatesToAmounts[2025][7] =
            10 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[exchangeListingLiquidity].yearToClaimDatesToAmounts[2026][7] =
            10 *
            Millions *
            DECIMALS_MULTIPLIER;

        // researchDevelopment

        schedules[researchDevelopment]._years.push(2024);
        schedules[researchDevelopment]._years.push(2025);
        schedules[researchDevelopment]._years.push(2026);
        schedules[researchDevelopment]._years.push(2027);
        schedules[researchDevelopment].yearToClaimDatesToAmounts[2024][7] =
            13 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[researchDevelopment].yearToClaimDatesToAmounts[2025][7] =
            13 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[researchDevelopment].yearToClaimDatesToAmounts[2026][7] =
            12 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[researchDevelopment].yearToClaimDatesToAmounts[2027][7] =
            12 *
            Millions *
            DECIMALS_MULTIPLIER;

        // teamAdvisors

        schedules[teamAdvisors]._years.push(2024);
        schedules[teamAdvisors]._years.push(2025);
        schedules[teamAdvisors]._years.push(2026);
        schedules[teamAdvisors]._years.push(2027);
        schedules[teamAdvisors].yearToClaimDatesToAmounts[2024][1] =
            4 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[teamAdvisors].yearToClaimDatesToAmounts[2024][7] =
            4 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[teamAdvisors].yearToClaimDatesToAmounts[2025][1] =
            6 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[teamAdvisors].yearToClaimDatesToAmounts[2025][7] =
            6 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[teamAdvisors].yearToClaimDatesToAmounts[2026][1] =
            7 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[teamAdvisors].yearToClaimDatesToAmounts[2026][7] =
            7 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[teamAdvisors].yearToClaimDatesToAmounts[2027][1] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[teamAdvisors].yearToClaimDatesToAmounts[2027][7] =
            8 *
            Millions *
            DECIMALS_MULTIPLIER;

        // treasury

        schedules[treasury]._years.push(2025);
        schedules[treasury]._years.push(2026);
        schedules[treasury]._years.push(2027);
        schedules[treasury].yearToClaimDatesToAmounts[2025][7] =
            5 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[treasury].yearToClaimDatesToAmounts[2026][7] =
            10 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[treasury].yearToClaimDatesToAmounts[2027][7] =
            25 *
            Millions *
            DECIMALS_MULTIPLIER;

        // usersCommunityRewards

        schedules[usersCommunityRewards]._years.push(2023);
        schedules[usersCommunityRewards]._years.push(2024);
        schedules[usersCommunityRewards]._years.push(2025);
        schedules[usersCommunityRewards]._years.push(2026);
        schedules[usersCommunityRewards]._years.push(2027);
        schedules[usersCommunityRewards].yearToClaimDatesToAmounts[2023][1] =
            5 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[usersCommunityRewards].yearToClaimDatesToAmounts[2024][7] =
            5 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[usersCommunityRewards].yearToClaimDatesToAmounts[2025][7] =
            5 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[usersCommunityRewards].yearToClaimDatesToAmounts[2026][7] =
            5 *
            Millions *
            DECIMALS_MULTIPLIER;
        schedules[usersCommunityRewards].yearToClaimDatesToAmounts[2027][7] =
            5 *
            Millions *
            DECIMALS_MULTIPLIER;
    }
}


                /*********************************************************
                  Proudly Developed by MetaIdentity ltd. Copyright 2023
                **********************************************************/
