# psbootstrap
psbootstrap assists in creating files needed to bootstrap a Windows machine for Mozilla fuzz-testing in EC2.

## Steps
In order to make the script work as a EC2 user-data file:

1. Uncomment the first &lt;powershell&gt; line and the last &lt;/powershell&gt; line.
2. Add in your private and public key sets. Look for the strings "&lt;public key>" and "&lt;private key&gt;".
   These keys are used for accessing the following Mercurial fuzzing repository in step 3, and are *not* AWS access keys.
3. Add the location to a Mercurial fuzzing repository for cloning. Look for "&lt;repository location&gt;".

## Changelog
- v0.3 (2015-04-23)
 - Rudimentary 64-bit MozillaBuild script support
 - Stop using Windows Task Scheduler
 - Install Debugging Tools for Windows, e.g. cdb.exe and windbg
 - Miscellaneous bug fixes
- v0.2 (2015-04-13)
 - First working release
 - JavaScript fuzzing automatically commences after 1.5 hours of bootstrapping
- v0.1 (2015-03-19)
 - Initial release
 - Rudimentary support of downloading and installing prerequisites
