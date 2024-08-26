import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miniwhatsapploginscreen/util/constants/colors/custom_colors.dart';
import 'package:rive/rive.dart';
import '../../controller/animated_enum.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true; // State to toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText; // Toggle between obscured and visible
    });
  }

  Artboard? _artboard;
  late RiveAnimationController idle;
  late RiveAnimationController success;
  late RiveAnimationController? fail;
  late RiveAnimationController? handsUp;
  late RiveAnimationController? handsDown;
  late RiveAnimationController? lookDownLeft;
  late RiveAnimationController? lookDownRight;

  @override
  void initState() {
    super.initState();
    idle = SimpleAnimation(Animated.idle.name);
    idle = SimpleAnimation(Animated.success.name);
    idle = SimpleAnimation(Animated.fail.name);
    idle = SimpleAnimation(Animated.handsUp.name);
    idle = SimpleAnimation(Animated.handsDown.name);
    idle = SimpleAnimation(Animated.lookDownLeft.name);
    idle = SimpleAnimation(Animated.lookDownRight.name);
    rootBundle.load("assets/rive/login.riv").then((value) {
      final file = RiveFile.import(value);
      final artboard = file.mainArtboard;
      artboard.addController(idle);

      setState(() {
        _artboard = artboard;
      });
    });
    password.addListener(onFocus);
  }

  FocusNode password = FocusNode();
  void onFocus() {
    if (password.hasFocus) {
      addHandsUp();
    } else {
      addHandsDown();
    }
  }

  void clearAllControllers() {
    _artboard!.artboard.removeController(idle);
    _artboard!.artboard.removeController(success);
    _artboard!.artboard.removeController(fail!);
    _artboard!.artboard.removeController(handsUp!);
    _artboard!.artboard.removeController(handsDown!);
    _artboard!.artboard.removeController(lookDownLeft!);
    _artboard!.artboard.removeController(lookDownRight!);
  }

  void addIdle() {
    clearAllControllers();
    _artboard!.artboard.addController(idle);
  }

  void addSuccess() {
    clearAllControllers();
    _artboard!.artboard.addController(success);
  }

  void addFail() {
    clearAllControllers();
    _artboard!.artboard.addController(fail!);
  }

  void addHandsUp() {
    clearAllControllers();
    _artboard!.artboard.addController(handsUp!);
  }

  void addHandsDown() {
    clearAllControllers();
    _artboard!.artboard.addController(handsDown!);
  }

  void addLookDownLift() {
    lookLeft = true;
    clearAllControllers();
    _artboard!.artboard.addController(lookDownLeft!);
  }

  void addLookDownRight() {
    lookRight = true;
    clearAllControllers();
    _artboard!.artboard.addController(lookDownRight!);
  }

  bool lookRight = false;
  bool lookLeft = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backGroundColor,
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                child: _artboard == null
                    ? Center(
                        child: Text(
                          'LOGIN',
                          style: GoogleFonts.lacquer(
                            fontSize: 50.0,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.black,
                          ),
                        ),
                      )
                    : Rive(
                        artboard: _artboard!,
                        fit: BoxFit.fill,
                      ),
              ),
              Column(
                children: [
                  TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty && value.length < 20 && !lookLeft) {
                        addLookDownLift();
                      } else if (value.isNotEmpty &&
                          value.length >= 20 &&
                          !lookRight) {
                        addLookDownRight();
                      }
                    },
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: CustomColors.fillColorTextField,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20.0),
                          ),
                        ),
                        hintText: "E-mail"),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  TextField(
                    focusNode: password,
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed:
                            _togglePasswordVisibility, // Toggle visibility
                      ),
                      filled: true,
                      fillColor: CustomColors.fillColorTextField,
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      hintText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_passwordController.text.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'))
                            ],
                            title: const Text('wrong login'),
                            contentPadding: const EdgeInsets.all(20.0),
                            content: const Text('oops!!... please try again'),
                          ),
                        );
                        addFail();
                        // QuickAlert.show(
                        //   context: context,
                        //   type: QuickAlertType.error,
                        //   title: 'Oops...',
                        //   text: 'Sorry, something went wrong',
                        // );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'))
                            ],
                            title: const Text('Success login'),
                            contentPadding: const EdgeInsets.all(20.0),
                            content: const Text('Successfully login'),
                          ),
                        );
                        addSuccess();
                        // QuickAlert.show(
                        //     context: context,
                        //     type: QuickAlertType.success,
                        //     text: "Login successfully!");
                      }
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.lato(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              )
            ],
          )),
        ));
  }
}
