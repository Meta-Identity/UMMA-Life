// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

pragma solidity 0.8.19;

library DateTimeLibrary {
    using SafeMath for uint256;

    uint256 constant SECONDS_PER_DAY = 24 * 60 * 60;
    uint256 constant SECONDS_PER_YEAR = SECONDS_PER_DAY * 365;
    uint256 constant SECONDS_PER_LEAP_YEAR = SECONDS_PER_DAY * 366;

    function isLeapYear(uint256 year) internal pure returns (bool) {
        return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
    }

    function daysInMonth(uint256 month, bool leap)
        internal
        pure
        returns (uint16)
    {
        if (month == 2 && leap) {
            return 29;
        } else if (month == 2) {
            return 28;
        } else if (month == 4 || month == 6 || month == 9 || month == 11) {
            return 30;
        } else {
            return 31;
        }
    }

    function getYear(uint256 timestamp) internal pure returns (uint256) {
        uint256 year = 1970;
        uint256 secondsAccountedFor = 0;
        uint256 remainingSeconds = timestamp;

        while (remainingSeconds >= SECONDS_PER_YEAR) {
            secondsAccountedFor += SECONDS_PER_YEAR;
            remainingSeconds -= SECONDS_PER_YEAR;
            year += 1;
        }

        return year;
    }

    function getMonth(uint256 timestamp) internal pure returns (uint256) {
        uint256 year = getYear(timestamp);
        uint256 leapYears = (year - 1970) /
            4 -
            (year - 1970) /
            100 +
            (year - 1970) /
            400;
        uint256 totalLeapYearSeconds = leapYears * SECONDS_PER_LEAP_YEAR;
        uint256 totalRegularYearSeconds = (year - 1970 - leapYears) *
            SECONDS_PER_YEAR;
        uint256 secondsAccountedFor = totalRegularYearSeconds +
            totalLeapYearSeconds;
        uint256 remainingSeconds = timestamp - secondsAccountedFor;
        uint256 month = 1;
        uint256 _days;

        while (
            remainingSeconds >=
            SECONDS_PER_DAY * daysInMonth(month, isLeapYear(year))
        ) {
            _days = daysInMonth(month, isLeapYear(year));
            remainingSeconds -= SECONDS_PER_DAY * _days;
            month += 1;
        }

        return month;
    }

    function getDay(uint256 timestamp) internal pure returns (uint256) {
        uint256 year = getYear(timestamp);
        uint256 leapYears = (year - 1970) /
            4 -
            (year - 1970) /
            100 +
            (year - 1970) /
            400;
        uint256 totalLeapYearSeconds = leapYears * SECONDS_PER_LEAP_YEAR;
        uint256 totalRegularYearSeconds = (year - 1970 - leapYears) *
            SECONDS_PER_YEAR;
        uint256 secondsAccountedFor = totalRegularYearSeconds +
            totalLeapYearSeconds;
        uint256 remainingSeconds = timestamp - secondsAccountedFor;
        uint256 month = 1;
        uint256 _days;

        while (
            remainingSeconds >=
            SECONDS_PER_DAY * daysInMonth(month, isLeapYear(year))
        ) {
            _days = daysInMonth(month, isLeapYear(year));
            remainingSeconds -= SECONDS_PER_DAY * _days;
            month += 1;
        }

        uint256 day = remainingSeconds / SECONDS_PER_DAY + 1;
        return day;
    }

    function formatDate(uint256 timestamp)
        internal
        pure
        returns (string memory)
    {
        uint256 year = getYear(timestamp);
        uint256 month = getMonth(timestamp);
        uint256 day = getDay(timestamp);
        string[12] memory months = [
            "January",
            "February",
            "March",
            "April",
            "May",
            "June",
            "July",
            "August",
            "September",
            "October",
            "November",
            "December"
        ];
        string memory monthStr = months[month - 1];
        return
            string(
                abi.encodePacked(
                    monthStr,
                    " ",
                    uintToString(day),
                    ", ",
                    uintToString(year)
                )
            );
    }

    function uintToString(uint256 value) private pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + (value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

                /*********************************************************
                  Proudly Developed by MetaIdentity ltd. Copyright 2023
                **********************************************************/
