#!/bin/bash -

cd $1

FIXTURES=server/fixtures.js
RESET=server/reset.js

function prepare_reset {
  rm $RESET
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


for tag in `git tag`
do
  git reset --hard $tag
  prepare_reset
  mrt deploy meteor-book-$tag.meteor.com
done