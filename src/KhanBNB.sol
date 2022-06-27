pragma solidity >=0.4.22 <0.9.0;

contract KhanBNB
{
    address public owner;
    uint256 private counter;

    struct rentalInfo
    {
        string name;
        string city;
        string lat;
        string long;
        string unoDescription;
        string dosDescription;
        string imgUrl;
        uint256 maxGuests;
        uint256 pricePerDay;
        string[] datesBooked;
        uint256 id;
        address renter;
    }

    //When a rental is created, an event will be
    //broadcasted.
    event rentalCreated
    (
        string name,
        string city,
        string lat,
        string long,
        string unoDescription,
        string dosDescription,
        string imgUrl,
        uint256 maxGuests,
        uint256 pricePerDay,
        string[] datesBooked,
        uint256 id,
        address renter
    );

    event newDatesBooked
    (
        string[] datesBooked,
        uint256 id,
        address booker,
        string city,
        string imgUrl
    );

    //The rentals created and their info.
    //Id points to rentalInfo struct.
    mapping(uint256 => rentalInfo) rentals;

    //Ids stored in an array.
    uint256[] public rentalIds;

    constructor()
    {
        counter = 0;
        owner = msg.sender;
    }

    //Function to add new rentals to our structs, etc.
    function addRentals(
        string memory name,
        string memory city,
        string memory lat,
        string memory long,
        string memory unoDescription,
        string memory dosDescription,
        string memory imgUrl,
        uint256 maxGuests,
        uint256 pricePerDay,
        string[] memory datesBooked
    ) public
    {
        require(msg.sender == owner, "Only owner of smart contract can place rentals up");
        rentalInfo storage newRental = rentals[counter];
        newRental.name = name;
        newRental.city = city;
        newRental.lat = lat;
        newRental.long = long;
        newRental.unoDescription = unoDescription;
        newRental.dosDescription = dosDescription;
        newRental.imgUrl = imgUrl;
        newRental.maxGuests = maxGuests;
        newRental.pricePerDay = pricePerDay;
        newRental.datesBooked = datesBooked;
        newRental.id = counter;
        newRental.renter = owner;
        rentalIds.push(counter);

        emit rentalCreated
        (
            name, 
            city, 
            lat, 
            long, 
            unoDescription, 
            dosDescription, 
            imgUrl, 
            maxGuests, 
            pricePerDay, 
            datesBooked, 
            counter, 
            owner
        );

        counter++;
    }

    //Check whether rentals have already been booked.
    function checkBookings(uint256 id, string[] memory newBookings) private view returns (bool)
    {
        for (uint i = 0; i < newBookings.length; i++) {
            for (uint j = 0; j < rentals[id].datesBooked.length; j++) {
                //Can't compare between strings so convert to keccack256.
                if (keccak256(abi.encodePacked(rentals[id].datesBooked[j])) == keccak256(abi.encodePacked(newBookings[i]))) {
                    return false;
                }
            }
        }
        return true;
    }

    //Payable because money will be send to the owner in order to rent.
    function addDatesBooked(uint256 id, string[] memory newBookings) public payable
    {
        require(id < counter, "No such rental");
        require(checkBookings(id, newBookings), "Already booked for requested date");
        require(msg.value == (rentals[id].pricePerDay * 0.1 ether * newBookings.length) , "Please submit the asking price in order to complete the purchase");

        //Add new bookings to current mapping.
        for(uint i = 0; i < newBookings.length; i++)
        {
            rentals[id].datesBooked.push(newBookings[i]);
        }

        //Owner of smart contract receives money.
        payable(owner).transfer(msg.value);

        emit newDatesBooked(newBookings, id, msg.sender, rentals[id].city,  rentals[id].imgUrl);
    }

    function getRental(uint256 id) public view returns (string memory, uint256, string[] memory)
    {
        require(id < counter, "No such Rental");

        rentalInfo storage rental = rentals[id];
        return (rental.name, rental.pricePerDay, rental.datesBooked);
    }
}