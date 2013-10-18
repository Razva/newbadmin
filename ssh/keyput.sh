#!/bin/bash

PROGNAME=`basename $0`

function usage()
{
    echo "Usage: $PROGNAME [user@]IP [[user@]IP ...]" 1>&2
    exit 0
}

# Check for correct number of parameters
test $# -gt 0 || usage;

SSH_KEYGEN=`which ssh-keygen`
if test $? -ne 0; then
    # Error message is printed by 'which'
    exit 1
fi

SSH_DIR=~/.ssh
if ! test -d $SSH_DIR; then
    mkdir $SSH_DIR
fi
chmod 700 $SSH_DIR


if [ ! -f $SSH_DIR/identity ] || [ ! -f $SSH_DIR/identity.pub ]; then
    echo "Generating ssh1 RSA keys - please wait..."
    rm -f $SSH_DIR/identity $SSH_DIR/identity.pub
    $SSH_KEYGEN -t rsa1 -f $SSH_DIR/identity -P ''
    if [ $? -ne 0 ]; then
        echo "Command \"$SSH_KEYGEN -t rsa1 -f $SSH_DIR/identity" \
             "-P ''\" failed" 1>&2
        exit 1
    fi
else
    echo "ssh1 RSA key is present"
fi

if [ ! -f $SSH_DIR/id_dsa ] || [ ! -f $SSH_DIR/id_dsa.pub ]; then
    echo "Generating ssh2 DSA keys - please wait..."
    rm -f $SSH_DIR/id_dsa $SSH_DIR/id_dsa.pub
    $SSH_KEYGEN -t dsa -f $SSH_DIR/id_dsa -P ''
    if test $? -ne 0; then
        echo "Command \"$SSH_KEYGEN -t dsa -f $SSH_DIR/id_dsa" \
             "-P ''\" failed" 1>&2
        exit 1
    fi
else
    echo "ssh2 DSA key is present"
fi

SSH1_RSA_KEY=`cat $SSH_DIR/identity.pub`
SSH2_DSA_KEY=`cat $SSH_DIR/id_dsa.pub`

for IP in $1; do
    echo "You will now be asked for password for $IP"
#    set -x
    ssh -oStrictHostKeyChecking=no $IP -p $2 "mkdir -p ~/.ssh; chmod 700 ~/.ssh; \
        echo \"$SSH1_RSA_KEY\" >> ~/.ssh/authorized_keys; \
        echo \"$SSH2_DSA_KEY\" >> ~/.ssh/authorized_keys2; \
        chmod 600 ~/.ssh/authorized_keys ~/.ssh/authorized_keys2"
#    set +x
    if test $? -eq 0; then
        echo "Keys were put successfully"
    else
        echo "Error putting keys to $IP" 1>&2
    fi
done

for IP in $1; do
    for ver in 1 2; do
        echo -n "Checking $IP connectivity by ssh$ver... "
        ssh -q -oProtocol=${ver} -oBatchMode=yes \
          -oStrictHostKeyChecking=no $IP -p $2 /bin/true
        if [ $? -eq 0 ]; then
            echo "OK"
        else
            echo "failed" 1>&2
        fi
    done
done
