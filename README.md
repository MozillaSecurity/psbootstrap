# psbootstrap
psbootstrap assists in creating files needed to bootstrap a Windows machine for Mozilla fuzz-testing in EC2.

## How to use
Run psbootstrap using Laniakea:

```
# ~/trees/boto-awsfuzz/bin/python -u laniakea.py -region=us-east-1 -images <your images.json> -create-on-demand -tags Name=<your tag> -image-name <your image name> -ebs-volume-delete-on-termination -ebs-size 192 -userdata init.userdata
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
