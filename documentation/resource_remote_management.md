remote_management
===

Use the **remote_management** resource to manage the "Remote Management" settings in System Preferences > Sharing > Remote Management. Under the hood, the [remote_management](../resources/remote_management.rb) resource utilizes the [kickstart](https://ss64.com/osx/kickstart.html) script.

Syntax
------

```ruby
remote_management 'configure remote management' do
  users         [String, Array]           
  privileges    [String, Array] 
  computer_info [String, Array]          
end
```

Properties
-------

* `users`
  * **Description:** the user(s) whoose ARD privileges will be configured.
  * **Usage:** a single user can be specified in the form of a string, or multiple users can be specified as an array of strings. Specifying 'all' is a special case; all local users will be configured.
  * **Default:** `'all'`
    * Privileges will be configured for all local users.
  * **Constraints:** specified users must exist on the system.
  <br></br>

* `privileges`
  * **Description:** the desired privileges to bestow upon the given user(s).
  **Usage:** a single privilege can be specified in the form of a string, or multiple privileges can be specified as an array of strings.
  * **Default:** `'all'`
  * **Constraints:** the list of optional privileges bellow
    * `all` → grant all privileges (default)
    * `none` → disable all privileges for the specified user
    * `DeleteFiles` → delete files
    * `TextMessages` → send a text message
    * `OpenQuitApp` → open and quit applications
    * `GenerateReport` → generate reports
    * `RestartShutDown` → restart *and/or* shutdown
    * `SendFile` → send *and/or* retrieve files
    * `ChangeSetting` → change system settings
    * `ShowObserve` → show the client when being observed or controlled
    * `ControlObserve` → control AND observe (unless ObserveOnly is also specified)
    * `ObserveOnly` → modify ControlObserve option to allow Observe mode only
  <br></br>
  
* `computer_info`
  * **Description:** Info fields; helpful for stratifying computers in the ARD client app.
  * **Usage** a single info field can be added as a string, or multiple info fields can be added as an array of strings. 
  * **Default:** `[]`
    * No info fields will be added.
  * **Constraints:** there is a maximum of four info fields allowed.
  
Actions
-------

* `enable`
  * **Description:** activate remote management and configure full privileges for all users on the system.
  * **GUI Equivalent:** activating with the privileges property set to 'all' is equivalent to the following: 
    ![Sharing Preferences](sharing_preferences.png)

* `disable`
  * **Description:** deactivate the remote management agent and prevent it from activating at boot time.
