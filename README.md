# macos-cookbook

## Resources

### systemsetup

The systemsetup resource is a wrapper for `/usr/sbin/systemsetup`. Use the `get` and `set` properties with hashes or
strings in order to get or set the desired setting.
 
 
Example "set" usage:

```ruby
systemsetup 'keep awake and get time information' do
  set sleep: 0,
      computersleep: 0,
      displaysleep: 0,
      harddisksleep: 0
  get %w(networktimeserver timezone)
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
