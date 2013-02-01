Exploring the BullRunner/Syncromatics API
==

Core Stuff
--

- `/Region/0/Routes` List all routes
- `/Route/428/` Information on a route
- `/Route/426/Direction/0/stops` All stops on a route 
- `/Route/428/Stop/95964/Arrivals` Arrival times for a specific stop 
	- Sometimes with ?customerID=3

Extra Stuff
--

- `/Home/GetBuildingOverlays` Returns an empty array
- `/home/settings` Map settings
- `/Home/GetPortalInformation` Used to populate the client side webapp with data specific to the customer
- `/api/nearbystops/28.0656563836558/-82.4112689495087` Finds nearby stops. Uses https://github.com/ServiceStack/ServiceStack/wiki.