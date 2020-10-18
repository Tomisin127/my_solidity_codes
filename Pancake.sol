pragma solidity >=0.4.22 < 0.7.0;

interface of_a_cake_baker{
    
    // total supply of cake is determined by the utils available
    
    function cake_produced(address of_chef) external view returns(uint256);
    function eat_cake(address of_chef, address of_the_consumer) external view returns (uint256);
    function gift_a_cake(address of_cake_reciever, uint256 amount_of_cake)external returns(bool);
    function chef_choice_to_release_cake_to_(address of_consumer,uint256 amount_of_cake)external returns(bool);

    
}

contract Chef is of_a_cake_baker{
    
    bool cake_delivered_successfully = true;
    
    bool chef_does_not_want_you_to_eat_the_cake = false;
    
    enum colors{WEDDING_WHITE,CRIMSON_ROSE,AQUATIC_BLUE,GREEN_NIGERIA,MOON_CHOCOLATE}
    
    //utils
    
    uint8 fry_pan = 5;
    uint8 spatula = 5;
    uint8 pinches_of_salt = 3;
    uint8 drops_of_oil = 50;
    
    struct Pancake{
        
        string chef_name;
        bytes32 id;
        uint8 cake_baked;
        colors _type;
        
    }
    
    mapping(address=>uint) cake_available;
    
    mapping(address => mapping(address=> uint256)) get_cake_to_consumer;
    
    Pancake[] public chefs;

    function bake_cake(string memory _name_of_chef,uint8 _amount_baked, colors _variant) public
    {
        
        bytes32 _id = chef_id(_name_of_chef);
        
        chefs.push(Pancake(_name_of_chef,_id,_amount_baked,_variant));
        
        uint baked_cake = bakery(_name_of_chef);
        
        cake_available[msg.sender]= baked_cake;
    
        
    }
    
    function bakery(string memory _name) public returns(uint)
    {
        if(fry_pan>0 && spatula>0 && pinches_of_salt>0 &&drops_of_oil>0)
        {
            fry_pan-=1;
            
            spatula-=1;
            
            pinches_of_salt-=1;
            
            uint8 oven = fry_pan *spatula*pinches_of_salt;
            
            uint256 rand = uint256(keccak256(abi.encodePacked(_name)));
            
            uint256 cake_amount = (rand*uint256(oven)) %drops_of_oil;
            
            return cake_amount;
        }
        
        else
        {
            return 0;
        }
        
    }
    
    function chef_id(string memory _name_of_chef) public pure returns(bytes32)
    {
        bytes32 id = keccak256(abi.encode(_name_of_chef));
        
        return id;
    }
    
    function cake_produced(address of_chef) override view public returns(uint256)
    {
        return cake_available[of_chef];
    }
    
    function eat_cake(address of_chef_cake, address of_the_consumer) override view public returns (uint256)
    {
        return get_cake_to_consumer[of_chef_cake][of_the_consumer];
    }
    
    function gift_a_cake(address of_cake_reciever, uint256 amount_of_cake)public override returns(bool)
    {
        require(amount_of_cake<= cake_available[msg.sender]);
        
        cake_available[msg.sender] = cake_available[msg.sender]-amount_of_cake;
        
        cake_available[of_cake_reciever]= cake_available[of_cake_reciever]+amount_of_cake;
        
        return cake_delivered_successfully;
        
    }
    
    function chef_choice_to_release_cake_to_(address of_consumer,uint256 amount_of_cake)override public returns(bool)
    {
        get_cake_to_consumer[msg.sender][of_consumer] = amount_of_cake;
        
        return cake_delivered_successfully;        
        
    }
    

}