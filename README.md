# macos-cookbook

## Resources

### systemsetup

The systemsetup resource wraps the `/usr/sbin/systemsetup` tool and can be used in 
almost exactly the same way as it is used on the command line.
 
 
Example usage:

```ruby
systemsetup 'keep machine awake indefinitely' do
   settings remotelogin: 'On',
            waitforstartupafterpowerfailure: 0,
            displaysleep: 0
end
```
#### Available settings to use with the `systemsetup` resource:

    date <mm:dd:yy>
    time <hh:mm:ss>
    timezone <timezone>
    usingnetworktime <on off>
    networktimeserver <timeserver>
    sleep <minutes>
    computersleep <minutes>
    displaysleep <minutes>
    harddisksleep <minutes>
    wakeonmodem <on off>
    wakeonnetworkaccess <on off>
    restartpowerfailure <on off>
    restartfreeze <on off>
    allowpowerbuttontosleepcomputer <on off>
    remotelogin <on off>
    remoteappleevents <on off>
    computername <computername>
    localsubnetname <name>
    startupdisk <disk>
    waitforstartupafterpowerfailure <seconds>
    disablekeyboardwhenenclosurelockisengaged <yes no>
