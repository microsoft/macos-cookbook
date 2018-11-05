# Testing the macOS Cookbook

- [Syntax and style](#syntax-and-style)
- [Unit tests](#unit-tests)
- [Integration tests](#integration-tests)
- [Rake Tasks](#rake-tasks)

## Requirements

- [ChefDK](https://downloads.chef.io/chefdk)
- [Vagrant](https://www.vagrantup.com/)
- [Packer](https://www.packer.io/)
- A supported macOS hypervisor:
  - [Parallels](https://www.parallels.com/landingpage/pd/general/)
  - [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
  - [VMWare Fusion](https://www.vmware.com/products/fusion.html)

## Syntax and style

- `cookstyle` and `foodcritic`

Syntax testing is pretty straight forward. At the root of the cookbook, run:

```shell
cookstyle
foodcritic .
```

## Unit tests

For unit tests, we focus on testing the library files, which are written
in pure Ruby and tested with RSpec. The library files contain most of the core
business logic for each of the custom resources and are used as either mixins
for the custom resources or contain classes that act as helpers, except with
explicit namespacing. Some libary files are heavily unit tested, others are definitely
missing much-needed unit test coverage.

Clone this repo and in the root of the cookbook, run:

```shell
rspec spec
```

To run the unit tests in a specific file:

```shell
rspec spec/unit/libraries/xcode_spec.rb
```

## Integration tests

For integration tests, we test custom resources using a test cookbook, found in
[`test/cookbooks/macos_test`](https://github.com/Microsoft/macos-cookbook/tree/master/test/cookbooks/macos_test).
In general, each of the custom resources is used in a corresponding test recipe,
which is then added to a corresponding suite's runlist. For example, the `xcode`
resource is used in the `xcode.rb` recipe, which is called in the `xcode` suite.
For the specific suite, there are corresponding integration tests as specified
in the suite. Every suite is tested against all three platform version.

### Building a macOS Vagrant Box

Due to Apple's Software License Agreement, you'll need to build your own boxes.
There's a number of different resources on GitHub that provide some really great
guides, but we're partial to [osx-vm-templates](https://github.com/timsutton/osx-vm-templates).

This procedure is a bit of a pain to really nail down. We've been working on
refining and automating it as much as possible, but regular changes to the macOS
operating system by Apple (e.g. signing restrictions introduced in 10.12.3) have
made this challenging.

Read the [osx-vm-templates README](https://github.com/timsutton/osx-vm-templates/blob/master/README.md)
thouroughly to get a clear understanding of what needs to be done to turn a "vanilla"
macOS installer into a shiny new, barely-touched macOS Vagrant base box. The process
is pretty different depending on which version you're building, so tread lightly.

It should be noted that we also maintain a [fork of osx-vm-templates](https://github.com/americanhanko/osx-vm-templates)
that contains a revised README and better support for building Parallels Desktop
Vagrant boxes. We're working on getting those changes implemented, but there is
a few issues that need to be addressed before doing so.

### Running the tests

Once you have finished building and "adding" your box (with `vagrant box add`),
you'll need to modify the `.kitchen.yml`. The only modifications you should
need to make are replacing our box names with yours. For example, you would
replace `apex/macos-10.13.6` with `my_high_sierra_box`. To double check the
available boxes and their names, execute `vagrant box list`. For example:

```shell
$ vagrant box list
apex/macos-10.12.6 (parallels, 2.0.0)
apex/macos-10.13.6 (parallels, 1.1.0)
```

Next, make sure you're in the macOS cookbook root and run `kitchen list` to view
the available instances. It should look something like this:

```shell
$ kitchen list
Instance                      Driver   Provisioner  Verifier  Transport  Last Action    Last Error
default-apex-macos-10136      Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
default-apex-macos-10126      Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
xcode-apex-macos-10136        Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
xcode-apex-macos-10126        Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
spotlight-apex-macos-10136    Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
spotlight-apex-macos-10126    Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
certificate-apex-macos-10136  Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
certificate-apex-macos-10126  Vagrant  ChefZero     Inspec    Ssh        <Not Created>  <None>
```

The `kitchen list` command serves as a nearly-perfect way to validate the
`.kitchen.yml` syntax. For more info, check out `kitchen help` for commands and
run `kitchen help COMMAND` for help on a specific subcommand. When you're ready,
run `kitchen test`.

```shell
kitchen test
```

`kitchen` supports using regular expressions to only run a specific instance.
For example:

```shell
kitchen test xcode # test the xcode suite on all versions
kitchen test default.*101[23] # only test default suites on 10.12 and 10.13
```

macOS takes a little while to boot and the suites themselves (especially Xcode)
can take a while to run - some of our builds end up being 30-40 minutes per operating
system. If you've got the hardware, don't be afraid to run
`kitchen test --concurrency n` to save a little time (where `n` is the number of concurrent
instances you want to boot up).

## Rake Tasks

Included are some convenient rake tasks for running particular batteries of tests. Just run `rake` to see a list of tasks available.

### Continuous testing with guard

We've included a Guardfile custom-tailored to run the appropriate unit tests whenever a file is modified. To get started, simply `bundle install && rake test:guard` and watch the appropriate tests run automatically as you edit source files!
