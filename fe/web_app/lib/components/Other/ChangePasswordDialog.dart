import 'package:flutter/material.dart';
import 'package:web_app/services/api/institution.api.dart';
import 'package:web_app/services/storage.services.dart';

class ChangePasswordDialog extends StatefulWidget {
  ChangePasswordDialog();

  @override
  _ChangePasswordDialogState createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {

  final currentPassword = TextEditingController();
  final newPassword1 = TextEditingController();
  final newPassword2 = TextEditingController();

  String errorText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0)
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.005,
          vertical: MediaQuery.of(context).size.width * 0.007
        ),
        width: MediaQuery.of(context).size.width * 0.23,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Promeni lozinku',
              style: TextStyle(
                color: Colors.black,
                fontSize: MediaQuery.of(context).size.width * 0.013
              ),
            ),
            oldPasswordField(),
            newPasswordFirstField(),
            newPasswordSecondField(),
            makeButtons(),
            if(errorText != "") Text(
              errorText,
              style: TextStyle(
                color: Colors.red
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row makeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          child: Text('Odustani'),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        FlatButton(
          child: Text('Potvrdi'),
          onPressed: () async {
            var check = checkPasswordValidation(currentPassword.text, newPassword1.text, newPassword2.text);
            if(check)
            {
                await InstitutionAPIServices.changePassword(int.parse(Storage.getUserID), currentPassword.text, newPassword1.text).then((value){
                  if(value == "204")
                    Navigator.pop(context);
                  else if(value == "409")
                  {
                    setState(() {
                      errorText = "Trenutna lozinka korisnika nije validna.";
                    });
                  }
                  else
                  {
                    setState(() {
                      errorText = "Greška prilikom slanja zahteva.";
                    });
                  }
                }
              );
            }
          },
        )
      ],
    );
  }

  Widget oldPasswordField() {
    return Container(
      child: TextFormField(
        obscureText: true,
        controller: currentPassword,
        decoration: InputDecoration(
          labelText: "Trenutna lozinka",
          labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02)
        ),
      ),
    );
  }

  Widget newPasswordFirstField() {
    return Container(
      child: TextFormField(
        obscureText: true,
        controller: newPassword1,
        decoration: InputDecoration(
          labelText: "Nova lozinka",
          labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02)
        ),
      ),
    );
  }

  Widget newPasswordSecondField() {
    return Container(
      child: TextFormField(
        obscureText: true,
        controller: newPassword2,
        decoration: InputDecoration(
          labelText: "Ponovite novu lozinku",
          labelStyle: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02)
        ),
      ),
    );
  }

  Widget changePasswordButton() {
    return Container(
      child: RaisedButton(
        onPressed: () {
          if (checkPasswordValidation(
              currentPassword.text, newPassword1.text, newPassword2.text)) {
            //change password, send data to server
          } else {
            //Navigator.of(context).pop();
          }
        },
        child: Text(
          'Izmeni lozinku',
          style: TextStyle(fontSize: MediaQuery.of(context).size.height * 0.02),
          textAlign: TextAlign.center,
        ),
         shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
      ),
    );
  }

  bool checkPasswordValidation(String oldPasswordValue, String newPassword1, String newPassword2) 
  {
    RegExp passwordReg = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');

    if(newPassword1 != newPassword2)
    {
      setState(() {
        errorText = "Ponovo uneta lozinka se ne poklapa.";
      });
      return false;
    }
    else if(!passwordReg.hasMatch(newPassword1))
    {
      setState(() {
        errorText = "Lozinka mora imati najmanje 8 karaktera, bar 1 veliko slovo i bar jedan broj.";
      });
      return false;
    }
    else
      return true;
  }
}
