# psbootstrap
psbootstrap assists in creating files needed to bootstrap a Windows machine for Mozilla fuzz-testing in EC2.

## How to use
Run psbootstrap using Laniakea:

```
# ~/trees/boto-awsfuzz/bin/python -u ~/trees/laniakea/laniakea.py -region=us-east-1 -images ~/trees/laniakea/images.json -create-on-demand -tags Name=<your tag> -image-name <your image name> -ebs-volume-delete-on-termination -ebs-size 320 -userdata userscript.ps1
```
in the psbootstrap directory.

## How to get boto

If you would like to install boto globally, do:

```
pip install --upgrade boto
```

then run using system python.

If you would like to install boto in a virtualenv, and not pollute global python do:

```
virtualenv ~/trees/boto-awsfuzz

~/trees/boto-awsfuzz/bin/pip install --upgrade boto
```

then run using "~/trees/boto-awsfuzz/bin/python" .

To test if this worked, run "python" or "~/trees/boto-awsfuzz/bin/python" then:

```
import boto
```

If there are no errors, then it is working properly.

## Changelog
- [v0.5](https://github.com/MozillaSecurity/psbootstrap/releases/tag/v0.5) (2016-03-26)
  - Bump MozillaBuild to 2.2.0pre3 and Git to 2.7.3
  - Add GitHub FuzzManager repository
  - Switch to archive.mozilla.org from TaskCluster and FTP
  - Download and install LLVM 3.8.0 32-bit
- [v0.4](https://github.com/MozillaSecurity/psbootstrap/releases/tag/v0.4) (2015-09-28)
  - Now intended to be used with Laniakea
  - MozillaBuild 2.0.0 support added together with Git 2.5.3
  - Switched to GitHub Lithium and funfuzz repositories
  - Updated program versions and other fixes
  - *(Custom configuration was planned for this release, then pushed out)*
- [v0.3](https://github.com/MozillaSecurity/psbootstrap/releases/tag/v0.3) (2015-04-23)
  - Rudimentary 64-bit MozillaBuild script support
  - Stop using Windows Task Scheduler
  - Install Debugging Tools for Windows, e.g. cdb.exe and windbg
  - Miscellaneous bug fixes
- [v0.2](https://github.com/MozillaSecurity/psbootstrap/releases/tag/v0.2) (2015-04-13)
  - First working release
  - JavaScript fuzzing automatically commences after 1.5 hours of bootstrapping
- [v0.1](https://github.com/MozillaSecurity/psbootstrap/releases/tag/v0.1) (2015-03-19)
  - Initial release
  - Rudimentary support of downloading and installing prerequisites
