#!/bin/bash

## Disclaimer:
## "All scripts and data files provided in this workshop were written by the presenter 
## for the purposes of the workshop and are not to be used outside of the workshop.  
## Oracle will not take any responsibility for its use outside of the workshop."

## Description: 
## "The purpose of this script is to create the encryption keys the right way so that
## the files will be able to reference them correctly."

## Author:
## Zachary Hamilton
## zach.hamilton@oracle.com

## BEGIN SCRIPT BODY
##
SCRIPT_HOME=$(cd $(dirname $0); pwd)
cd $SCRIPT_HOME
echo "Creating encryption keys..."
ssh-keygen -f ../.ssh/cloudkey -N ""
echo "Copying key to the clipboard..."
cat ../.ssh/cloudkey.pub | clip
##
## END SCRIPT BODY