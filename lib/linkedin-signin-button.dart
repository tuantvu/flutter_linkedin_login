import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_linkedin_login/flutter_linkedin_login.dart';

typedef void LinkedInProfileCallBack(LinkedInProfile profile,  PlatformException ex);

class LinkedInSignInButton extends StatefulWidget {

  LinkedInSignInButton({
    this.onSignIn,
    this.onPressed,
    this.width = 200.0
  }): assert ((onSignIn == null && onPressed != null) ||
        (onSignIn != null && onPressed == null)),
      assert (width != null);

  final LinkedInProfileCallBack onSignIn;
  final VoidCallback onPressed;
  final double width;

  @override
  _LinkedInSignInButtonState createState() {
    return new _LinkedInSignInButtonState();
  }

}

class _LinkedInSignInButtonState extends State<LinkedInSignInButton> {

  bool active = false;
  Widget activeImage;
  Widget defaultImage;

  @override
  void initState() {
    super.initState();
    defaultImage = Image.asset("images/linkedin-button.png",
      package: 'flutter_linkedin_login',
      width: widget.width,
    );

    activeImage = Image.asset("images/linkedin-button-active.png",
      package: 'flutter_linkedin_login',
      width: widget.width,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed != null ? widget.onPressed : _loginWithProfile,
      child: active ? activeImage : defaultImage,
      onTapDown: (_) => _setActiveToTrue(),
      onTapUp: (_) => _setActiveToFalse(),
      onTapCancel: _setActiveToFalse,
    );
  }

  _loginWithProfile() async {
    try {
      LinkedInProfile profile = await FlutterLinkedinLogin.loginBasicWithProfile();
      widget.onSignIn(profile, null);
    } on PlatformException catch(e) {
      widget.onSignIn(null, e);
    } catch (error) {
      widget.onSignIn(null, new PlatformException(
          code: "Internal Error", message: error.toString(), details: error));
    }
  }

  _setActiveToTrue() {
    setState(() {
      active = true;
    });
  }

  _setActiveToFalse() {
    setState(() {
      active = false;
    });
  }

}