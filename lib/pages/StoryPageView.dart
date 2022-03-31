import 'package:flutter/material.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/story_view.dart';

class StoryPageView extends StatefulWidget {
  const StoryPageView({Key? key, required this.storyItems}) : super(key: key);

  final List<StoryItem> storyItems;

  @override
  State<StoryPageView> createState() => _StoryPageViewState();
}

class _StoryPageViewState extends State<StoryPageView> {
  final controller = StoryController();

  @override
  Widget build(BuildContext context) {
    final List<StoryItem> storyItems = widget.storyItems;
    return Material(
      child: StoryView(
        storyItems: storyItems,
        controller: controller,
        inline: false,
        repeat: true,
        onComplete: () => Navigator.pop(context),
        onVerticalSwipeComplete: (direction) => {
          if (direction != null && direction == Direction.down)
            {Navigator.pop(context)}
        },
      ),
    );
  }
}
