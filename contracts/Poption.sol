pragma solidity ^0.6.2;
pragma experimental ABIEncoderV2;


// TO DO - check send funding using require for out of gas errors etc
// TO DO - change all units to ether from wei

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


Contract Poption is ERC20{

    using SafeMath for uint;

    uint distributableSupply = 100000000 * (10 ** 18);  // when this many tokens are issued, the issuance drops to 1 token per review
    uint preMine = 5000000 * (10 ** 18);
    uint i = 0; //to use in loops 

    address payable owner;
    uint poolSize;
    uint collateralInPool;
    uint poptionId = 0;
    uint baseFee; //this is 30bps, the LP fee for uniswap, may be 25bps in the future
    uint premium;

    struct LPs{
      uint depositAmount;
      uint poolShare;
    }

    struct poptionsBought{
      address buyerAddress;
      uint collateral;
      address pairAddress;
      uint strike;
      uint term;
      uint numberBought; 
    }

    mapping(address => LPs) public LPsMapping;
    mapping(uint => poptionsBought) public trades;

    uint totalTokenSupply; // running count of total supply so far
     
    constructor() public ERC20("Rater", "RATE") {
        owner = msg.sender;
        _mint(msg.sender, preMine);
    }
 
    // deposit eth into a pool
      // this needs to be checked for failure using require
      function sendFunds() payable {
        
        // add funds to the pool
        owner.send(msg.value);

        poolSize = poolSize + msg.value;
        LPsMapping[msg.sender].depositAmount =  LPsMapping[msg.sender].depositAmount + msg.value;
     
        // LPs share of the pool as a percentage
        LPsMapping[msg.sender].poolShare = LPsMapping[msg.sender].depositAmount.div(poolSize).mul(100);
         
        stakers.push(msg.sender); 
      }

    // retrieve eth from pool      
      function retrieveFunds(address _retriever) payable{

        _retriever.send(poolSize.mul(LPsMapping[_retriever].poolShare);

      }

   

   // buy a poption on a contract
      // example oracle to get uniswap TWAP https://github.com/Uniswap/uniswap-v2-periphery/blob/master/contracts/examples/ExampleOracleSimple.sol
     function buyPoption(address _buyer, address _pairAddress, uint _amount, uint _term, uint _strike){
       
       poptionId = poptionId + 1;
       trades[poptionId].collateral = _strike.sub(oracle.price(_pairAddress));
       trades[poptionId].pairAddress = _pairAddress;
       trades[poptionId].strike = _strike;
       trades[poptionId].term = _term
       trades[poptionId].numberBought = _amount.div(trades[_buyer].collateral);
       trades[poptionId].buyerAddress = _buyer;

       // send fees to the pool (these can not be withdrawn but are "held" in escrow)
       owner.send(trades[poptionId].collateral);
       collateralInPool = collateralInPool + trades[poptionId].collateral;  
      
     }  

   // payout on a poption
    function payoutPoption(uint _id) {

      if(trades[_buyer].term > globalTime){
        if(chainlinkAPI() >= trades[_id].strike){ 
          uint rebate;
          rebate =  baseFee.mul(oracle.cumulativeVolume(_pairAddress))
          premium = trades[_id].strike.div(100);
          trades[_id].buyerAddress.send(trades[_id].collateral - rebate + premium)
        } 
      }    
    
    }

  // chainlink API, periodically check the price and volume from uniswap for a given period
    // perhaps use keeper to do this automatically in the future
    function chainlinkAPI(address _pairAddress) returns (uint) {
      
      // get the current price for a given pair
      return price 

    }

// share fees with poption holders
  // a portion of the fee is available to poption holders to be claimed

}