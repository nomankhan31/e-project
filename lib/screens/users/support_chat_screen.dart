import 'package:flutter/material.dart';

class SupportChatScreen extends StatefulWidget {
  const SupportChatScreen({super.key});
  @override
  State<SupportChatScreen> createState() => _SupportChatScreenState();
}

class _SupportChatScreenState extends State<SupportChatScreen> {
  final controller = TextEditingController();
  List<String> msgs = [
    "Hello! How can we help you?",
    "I need help with my order"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            title: const Text("Support Chat"), backgroundColor: Colors.black),
        body: Column(children: [
          Expanded(
              child: ListView.builder(
                  itemCount: msgs.length,
                  itemBuilder: (c, i) => Align(
                      alignment: i % 2 == 0
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color:
                                  i % 2 == 0 ? Colors.grey[800] : Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(msgs[i],
                              style: TextStyle(
                                  color: i % 2 == 0
                                      ? Colors.white
                                      : Colors.black)))))),
          Padding(
              padding: const EdgeInsets.all(12),
              child: Row(children: [
                Expanded(
                    child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                            hintText: "Type message...",
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))))),
                IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {
                      setState(() => msgs.add(controller.text));
                      controller.clear();
                    })
              ]))
        ]));
  }
}
