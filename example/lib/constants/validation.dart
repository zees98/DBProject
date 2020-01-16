String validateName(String name) {
  return RegExp(r'[A-z ]').hasMatch(name) ? null : 'Invalid Name';
}

String validateEmail(String email) {
  var pattern = RegExp(r'[A-Za-z]+[A-z0-9]{0,}@[A-Za-z]+\.(com|net|org)');
  if (!pattern.hasMatch(email))
    return 'Your email is invalid';
  
  else
    {

    }
}

String validatePassword(String password) {
  return password.length < 8 ? 'Passowrd to Short' : null;
}

String validateBirthDay(DateTime date) {
  if(date.toString().isEmpty || date == null) 
    return 'Please select a date';
  else if((DateTime.now().year - date.year) < 18)
   return 'Too young';
  else 
  return null;

}

String validatePhone(String phone) {
  if(RegExp(r'03[0-9]{9}').hasMatch(phone))
    return null;
  else if (RegExp(r'[0-9}]{7,13}').hasMatch(phone))
    return null ;
  else 
    return 'Inavlid Phone Number'; 
}
void validateAddress(String address) {

}
