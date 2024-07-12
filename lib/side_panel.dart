import 'package:flutter/material.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider factory so each instance get's it's own state
final sidePanelWidthProvider =
    StateProvider.family<double, String>((ref, id) => 0.0);

// Note: When Panel is used with in a Column or any other uncontrained context,
//  it will break. Wrap the Panel in Expanded to fix.
class SidePanel extends ConsumerWidget {
  final double defaultWidth;
  final double minWidth;
  final double maxWidth;
  final HandlePosition handlePosition;
  final Widget child;
  final String id; // Unique identifier for this instance

  const SidePanel(
      {required this.defaultWidth,
      required this.minWidth,
      required this.maxWidth,
      required this.handlePosition,
      required this.child,
      required this.id,
      super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use the provider factory with the unique id
    final widthProvider = sidePanelWidthProvider(id);
    double storedWidth = ref.watch(widthProvider);
    debugPrint('$id storedWidth: $storedWidth');

    // Initialize with default width if not set
    if (storedWidth == 0.0) {
      debugPrint('setting default width: $id');
      storedWidth = defaultWidth;
    }

    return LayoutBuilder(builder: (context, constraints) {
      debugPrint('Constraints: $constraints');

      final Rect updatedRect =
          Rect.fromLTWH(0, 0, storedWidth, constraints.maxHeight);
      debugPrint('Updated Rect: $updatedRect');

      return SizedBox(
        width: storedWidth,
        height: constraints.maxHeight,
        child: Stack(
          children: [
            TransformableBox(
              constraints: BoxConstraints(
                minWidth: minWidth,
                maxWidth: maxWidth,
              ),
              allowContentFlipping: false,
              allowFlippingWhileResizing: false,
              resizable: true,
              draggable: false,
              visibleHandles: {handlePosition},
              enabledHandles: {handlePosition},
              sideHandleBuilder: (context, handle) {
                return DefaultSideHandle(
                  handle: handle,
                  length: 27,
                  thickness: 9,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Theme.of(context).colorScheme.onSurface,
                    border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1.0),
                  ),
                );
              },
              rect: updatedRect,
              onResizeUpdate: (result, event) {
                debugPrint(
                    'resizeUpdate: ${result.rect}, width: ${result.rect.width}');

                ref.read(widthProvider.notifier).state = result.rect.width;
              },
              contentBuilder: (context, rect, flip) {
                debugPrint('contentBuilder $rect');
                return child;
              },
            ),
          ],
        ),
      );
    });
  }
}


/*
Hello there!  I'm using flutter box transform to implement a simple resizable side panel class and tracking the panel width with RiverPod.  Everything works really great except for one small bug.  When I resize the panel past the max or min width the resizing stops like you'd expect.  Printing the rect inside onResizeUpdate gives
resizeUpdate: Rect.fromLTRB(5.4, 0.0, 211.9, 761.5), width: 206.53600025177002
So the actual panel width is correct(206) but the internal rect is based on the last drag offset.
At this point if I rebuild the widget or do a hot restart, the rect gets updated to be the one above, effectively offsetting the transformable box so it no longer aligns with my panel. I'll try to show the relevant code in another message.

Also, this problem only occurs when I create a right side panel with HandlePosition.left:
SidePanel(
      id: "outputPanel",
      defaultWidth: 220.0,
      minWidth: 205.0,
      maxWidth: 500.0,
      handlePosition: HandlePosition.left,
...
When creating a left side panel with HandlePosition.right, the bug does not occur.
It has something to do with the initial positioning upon rebuild.

I would think that upon rebuild the code

final Rect updatedRect =
          Rect.fromLTWH(0, 0, storedWidth, constraints.maxHeight);
...
rect: updatedRect,

would negate the issue somehow, but like I mentioned, it's as if it's setting rect from the previous rect that was offset from the drag.
Rect.fromLTRB(5.4, 0.0, 211.9, 761.5)

*/