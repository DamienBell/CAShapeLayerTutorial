There are 3 ViewControllers to look at:
 * ChainedAnimationsShapeViewController (no user interaction required.)
 * ExperimentalSlideViewController (styling)
 * SwipedAnimationsViewController (animates CAShapeLayers on every swipe)

These all live in Shapes.storyboard.

To run first 2 VCs - set ExamplesPageViewController to initial view controller.
To run SwipedAnimationsViewController, set it to initial view controller.


# CAShapeLayer Tutorial

## Ok, let's build an animating UITableView using CASphapeLayer, and the UTTableView ScrollDelegate inspired by this design [this design](https://cdn.dribbble.com/users/467195/screenshots/2719343/attachments/550388/magicco_tubik_studio.mp4).

Here's a [sketch file](https://www.dropbox.com/s/b9pvlmb6zl0z149/CAShapeLayerTutorial.sketch?dl=0) with three phases. We'll build this in progressive phases building on each to get a handle on common UIKit implementations, and toward the end we'll make it pop with CAShapeLayer animations.

### Phase 1: Build a UITableView, and Cells
- Create a UITableViewController in storyboard.
- In storyboard, add a UITableView where all corners are equal pinned to the view.
- Create a UITableViewCell, either in storyboard or in an xib file.
- Style the tableviewcell. Pay close attention to how it's layed out in sketch. Each cell has a UIImage background (use the images from sketch). It then has a container view with a gradient that is pinned to the left, right, and bottom of the tablecell with a height greater or equal to 50% of the parent view.
- Notice that container view is a mostly translucent view with a gradient. Ignore the gradient for the time being and just make it a black UIView with a low opacity so we can see the white text. (maybe 20%, you decide).
- Inside the label container view are three labels. Pay attention to the font-size and style (bold, regular, ect). All font's are system styles so don't worry about matching the font to the sketch version. (SF UI won't be availabile until iOS 11).
- Building the labels three labels will likely make use of a vertical stack view. Each label is 8 points from it's nearest neighbor. The stackview is is 25% to the left of the it's container.

Let's start with this. Just build phase one and we'll move on from there. I'm thinking that for our three example projects I'll have you do the UIKit work and I'll take over on the CAShapeLayer stuff.
Don't hesitate to reach out with questions. Let's have some back and forth with this so we can establish best practices and expectations. The style guide that Michael wrote should be a good reference for how to structure the code.
