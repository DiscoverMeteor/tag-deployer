#!/bin/bash -

DIR=$1
PASSWORD=$2
NAME=meteor-book

FIXTURES=server/fixtures.js
RESET=server/reset.js

function prepare_reset {
  [ -e $RESET ] && rm $RESET
  
  if [ -e $FIXTURES ]
  then
    cat > $RESET <<JAVASCRIPT
      Meteor.setInterval(function() {
        
        // reset
        if (typeof(Posts) !== 'undefined') Posts.remove({}, {multi: true});
        if (typeof(Comments) !== 'undefined') Comments.remove({}, {multi: true});
        if (typeof(Notifications) !== 'undefined') Notifications.remove({}, {multi: true});
          
JAVASCRIPT
    
    cat $FIXTURES >> $RESET
    
    cat >> $RESET <<JAVASCRIPT
      
      }, 1000); // every day
JAVASCRIPT
    
    cat $RESET
  fi
}

cd $DIR
for tag in `git tag`
do
  git reset --hard $tag
  prepare_reset
  echo "$PASSWORD
$PASSWORD" | mrt deploy $NAME-$tag -P
done