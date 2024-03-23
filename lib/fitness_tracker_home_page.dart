import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fitness_app/database_helper.dart';
import 'package:fitness_app/countdown_timer.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _fromKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  bool isLoggedIn = false;
  bool isSignupScreen = false;
  bool isAddActivityScreen = false;

  List<Map<String, dynamic>> activities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoggedIn
          ? isAddActivityScreen
              ? addActivityScreen()
              : buildActivityScreen()
          : isSignupScreen
              ? signUpPage()
              : buildLoginScreen(),
    );
  }

  Widget buildLoginScreen() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(197, 87, 140, 1),
          Color.fromRGBO(144, 69, 176, 1)
        ]),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: Form(
            key: _fromKey,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                // Container(
                //   decoration: const BoxDecoration(shape: BoxShape.circle),
                //   child: Image.asset(
                //     "assets/images/login.png",
                //     height: 120,
                //     width: 120,
                //   ),
                // ),
                   Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQeJ4g5Wlu8bGSRA2tjoihHVhPKdIUjhgnp-w&usqp=CAU",
                  height: 100,
                  width: 150,
                ),
                Text(
                  'Welcome',
                  style: GoogleFonts.dmSans (
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    letterSpacing : 0.1
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20)),
                      labelText: "Email",
                      hintText: "Enter Email"),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Email";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  obscuringCharacter: '.',
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    labelText: "Password",
                    hintText: "Enter Password",
                    suffixIcon: const Icon(Icons.remove_red_eye_outlined),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter Password";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: 250,
                  padding: const EdgeInsets.only(top: 2, bottom: 2),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromRGBO(197, 87, 140, 1),
                      Color.fromRGBO(144, 69, 176, 1)
                    ]),
                  ),
                  child: ElevatedButton(
                      onPressed: () {
                        _login();
                      },
                      child: const Text("Login")),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isSignupScreen = true;
                        signUpPage();
                      });
                    },
                    child: const Text('Create account'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    final user = await _databaseHelper.getUser(email, password);

    if (user != null && user['password'] == password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful 💪💪')),
      );
      setState(() {
        isLoggedIn = true;
      });
    } else {
      // Login failed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not Found')),
      );
    }
  }

  Widget signUpPage() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(197, 87, 140, 1),
          Color.fromRGBO(144, 69, 176, 1)
        ]),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Username',
                  prefixIcon: const Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscuringCharacter: '.',
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Container(
                width: 20,
                padding: const EdgeInsets.only(top: 2, bottom: 2),
                child: ElevatedButton(
                  onPressed: () async {
                    bool signupValidated = _formKey.currentState!.validate();

                    if (signupValidated) {
                      await _databaseHelper.insertUsers(
                          emailController.text, passwordController.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User Created Successfully")));

                      setState(() {
                        // isSignupScreen = false;
                        isLoggedIn = true;
                        // buildActivityScreen();
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Signup Failed")));
                    }
                  },
                  child: const Text("Sign Up"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isSignupScreen = false;
                  });
                },
                child: const Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addActivityScreen() {
    void deleteActivity(int id) async {
      await _databaseHelper.deleteActivity(id);
      setState(() {
        activities.removeWhere((activity) => activity['id'] == id);
      });
    }

    return Container(
      // padding: const EdgeInsets.all(10),
      color: const Color.fromARGB(255, 106, 174, 231),

      child: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              color: Color.fromARGB(255, 172, 165, 165)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, left: 10),
                child: Text(
                  'Hii',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 5),
                child: Text(
                  "Anuj",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Text(
                  "Your ToDays Workout",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isAddActivityScreen = false;
                      });
                    },
                    child: const Text("Add Another Workout")),
              ),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _databaseHelper.getActivities(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }
                  final activities = snapshot.data!;
                  return Expanded(
                    child: ListView.separated(
                      itemCount: activities.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        return Container(
                          height: 70,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(197, 87, 140, 1),
                              Color.fromRGBO(144, 69, 176, 1)
                            ]),
                          ),
                          child: Row(
                            children: [
                              Column(
                                children: [
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 5),
                                    child: Text(activities[index]['activity']),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(left: 10, top: 7),
                                    child: CountdownTimerWidget(
                                      duration: activities[index]["duration"],
                                      // Pass duration here
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  deleteActivity(activities[index]['id']);
                                },
                                icon: const Icon(Icons.delete),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildActivityScreen() {
    final TextEditingController activityController = TextEditingController();
    final TextEditingController durationController = TextEditingController();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(210, 206, 242, 1),
          Color.fromRGBO(215, 211, 226, 1)
        ]),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "Exercise List",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset(
                            "assets/images/dips.png",
                            height: 150,
                            width: 150,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => dips(),
                              ));
                        },
                      ),
                      const Text("Dips"),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Color.fromRGBO(197, 4, 98, 1),
                              Color.fromRGBO(80, 3, 112, 1)
                            ]),
                          ),
                          child: Image.asset(
                            "assets/images/preaching.png",
                            height: 150,
                            width: 150,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => preaching(),
                              ));
                        },
                      ),
                      const Text("Preaching Curls"),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 150,
                          width: 150,
                          child: Image.asset(
                            "assets/images/seated.jpeg",
                            height: 150,
                            width: 150,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => seatedDumbellCurlsDesc(),
                              ));
                        },
                      ),
                      const Text("Seated Dumbell Curls"),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 150,
                          width: 150,
                          child: Image.asset(
                            "assets/images/lat.jpeg",
                            height: 150,
                            width: 150,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => latPullDownsDesc(),
                              ));
                        },
                      ),
                      const Text("Lat Pulldowns"),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 150,
                          width: 150,
                          child: Image.asset(
                            "assets/images/dumbbell.png",
                            height: 150,
                            width: 150,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => dumbellShrugsDesc(),
                              ));
                        },
                      ),
                      const Text("Dumbbell Shrugs"),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      GestureDetector(
                        child: Container(
                          height: 150,
                          width: 150,
                          child: Image.asset(
                            "assets/images/legpress.png",
                            height: 150,
                            width: 150,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => legPressDesc(),
                              ));
                        },
                      ),
                      const Text("Leg Press"),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      Container(
                        height: 150,
                        width: 150,
                        child: Image.asset(
                          "assets/images/legextension.jpeg",
                          height: 150,
                          width: 150,
                        ),
                      ),
                      const Text("Leg Extension"),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Column(
                    children: [
                      SizedBox(
                        height: 150,
                        width: 150,
                        child: Image.asset(
                          "assets/images/crunches.png",
                          height: 150,
                          width: 150,
                        ),
                      ),
                      const Text("Crunches"),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
              child: TextFormField(
                controller: activityController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Activity",
                  hintText: "Enter Activity",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Activity";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: "Duration (minutes)",
                  hintText: "Enter Duration",
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter Duration";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 130),
              child: ElevatedButton(
                style: const ButtonStyle(
                    // backgroundColor: MaterialStatePropertyAll(Colors.yellow),
                    ),
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  await _databaseHelper.insertActivity(
                    activityController.text,
                    int.parse(durationController.text),
                  );
                  setState(() {
                    isAddActivityScreen = true;
                    addActivityScreen();
                  });

                  activityController.clear();
                  durationController.clear();
                  setState(() {});
                },
                child: const Text('Add Activity'),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

Widget seatedDumbellCurlsDesc() {
  return Scaffold(
      body: Center(
          child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Seated Dumbell Curl',
        style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: 0.1),
      ),
      const SizedBox(
        height: 5,
      ),
      Container(
        height: 200,
        width: 500,
        padding: const EdgeInsets.all(8),
        child: const Text(
            'Bicep exercise performed while seated, involving curling dumbbells from a palms-down position to a palms-up position, targeting the biceps muscles for improved arm strength and definition.'),
      )
    ],
  )));
}

