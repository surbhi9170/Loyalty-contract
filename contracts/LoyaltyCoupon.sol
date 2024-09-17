// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract LoyaltyCoupon {

    struct Coupon {
        uint256 id;
        address admin;
        address user;
        uint256 discountAmount;
        bool isRedeemed;
    }

    struct Organization {
        address admin;
        string name;
    }

    mapping(uint256 => Coupon) public coupons;
    mapping(address => Organization) public organizations;
    address[] public organizationList; 
    uint256 public couponCounter;
    mapping(address => uint256[]) public userCoupons;
    
    event OrganizationCreated(address indexed admin, string name);
    event CouponCreated(uint256 couponId, address indexed admin, uint256 discountAmount);
    event CouponClaimed(uint256 couponId, address indexed user);
    event CouponRedeemed(uint256 couponId, address indexed user);

    modifier onlyAdmin(address orgAddress) {
        require(organizations[orgAddress].admin == msg.sender, "Only the admin can perform this action");
        _;
    }

    modifier orgExists(address orgAddress) {
        require(organizations[orgAddress].admin != address(0), "Organization does not exist");
        _;
    }

    // Create an organization
    function createOrganization(string memory name) external {
        require(organizations[msg.sender].admin == address(0), "Organization already exists for this address");
        organizations[msg.sender] = Organization({
            admin: msg.sender,
            name: name
        });
        organizationList.push(msg.sender); // Add the organization admin to the list
        emit OrganizationCreated(msg.sender, name);
    }

    // Admin creates a coupon
    function createCoupon(uint256 discountAmount) external {
        require(organizations[msg.sender].admin == msg.sender, "Only the organization admin can create coupons");

        couponCounter++;
        coupons[couponCounter] = Coupon({
            id: couponCounter,
            admin: msg.sender,
            user: address(0),
            discountAmount: discountAmount,
            isRedeemed: false
        });

        emit CouponCreated(couponCounter, msg.sender, discountAmount);
    }

    // User claims a coupon
    function claimCoupon(uint256 couponId) external orgExists(coupons[couponId].admin) {
        require(coupons[couponId].user == address(0), "Coupon is already claimed");
        
        coupons[couponId].user = msg.sender;
        userCoupons[msg.sender].push(couponId);
        emit CouponClaimed(couponId, msg.sender);
    }

    // User redeems a coupon
    function redeemCoupon(uint256 couponId) external {
        require(coupons[couponId].user == msg.sender, "You are not the owner of this coupon");
        require(!coupons[couponId].isRedeemed, "Coupon already redeemed");

        coupons[couponId].isRedeemed = true;
        emit CouponRedeemed(couponId, msg.sender);
    }

    // Get coupons for a specific user
    function getUserCoupons(address user) external view returns (uint256[] memory) {
        return userCoupons[user];
    }

    // Function to view all organizations
    function getAllOrganizations() external view returns (Organization[] memory) {
        Organization[] memory orgs = new Organization[](organizationList.length);
        for (uint256 i = 0; i < organizationList.length; i++) {
            orgs[i] = organizations[organizationList[i]];
        }
        return orgs;
    }
}
