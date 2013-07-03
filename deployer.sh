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
      
      }, 24 * 3600 * 1000); // every day
JAVASCRIPT
    
    cat $RESET
  fi
}

cd $DIR
for tag in `git tag`
do
  # checkout $tag and only $tag
  git checkout --force $tag
  git clean -f -d
  
  prepare_reset
  echo "$PASSWORD
$PASSWORD
$PASSWORD" | mrt deploy $NAME-$tag -P
done