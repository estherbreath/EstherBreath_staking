

-staking contract name"estherbreath" and symbol "EBT"
-It will serve as a reward token, using the ERC20 token standard.
it should implement the following;
-An option for auto compounding and non auto compounding options which will be set to a bool.  
- accept only eth which is converted to Weth  
- stored the eth in the contract as deposit.
- Calculated token reward thus: APR of 14% at 1:10 to 1 eth. (break it down to months and to seconds)
-reward (estherbreath token) should be minted automatically to depositor, based on the percentage calculated above.
- At withdrawal, the earned token should be automatically coverted back Weth using 1:10 ratio.
_auto compounding rate of  1%  fee monthly should be removed from any user who triggers auto compound, 
-The reward(1% at 1:10) and principal should be staked back as principal for an auto compound user. let the percentage be calculation be broken down up to second  
-minimum staking period should be for 1 month.
-have customised error checks and necessary require statements.
