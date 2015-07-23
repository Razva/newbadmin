#!/bin/bash

#Global variables
queue_total=`exim -bpc` # Saving how many emails are currently in the queue
version='1.1.1'

# Logfile checking variables:
LOGDIR=/var/log
LOGFILE=exim_mainlog
GREP="grep"
NUM_RCPTS=15

#############################################
# User changeable variables to choose which #
#  checks are performed during log parsing  #
############################################

# Check for emails that were sent from scripts
# by searching for CWD
CHECK_FOR_SCRIPTS="true"

# Checks for emails that were sent by a user
# that logged in with a password
CHECK_FOR_AUTH="true"

# Checks for emails sent by
# a cpanel/system account
CHECK_FOR_ACCOUNT="true"

# Show the address the most bounce backs
# were returned to
CHECK_FOR_BOUNCES="false"

# Does a check for emails sent by a email address
# However this can be forged, may get rid of this function
CHECK_MOST_DOMAIN="false"

# Shows what IP's sent the most emails
# 127.0.0.1 is common if sent via script/webmail
CHECK_MOST_IP="false"

# Shows single emails that had the most recipients
CHECK_MOST_RCPTS="true"



##################################################
#     !!!END OF USER DEFINABLE VARIABLES!!!      #
##################################################

# Sends script version information to my server
#commented out because the domain expired
#curl --connect-timeout 5 -d "version=$version" http://morzain.net/spamfu/spamfu.php

###################################################
###################################################
# This is the main menu of the script             #
# This asks you to check the logs, queue, or exit #
###################################################
###################################################

function spamfu_init
{
    echo "####################################"
    echo ""
    echo "WELCOME TO SPAMFU"
    echo "There are currently ${queue_total} emails in the queue"
    echo ""
    echo "What would you like to do?:"
    echo "  (1) Check for spammers via email logs"
    echo "  (2) Check for spammers via emails in the queue"
    echo "  (3) Exit"
    echo -n "Select option: "
    read spamfu_option

    if [ -z $spamfu_option ]; then
        spamfu_init
    else
        echo "You have selected $spamfu_option"
    fi

    if ! [ $spamfu_option -ge 1 -a  $spamfu_option -le 3 ];then
        echo Invalid option
        spamfu_init
    fi

    if [ $spamfu_option = "1" ]; then
        logs_init
    fi

    if [ $spamfu_option = "2" ]; then
        queue_init
    fi

    if [ $spamfu_option = "3" ]; then
        echo "Exiting"
        exit
    fi
}



#######################################################
#######################################################
# This is the menu for checking the queue             #
# It asks you how many seconds to check the queue for #
#######################################################
#######################################################

function queue_init
{
    echo "There are currently ${queue_total} emails in the queue"
    echo ""
    echo "Parsing the entire queue can take a while"
    echo "Instead we can look at a snapshot of the emails in the queue"
    echo -n "How many seconds would you like to parse the queue for? 0 is unlimited [0]: "

    read queue_option

    if [ -z $queue_option ]; then
        echo ""
        echo "You have selected: 0 (unlimited)"
        echo "" 
        queue_timeout="0"
        check_queue
    elif
        echo $queue_option | grep -Eq '^[0-9]{0,3}?\.?[0-9]+$'; then
        queue_timeout=$queue_option
        echo "Setting timeout to ${queue_timeout} seconds"
        check_queue
    else
        echo ""
        echo "****************************"
        echo "Please enter a valid integer"
        echo "****************************"
        echo ""
        queue_init
    fi
}

#######################################################
#######################################################
# This is the menu for checking the logs              #
#######################################################
#######################################################

function logs_init
{
    echo ""
    echo "##########################################################"
    echo "Parsing a large file with lots of checks can take a while"
    echo "Choose options to pick which logfile, which checks to perform"
    echo "as well as how many lines of the file to parse"
    echo ""
    echo "LOGFILE: `echo $LOGFILE | awk '{print $1}'`"
    echo "SIZE: `du -sh $LOGDIR/$LOGFILE | awk '{print $1}'`"
    echo " (1) Proceed with check"
    echo " (2) Change log file"
    echo " (3) Change which checks are performed"
    echo " (4) Change how many lines to parse"
    echo " (5) Main Menu"
    echo -n "Select option: "
    read logmenu_option

    if ! [ $logmenu_option -ge 1 -a  $logmenu_option -le 5 ];then
        echo Invalid option
        logs_init
    fi
 
    if [ $logmenu_option = "1" ]; then
        check_logs
    fi

    if [ $logmenu_option = "2" ]; then
        logfile_menu
    fi

    if [ $logmenu_option = "3" ]; then
        logcheck_menu
    fi

    if [ $logmenu_option = "4" ]; then
        logline_menu
    fi

    if [ $logmenu_option = "5" ]; then
        spamfu_init
    fi
}

################################

