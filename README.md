# shape - triangle

[![Build Status](https://travis-ci.org/blt/beat.png)](https://travis-ci.org/blt/beat)

> How did you approach solving this problem?

I tried to create the best automated environment around the requested feature.

Using [Packer](http://www.packer.io/) to create the baseline Erlang OTP vm, [Ansible](http://www.ansible.com/) and [Ansible-Galaxy](https://galaxy.ansible.com/) to provision the vm, finally [Vagrant](http://www.vagrantup.com/) and [Vagrant Cloud](https://vagrantcloud.com/) to share it.

It doesn't matter the puzzle this project aims to solve, you can reuse everything for your next Erlang OTP prototype.


> How did you check that your solution is correct?

I wrote unit tests in case of valid and invalid input.

And a property based unit test executing 1000 smart iterations of the feature using [QuickCheck](http://www.quviq.com/index.html), in case of bug, QuickCheck will shrink to show you the minimum input set you need to reproduce it.

`apps/triangle/src/triangle.erl`

Tests are near the code they test, they are the primary documentation of the module and when the code changes it should be straightforward to update them. 
> Specify any assumptions that you have made

1. is_triangle/3 accepts integers > 0 or floats > 0
2. is_triangle/3 raises a bad arguments exception in the other cases
3. it takes some time to download the Vagrant Cloud Erlang OTP baseline vm from Amazon S3   

## Quick Start

To be up and running you need:

- [Vagrant >= 1.5.3](https://www.vagrantup.com/downloads.html)
- [VirtualBox >= 4.3.6](https://www.virtualbox.org/wiki/Downloads)
- [Git >= 1.8.5.2](http://git-scm.com/downloads)

Start the env:

```
> vagrant up
> vagrant ssh
>> cd /vagrant
```
Run the tests, check the types and get the docs:

```
>> make test
```
```
> open apps/triangle/.eunit/index.html
```
```
>> make dialyze
>> make doc
```
Roll a release:

```
>> make release
```
Enjoy the triangles:

```
>> _rel/bin/shape console
>>> triangle:is_triangle(1, 1.0, 1).
>>> triangle:is_triangle(1, 1.5, 0.2).
```

&gt; *host machine* <br/>
&gt;&gt; *guest machine* <br/>
&gt;&gt;&gt; *erlang shell on the guest machine* <br/>
