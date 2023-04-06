// Strong contract is protected from re-entrancy using transfer function and mutex.
// I also ensured that all logic that changes state happend before any external call

contract Strong {
    // initialise the mutex
    bool reEntracyMutex = false;
    uint256 public withdrawalLimit = 1 ether;
    mapping(address => uint256) public lastWithdrawTime;
    mapping(address => uint256) public balances;

    function depositFunds() public payable {
        balances[msg.sender] += msg.sender;
    }

    function withdrawFunds(uint256 _weiToWithdraw) public {
        require(!reEntracyMutex);
        require(balances[msg.sender] >= _weiToWithdraw);
        // limit the withdrwal
        require(_weiToWithdraw <= withdrawalLimit);
        // limit the time allowed to withdraw
        require(now >= lastWithdrawTime[msg.sender] + 1 weeks);
        balances[msg.sender] -= _weiToWithdraw;
        lastWithdrawTime[msg.sender] = now;
        // set the reEntrancy mutex before the external call
        reEntrancyMutex = true;
        msg.sender.transfer(_weiToWithdraw);
        // release the mutex after the external call
        reEntrancyMutex = false;
    }
}