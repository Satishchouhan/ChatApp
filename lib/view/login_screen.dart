import 'package:chat_app/method.dart';
import 'package:chat_app/view/home_search.dart';
import 'package:chat_app/view/user_signup.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController=TextEditingController();
  final _passController=TextEditingController();
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {

    final size=MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(
                height: size.height/10,
              ),
              Container(
                  width: size.width/1.2,
                  child: Text("Welcome",style: TextStyle(color: Colors.black,fontSize: 28,fontWeight: FontWeight.bold),))
            ,Container(
              width: size.width/1.2,
                child: Text("Sign In to  continue!",style: TextStyle(fontWeight: FontWeight.normal,fontSize: 25),
                ),
            ),
              SizedBox(height: size.height/10,),
              Container(
                width: size.width,
                  alignment: Alignment.center,
                  child: field(size,"Email",Icons.email_outlined,_emailController)),
              SizedBox(
                height: size.height/30,
              ),
              Container(
                  width: size.width,
                  alignment: Alignment.center,
                  child: field(size,"Password",Icons.lock_outline,_passController)),
            SizedBox(
              height: size.height/25,
            ),
              _isLoading==true?
                  CircularProgressIndicator(
                    color: Colors.brown,
                  ):
              Container(
                width: size.width/1.2,
                height: size.height/17,
                child: MaterialButton(
                  onPressed: (){
                    if(_emailController.text.isEmpty)
                    {
                      print("Enter email");
                    }else if(_passController.text.isEmpty)
                    {
                      print("Enter password");
                    }else
                    {
                      setState(() {
                        _isLoading=true;
                      });
                      usersignin( _emailController.text, _passController.text).then((user) {
                        if(user !=null){
                          setState(() {
                            _isLoading=false;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeSearch()));
                        }else
                        {
                          setState(() {
                            _isLoading=false;
                          });
                          print("signip failed");
                        }
                      } );
                    }

                  },
                  child: Text("Login",style: TextStyle(fontSize: 18,color: Colors.white),),
                ),
                decoration: BoxDecoration(
                  color: Colors.lightGreen,
                  borderRadius: BorderRadius.circular(10)
                ),
              ),
              SizedBox(
                height: size.height/15,
              ),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpScreen()));
              }, child:
              Text("Don't have an Account SignUp"),
              )
            ],
          ),
        ),
      ),
    );


  }
  Widget field(Size size,String hinttext,IconData icons,TextEditingController controller){
        return Container(
height: size.height/15,
        width: size.width/1.2,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: Icon(icons),
            hintText: hinttext,
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),

            ),


          ),
        ),
        );
  }


}
