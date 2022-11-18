import 'package:flutter/material.dart';
import 'package:todoist/helpers/db.dart';
import 'package:todoist/models/task.dart';
import 'package:todoist/screens/TaskPage.dart';
import 'package:todoist/widgets/task-card.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final DbHelper dbHelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.blueGrey.shade100.withOpacity(.5),
          padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Image(
              image: AssetImage('assets/images/logo.png'),
              width: 40,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                initialData: const [],
                future: dbHelper.getTasks(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data?.length,
                        itemBuilder: ((context, index) {
                          return GestureDetector(
                            onTap: (() {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: ((context) {
                                return TaskPage(
                                  task: snapshot.data?[index],
                                );
                              })));
                            }),
                            child: TaskCard(
                                title: snapshot.data?[index].title,
                                desc: 'desc'),
                          );
                        }));
                  } else {
                    return const Text("No Tasks found");
                  }
                },
              ),
            )
          ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => const TaskPage(task: null))),
          ).then((value) => setState(
                () {},
              ));
        },
        elevation: 10,
        highlightElevation: 1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        backgroundColor: Colors.green.shade500,
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
