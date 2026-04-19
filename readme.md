# Target options for "QBOX" using default framework functions

## Player Target Options
- Cuff Player         'police:client:CuffPlayer'
- Rob Player          'police:client:RobPlayer'
- Escort Player       'police:client:EscortPlayer'
- Kidnap Player       'police:client:KidnapPlayer'
- Take Hostage        'police:client:TakeHostage'
- Check Health Status 'hospital:client:CheckStatus'
- Revive Player       'hospital:client:RevivePlayer'
- Treat Wounds        'hospital:client:TreatWounds'

## Vehicle Target Options
- Seat In Vehicle         'police:client:PutPlayerInVehicle'
- Unseat From Vehicle     'police:client:SetPlayerOutVehicle'
- Get In Trunk            'qb-trunk:client:GetIn'
- Unlock Vehicle (Police) 'qb-vehiclekeys:server:setVehLockState'


# Install
## Add to your resourses folder
## Ensure it starts after 'ox_lib' and 'ox_target'

# Required
## Qbcore or Qbox Framework obviously guys
## ox_lib    https://github.com/overextended/ox_lib
## ox_target https://github.com/overextended/ox_target 