Widget latPullDownsDesc() {
  return Scaffold(
      body: Center(
          child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Lat Pull Down',
        style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: 0.1),
      ),
      const SizedBox(
        height: 5,
      ),
      Container(
        height: 200,
        width: 500,
        padding: const EdgeInsets.all(8),
        child: const Text(
            'Upper body exercise performed on a cable machine by pulling a bar down towards the chest while seated, targeting the latissimus dorsi muscles, improving upper back strength and posture.'),
      )
    ],
  )));
}

Widget dumbellShrugsDesc() {
  return Scaffold(
      body: Center(
          child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Dumbell Shrugs',
        style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: 0.1),
      ),
      const SizedBox(
        height: 5,
      ),
      Container(
        height: 200,
        width: 500,
        padding: const EdgeInsets.all(8),
        child: const Text(
            'Shoulder exercise performed by holding a dumbbell in each hand and elevating the shoulders towards the ears, primarily targeting the trapezius muscles, often used to improve upper body posture and shoulder strength.'),
      )
    ],
  )));
}

Widget dips() {
  return Scaffold(
      body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(
        "assets/images/dips.png",
        height: 300,
        width: 300,
      ),
      Text(
        'Dips',
        style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: 0.1),
      ),
      const SizedBox(
        height: 5,
      ),
      Container(
        height: 200,
        width: 500,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(188, 43, 113, 1),
            Color.fromRGBO(111, 40, 141, 1)
          ]),
        ),
        padding: const EdgeInsets.all(10),
        child: const Text(
            'Bodyweight exercise targeting the triceps, chest, and shoulders, performed by supporting oneself on parallel bars or other elevated surfaces, lowering the body by bending the arms, and then pushing back up to the starting position. Dips are effective for building upper body strength and muscle definition.'),
      )
    ],
  ));
}

Widget legPressDesc() {
  return Scaffold(
      body: Center(
          child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        'Dumbell Shrugs',
        style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: 0.1),
      ),
      const SizedBox(
        height: 5,
      ),
      Container(
        height: 200,
        width: 500,
        
        padding: const EdgeInsets.all(8),
        child: const Text(
            'Shoulder exercise performed by holding a dumbbell in each hand and elevating the shoulders towards the ears, primarily targeting the trapezius muscles, often used to improve upper body posture and shoulder strength.'),
      )
    ],
  )));
}

Widget preaching() {
  return Scaffold(
      body: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Image.asset(
        "assets/images/preaching.png",
        height: 300,
        width: 300,
      ),
      Text(
        'Preaching Curls',
        style: GoogleFonts.dmSans(
            fontWeight: FontWeight.w800, fontSize: 30, letterSpacing: 0.1),
      ),
      const SizedBox(
        height: 5,
      ),
      Container(
        height: 200,
        width: 500,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(188, 43, 113, 1),
            Color.fromRGBO(111, 40, 141, 1)
          ]),
        ),
        padding: const EdgeInsets.all(8),
        child: const Text(
            ' Bicep exercise performed on a preacher bench, involving curling a barbell or dumbbells from a fully extended position to a fully contracted position while resting the upper arms against the angled pad of the preacher bench. Preacher curls specifically target the biceps muscles, helping to isolate and strengthen them.'),
      )
    ],
  ));
}
