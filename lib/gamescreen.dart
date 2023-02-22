import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutterhangmanv1/utils.dart';
import 'dart:math';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  AudioCache audioCache = AudioCache(prefix: "assets/sounds/");

  String word = wordslist[Random().nextInt(wordslist.length)];
  List guessedalphabets = [];
  int points = 0;
  int status = 0;
  List images = [
    "assets/images/Hang1.png",
    "assets/images/Hang2.png",
    "assets/images/Hang3.png",
    "assets/images/Hang4.png",
    "assets/images/Hang5.png",
    "assets/images/Hang6.png",
    "assets/images/Hang8.png",
  ];

  playsound(String sound) async {
    await audioCache.load(sound);
  }

  opendialog(String title) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
            child: Container(
          width: MediaQuery.of(context).size.width / 2,
          height: 180,
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: retroStyle(25, Colors.white, FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Your Points: $points",
                style: retroStyle(20, Colors.white, FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width / 2,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      status = 0;
                      guessedalphabets.clear();
                      points = 0;
                      word = wordslist[Random().nextInt(wordslist.length)];
                    });
                    playsound("gamestart.mp3");
                  },
                  child: Center(
                    child: Text(
                      "Play Again",
                      style: retroStyle(20, Colors.black, FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
      },
    );
  }

  String handletext() {
    String displayword = "";
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (guessedalphabets.contains(char)) {
        displayword += char + " ";
      } else {
        displayword += "? ";
      }
    }
    return displayword;
  }

  checkletter(String alphabet) {
    if (word.contains(alphabet)) {
      setState(() {
        guessedalphabets.add(alphabet);
        points += 5;
      });
      playsound("correct.mp3");
    } else if (status != 6) {
      setState(() {
        status += 1;
        points -= 5;
      });
      playsound("wrong.mp3");
    } else {
      opendialog("YOU LOSE!");
      playsound("lose.mp3");
    }

    bool isWon = true;
    for (int i = 0; i < word.length; i++) {
      String char = word[i];
      if (!guessedalphabets.contains(char)) {
        setState(() {
          isWon = false;
        });
        break;
      }
    }
    if (isWon) {
      opendialog("You Win!");
      playsound("win.mp3");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black45,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black45,
        title: Text(
          "Hangman",
          style: retroStyle(30, Colors.white, FontWeight.w700),
        ),
        actions: [
          IconButton(
            iconSize: 35,
            icon: Icon(Icons.volume_up_sharp),
            color: Colors.lightBlueAccent,
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 3.5,
                decoration: BoxDecoration(color: Colors.lightBlue),
                height: 20,
                child: Center(
                  child: Text(
                    "$points Points",
                    style: retroStyle(15, Colors.black, FontWeight.w700),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Image(
                width: 205,
                height: 205,
                image: AssetImage(images[status]),
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "${7 - status} Lives left",
                style: retroStyle(18, Colors.grey, FontWeight.w800),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                handletext(),
                style: retroStyle(35, Colors.white, FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.only(left: 10),
                childAspectRatio: 1.2,
                children: letters.map((alphabet) {
                  return InkWell(
                    onTap: () => checkletter(alphabet),
                    child: Center(
                      child: Text(
                        alphabet,
                        style: retroStyle(20, Colors.white, FontWeight.w700),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
