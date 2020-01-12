// Copyright 2018 The Flutter Architecture Sample Authors. All rights reserved.
// Use of this source code is governed by the MIT license that can be found
// in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:states_rebuilder_sample/domain/entities/todo.dart';
import 'package:states_rebuilder_sample/service/todos_service.dart';
import 'package:states_rebuilder_sample/ui/common/helper_methods.dart';
import 'package:states_rebuilder_sample/ui/pages/add_edit_screen.dart/add_edit_screen.dart';
import 'package:todos_app_core/todos_app_core.dart';

class DetailScreen extends StatelessWidget {
  DetailScreen(this.todo) : super(key: ArchSampleKeys.todoDetailsScreen);
  final Todo todo;

  final todosService = Injector.get<TodosService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ArchSampleLocalizations.of(context).todoDetails),
        actions: [
          IconButton(
            key: ArchSampleKeys.deleteTodoButton,
            tooltip: ArchSampleLocalizations.of(context).deleteTodo,
            icon: Icon(Icons.delete),
            onPressed: () {
              todosService.deleteTodo(todo);
              Navigator.pop(context, todo);
              HelperMethods.removeTodo(todo);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: StateBuilder<TodosService>(
                    builder: (_, todosServiceRM) {
                      return Checkbox(
                        value: todo.complete,
                        key: ArchSampleKeys.detailsTodoItemCheckbox,
                        onChanged: (complete) {
                          todo.complete = !todo.complete;
                          todosServiceRM.setState((s) => s.updateTodo(todo));
                        },
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          bottom: 16.0,
                        ),
                        child: Text(
                          todo.task,
                          key: ArchSampleKeys.detailsTodoItemTask,
                          style: Theme.of(context).textTheme.headline,
                        ),
                      ),
                      Text(
                        todo.note,
                        key: ArchSampleKeys.detailsTodoItemNote,
                        style: Theme.of(context).textTheme.subhead,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: ArchSampleLocalizations.of(context).editTodo,
        child: Icon(Icons.edit),
        key: ArchSampleKeys.editTodoFab,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return AddEditPage(
                  key: ArchSampleKeys.editTodoScreen,
                  todo: todo,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