function logfile_menu
{
LOG_NUMBER=0
    echo ""
    echo "######################################"
    echo "choose one of the following:"

    # create an array called LOG_LIST with a list of any file in $LOGDIR
    # that starts with exim_mainlog
    for logfile in `ls $LOGDIR/exim_mainlog*`; do
        let "LOG_NUMBER += 1"
        LOG_LIST[$LOG_NUMBER]=`echo $logfile | awk -F/ '{print $NF}'`
    done

    # save the number of files in the array and subtract 1
    # becuase we want to start at 1 instead of 0
    LOG_NUMBER=${#LOG_LIST[@]}
#    let "LOG_NUMBER -= 1"

    # Create the menu with a loop of 1 to however many files are in the array
    for i in `seq 1 $LOG_NUMBER`; do
        echo " ($i) `du -sh $LOGDIR/${LOG_LIST[$i]} | awk '{print $1}'` ${LOG_LIST[$i]}"
    done
    echo -n "Select option: "
    read logmenu_option

    if [ $(echo "$logmenu_option" | grep -E "^[0-9]+$") ]; then
        if [ $logmenu_option -le $LOG_NUMBER -a $logmenu_option -gt 0 ]; then
            LOGFILE=${LOG_LIST[$logmenu_option]}
            echo "Using ${LOG_LIST[$logmenu_option]}"
            if [[ $(file $LOGDIR/$LOGFILE | grep "gzip") ]]; then
                GREP="zgrep"
                echo "using zgrep"
            else
                GREP="grep"
                echo "using grep"
            fi
            logs_init
        else
            echo "Invalid option"
            logfile_menu
        fi
    else
        echo "Invalid option"
        logfile_menu
    fi

}

###########################

function logline_menu
{
    echo "not implemented yet"
    logs_init
}

function logcheck_menu
{
    echo "not implemented yet"
    echo "these can be modified by editing the script"
    logs_init
}

####################################################
####################################################
#Function to check the logs                        #
#Called if you choose that option on the main menu #
####################################################
####################################################

check_logs()
{
    # This sets a variable so we can ignore emails sent to domains on the server, as we only want outgoing emails.
    # it takes the list of domains, adds "for .*@" to the front of each domain
    # then replaces the newline characters with pipes, and removes the pipe that ends up at the end of the line
    LOCAL_DOMAINS=`cat /etc/localdomains | sed  's/^/for .*@/g' | tr '\n' '|' | sed 's/|$//'`

    check_for_scripts()
    {
        echo "Checking for scripts..."
        SCRIPTED_EMAILS=`$GREP -o " cwd=[[:alnum:][:graph:]]*" $LOGDIR/$LOGFILE |  grep -v spool | sort | uniq -c | sort -rn | head`
        echo  "Emails sent from scripts:"
        echo  "$SCRIPTED_EMAILS"
        echo
    }

    check_for_auth()
    {
        echo "Checking for auth users..."
        AUTH_EMAILS=`$GREP '<=' $LOGDIR/$LOGFILE | egrep -o " A\=(fixed|courier|dovecot)_(login|plain):[[:alnum:][:graph:]]*" | cut -d: -f2 | sort | uniq -c | sort -rn | head`
        echo  "Most emails sent by authenticated users:"
        echo  "$AUTH_EMAILS"
        echo
    }

    check_for_account()
    {
       echo "Checking for cpanel/system accounts..."
       ACCOUNT_EMAILS=`$GREP '<=' $LOGDIR/$LOGFILE | egrep -v "$LOCAL_DOMAINS" | grep -v ' U=mailnull' | grep -o " U=[[:alnum:][:graph:]]*" | cut -d= -f2 | sort | uniq -c | sort -rn | head`
       echo  "Emails sent from cpanel/system accounts:"
       echo  "$ACCOUNT_EMAILS"
       echo
    }

    check_for_bounces()
    {
        echo "Checking for bounces..."
        BOUNCE_BACKS=`$GREP " U=mailnull.*returning message" $LOGDIR/$LOGFILE | grep -o " for [[:alnum:][:graph:]]*@[[:alnum:][:graph:]]*" | cut -d' ' -f3 | sort | uniq -c | sort -rn | head`
        echo  "Most bounces returned to:"
        echo  "$BOUNCE_BACKS"
        echo
    }

    check_most_domain()
    {
        echo "Checking 'from' addresses..."
        MOST_SENT_DOMAIN=`$GREP '<=' $LOGDIR/$LOGFILE | grep -v mailnull | egrep -v "$LOCAL_DOMAINS" | cut -d" " -f6 | sort | uniq -c | sort -rn | head`
        echo  "Most frequent senders by 'from' address:"
        echo  "Note: Could be forged addresses"
        echo  "$MOST_SENT_DOMAIN"
        echo
    }

    check_most_ip()
    {
        echo "Checking for sender IP..."
        MOST_SENT_IP=`$GREP '<=' $LOGDIR/$LOGFILE | egrep -v "$LOCAL_DOMAINS" | grep -o ' H=.*\ \[[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\]' | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | sort | uniq -c | sort -rn | head`
        echo  "Most frequent senders by IP address:"
        echo  "$MOST_SENT_IP"
        echo
    }

    check_most_rcpts()
    {
        echo "Checking for recipients..."
        MOST_RCPTS=`$GREP '<=' $LOGDIR/$LOGFILE | grep -v mailnull | egrep -v "$LOCAL_DOMAINS" | awk -v NUM_RCPTS="$NUM_RCPTS" ' 

            function shift_list(x)
            {
                y=x
                x++
                while (x <= NUM_RCPTS)
                {
                    TOP_RCPTS[x] = TOP_RCPTS[y]
                    MAIL_ID[x] = MAIL_ID[y]
                    SENDER_ID[x] = SENDER_ID[y]
                    x++
                    y++
                }
            }
    
            function save_current()
            {
                SENDER_ID[CUR_NUM]=$6
                MAIL_ID[CUR_NUM]=$4
                TOP_RCPTS[CUR_NUM]=NUM_ADDRESSES
            }
    
            function display_results()
            {
                CUR_NUM=1
                while (CUR_NUM <= NUM_RCPTS) {
                    print MAIL_ID[CUR_NUM], "with", TOP_RCPTS[CUR_NUM], "recipients was sent by", SENDER_ID[CUR_NUM]
                    CUR_NUM++
                }
            }
    
            function duplicate_check()
            {
                x=NUM_RCPTS
                y=x-1
                while (x > 0)
                {
                    if (MAIL_ID[x] == MAIL_ID[y])
                    {
                        MAIL_ID[x]=0
                        TOP_RCPTS[x]=0
                        SENDER_ID[x]=0
                    }
                    x--
                    y--
                 }
            }
    
            BEGIN {
                CUR_NUM=NUM_RCPTS
                while (CUR_NUM > 0){
                    MAIL_ID[CUR_NUM] = 0
                    TOP_RCPTS[CUR_NUM] = 0
                    SENDER_ID[CUR_NUM] = 0
                    CUR_NUM--
              }
            }
    
            {
                split($0,RCPTS_TMP,"from.*for ")
                split(RCPTS_TMP[2],RCPTS," ")
    
                NUM_ADDRESSES=0
                for (ADDRESSES in RCPTS)
                     ++NUM_ADDRESSES
                CUR_NUM=1
                for (EACH in TOP_RCPTS)
                {
                    if (NUM_ADDRESSES > TOP_RCPTS[CUR_NUM])
                    {
                        shift_list(CUR_NUM)
                        save_current()
                        duplicate_check()
                        break
                    }
                    CUR_NUM++
                }
            }
            END {
                display_results()
            }
    

        '`
        echo  "Most recipients by Mail and Sender ID's:"
        echo  "$MOST_RCPTS"
    }



    # This is where the functions that were declared above
    # Are actually called, if their variables are set to true

    if [ $CHECK_FOR_SCRIPTS = "true" ]; then
        check_for_scripts
    fi

    if [ $CHECK_FOR_AUTH = "true" ]; then
        check_for_auth
    fi

    if [ $CHECK_FOR_ACCOUNT = "true" ]; then
        check_for_account
    fi

    if [ $CHECK_FOR_BOUNCES = "true" ]; then
        check_for_bounces
    fi

    if [ $CHECK_MOST_DOMAIN = "true" ]; then
        check_most_domain
    fi

    if [ $CHECK_MOST_IP = "true" ]; then
        check_most_ip
    fi

    if [ $CHECK_MOST_RCPTS = "true" ]; then
        check_most_rcpts
    fi

}




#############################################
#############################################
# Function to check the emails in the queue #
#############################################
#############################################
check_queue()
{
    #Function that stops the find command after X number of seconds
    kill_it()
    {
        sleep $queue_timeout
        PID=`ps aux | grep "find /var/spool/exim/input" | grep -v grep | awk '{print $2}'`
        if [ -n "${PID}" ]; then
            kill $PID
        fi
    }
    
    # Set timer for parsing the queue unless it is 0 (unlimited)
    if [ "$queue_timeout" != "0" ]; then
        kill_it & 
    fi
    
    # Find emails in exim's spool folder
    queue_tmp=`find /var/spool/exim/input -name '*-H' | sed '$d' | xargs grep 'auth_id'`
    echo "Done finding emails, starting to parse"
 
    # Parse the queue_tmp variable to sort by auth_id
    queue_senders=`echo -e "$queue_tmp" | cut -d: -f2 | sort | uniq -c | sort -rn | head -n5`

    echo -e "Parsed `echo -e "$queue_tmp" | wc -l` emails out of $queue_total in the queue with a $queue_timeout second timeout"
    echo -e "Highest number of emails in queue by auth_id:"
    echo -e "$queue_senders"
    echo ""

    queue_senders_tmp=`echo "$queue_senders" | awk '{print $3}'`
    
    for each in `echo "$queue_senders_tmp"`
    do
        echo "Example emails sent by $each:"
        echo "$queue_tmp" | grep $each | cut -d: -f1 | head -n5
        echo ""
    done
}


clear
spamfu_init
