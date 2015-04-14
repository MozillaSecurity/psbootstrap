# psbootstrap
psbootstrap assists in creating files needed to bootstrap a Windows machine for Mozilla fuzz-testing in EC2.

## Steps to make the script work as a EC2 user-data file:
1. Uncomment the first <powershell> line and the last </powershell> line.
2. Add in your private and public key sets. Look for the strings "<public key>" and "<private key>".
   These keys are used for accessing the following Mercurial fuzzing repository in step 3, and are *not* AWS access keys.
3. Add the location to a Mercurial fuzzing repository for cloning. Look for "<repository location>".

## Changelog (quick overview):
v0.2 (20150413) - First working release. Whole bootstrapping process takes about 1.5 hours, then fuzzing automatically commences.
v0.1 (20150319) - Initial release. Rudimentary support of downloading and installing prerequisites, such as Visual Studio.
