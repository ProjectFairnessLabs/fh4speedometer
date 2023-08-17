Config                            = {}
Config.pf_vmenu_intergration = true
Config.RefreshSpeed = 5 --(ms) how fast it refreshes the speedometer
Config.MinFramerate = 50 --(fps) min fps before it will start to slow down the refresh speed of the speedometer
Config.vehicleRPM ={ -- (rpm scale) the scale of the tachometer on the speedometer (only used if you want to set rpm ranges for different vehicles)
    [GetHashKey('omnis')] =  {"0,1,2,3,4,5,6,7,8", 0.8, 0.1}, -- german i4 Example ([1] = rpm scale, [2] = max rpm on that scale by %, [3] = idle adjust)
    [GetHashKey('blade')] =  {"0,1,2,3,4,5,6", 0.83, 0.1}, -- old school american v8 example
    [GetHashKey('gauntlet4')] =  {"0,1,2,3,4,5,6,7,8", 0.811, 0.1}, -- new american v8 example    


}


