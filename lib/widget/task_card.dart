import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tasker/config/dims.dart';
import 'package:tasker/model/subtask.dart';

///
/// The widget representing task card
/// that will show curent task [title] and all [subtasks]
///
class TaskCard extends StatelessWidget {
  final Text title;
  final Text body;
  final bool isCompleted;
  final List<Subtask> subtasks;
  final VoidCallback onTaskIconClicked;
  final Function(Subtask, int) onSubtaskIconClicked;
  final VoidCallback onDismissed;

  TaskCard(
      {this.title,
      this.body,
      this.isCompleted,
      this.onTaskIconClicked,
      this.subtasks,
      this.onSubtaskIconClicked,
      this.onDismissed})
      : assert(title != null);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) => onDismissed(),
      key: GlobalKey(),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Dims.small),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: Dims.small),
                    child: IconButton(
                      onPressed: onTaskIconClicked,
                      iconSize: Dims.xlarge,
                      icon: Icon(isCompleted == true
                          ? CupertinoIcons.check_mark_circled
                          : CupertinoIcons.circle),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: Dims.tiny),
                          child: DefaultTextStyle(
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2
                                .copyWith(
                                    decoration: isCompleted == true
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none),
                            overflow: TextOverflow.ellipsis,
                            child: title,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (subtasks != null)
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: subtasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: IconButton(
                          icon: Icon(subtasks[index].isCompleted == true
                              ? CupertinoIcons.check_mark_circled
                              : CupertinoIcons.circle),
                          onPressed: () =>
                              onSubtaskIconClicked(subtasks[index], index)),
                      title: DefaultTextStyle(
                          style: Theme.of(context).textTheme.caption.copyWith(
                              decoration: subtasks[index].isCompleted == true
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none),
                          child: Text(subtasks[index].title)),
                    );
                  },
                )
            ],
          ),
        ),
      ),
    );
  }
}
