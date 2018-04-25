# CjCoaxRotaryMenu
This is the MVP implementation of a ferris-wheel-like menu, using collection view.



### Notes
- The menu itself is a collection view, and all animations/forces are done using UIDynamics, with a custom behavior called: *CjCoaxTrainAttachmentBehavior*

- Menu itself is a collection view with a custom circular layout. *CjCoaxCircularLayout*

- If for whatever reason, you want to use this as is, beware that the collection view does not recycle any of the cells as they are visible all the times! Bear this in mind when adding more cells, or else you'll have performance issue.

### Future changes
I have plans to expand this idea and make this a proper menu that swap current active view controller based on the selected item.
